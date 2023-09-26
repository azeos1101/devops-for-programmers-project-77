provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "main" {
  name = "G15"
}

resource "digitalocean_project" "hexlet-project-3" {
  name        = "hexlet-project-3"
  description = "Hexlet Terraform project"
  purpose     = "Web Application"
  environment = "Production"
  resources = flatten([
    digitalocean_droplet.terra-web-server.*.urn,
    digitalocean_database_cluster.terra-db-1.urn,
    digitalocean_loadbalancer.loadbalancer.urn,
    digitalocean_domain.default.urn
  ])
}

resource "digitalocean_droplet" "terra-web-server" {
  count     = 2
  image     = "ubuntu-22-04-x64"
  name      = "terra-web-0${count.index + 1}"
  region    = var.do_region
  size      = "s-1vcpu-1gb"
  tags      = [var.do_webserver_tag]
  ssh_keys  = [data.digitalocean_ssh_key.main.id]
}

resource "digitalocean_database_cluster" "terra-db-1" {
  name       = "terra-db-1"
  engine     = "pg"
  version    = "15"
  size       = "db-s-1vcpu-1gb"
  region     = var.do_region
  node_count = 1
  tags       = ["db"]
}

resource "digitalocean_database_firewall" "terra-db-fw" {
  cluster_id = digitalocean_database_cluster.terra-db-1.id

  rule {
    type  = "tag"
    value = var.do_webserver_tag
  }
}

resource "digitalocean_domain" "default" {
  name       = var.domain_name
  ip_address = digitalocean_loadbalancer.loadbalancer.ip
}

resource "digitalocean_certificate" "cert" {
  name    = "le-terra-cert"
  type    = "lets_encrypt"
  domains = [var.domain_name]
}

resource "digitalocean_record" "CNAME-www" {
  domain = digitalocean_domain.default.name
  type   = "CNAME"
  name   = "www"
  value  = "@"
}


resource "digitalocean_loadbalancer" "loadbalancer" {
  name                   = "lb-1"
  region                 = var.do_region
  droplet_tag            = var.do_webserver_tag
  redirect_http_to_https = true

  forwarding_rule {
    entry_port     = 443
    entry_protocol = "https"

    target_port     = 8080
    target_protocol = "http"

    certificate_name = digitalocean_certificate.cert.name
  }

  healthcheck {
    port     = 8080
    protocol = "tcp"
  }

}

# Export data for external tools

output "webservers_yml" {
  value = templatefile(
    "${path.module}/templates/webservers.yml.tftpl",
    { ipv4_address = sort(digitalocean_droplet.terra-web-server.*.ipv4_address) }
  )
  sensitive = true
}

output "db_yml" {
  value = templatefile(
    "${path.module}/templates/db.yml.tftpl",
    { db_cluster = digitalocean_database_cluster.terra-db-1 }
  )
  sensitive = true
}
