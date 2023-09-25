terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

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
  resources   = flatten([
    digitalocean_droplet.terra-web-server.*.urn,
    digitalocean_database_cluster.terra-db-1.urn,
    digitalocean_loadbalancer.loadbalancer.urn
  ])
}

resource "digitalocean_droplet" "terra-web-server" {
  count = 2
  image  = "ubuntu-22-04-x64"
  name   = "terra-web-0${count.index + 1}"
  region = "ams3"
  size   = "s-1vcpu-1gb"
  tags   = ["web"]
  ssh_keys = [data.digitalocean_ssh_key.main.id]
}

resource "digitalocean_database_cluster" "terra-db-1" {
  name       = "terra-db-1"
  engine     = "pg"
  version    = "15"
  size       = "db-s-1vcpu-1gb"
  region     = "ams3"
  node_count = 1
  tags   = ["db"]
}

resource "digitalocean_database_firewall" "terra-db-fw" {
  cluster_id = digitalocean_database_cluster.terra-db-1.id

  rule {
    type  = "tag"
    value = "web"
  }
}

resource "digitalocean_loadbalancer" "loadbalancer" {
  name   = "lb-1"
  region = "ams3"

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 8080
    target_protocol = "http"
  }

  healthcheck {
    port     = 22
    protocol = "tcp"
  }

  droplet_tag = "web"
}

# Export data for external tools
data "digitalocean_droplets" "webservers" {
  filter {
    key = "tags"
    values = ["web"]
  }

  depends_on = [digitalocean_droplet.terra-web-server]
}

data "digitalocean_database_cluster" "terra-db-data" {
  name = "terra-db-1"
  depends_on = [digitalocean_database_cluster.terra-db-1]
}

output "webservers_yml" {
  value = templatefile(
    "${path.module}/templates/webservers.yml.tftpl",
    { ipv4_address = data.digitalocean_droplets.webservers.droplets.*.ipv4_address }
  )
  sensitive = true
}

output "db_yml" {
  value = templatefile(
    "${path.module}/templates/db.yml.tftpl",
    { db_cluster = data.digitalocean_database_cluster.terra-db-data }
  )
  sensitive = true
}