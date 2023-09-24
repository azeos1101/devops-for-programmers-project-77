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
  resources   = [
    digitalocean_droplet.terra-web-1.urn,
    digitalocean_droplet.terra-web-2.urn,
    digitalocean_database_cluster.terra-db-1.urn,
    digitalocean_loadbalancer.loadbalancer.urn
  ]
}

resource "digitalocean_droplet" "terra-web-1" {
  image  = "ubuntu-22-04-x64"
  name   = "terra-web-1"
  region = "ams3"
  size   = "s-1vcpu-1gb"
  tags   = ["web"]
  ssh_keys = [data.digitalocean_ssh_key.main.id]
  user_data = data.template_file.db_connection.rendered
}

resource "digitalocean_droplet" "terra-web-2" {
  image  = "ubuntu-22-04-x64"
  name   = "terra-web-2"
  region = "ams3"
  size   = "s-1vcpu-1gb"
  tags   = ["web"]
  ssh_keys = [data.digitalocean_ssh_key.main.id]
  user_data = data.template_file.db_connection.rendered
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

data "template_file" "db_connection" {
  template = "${file("${path.module}/templates/db.tpl")}"
  vars = {
    db_type="postgres"
    database="${data.digitalocean_database_cluster.terra-db-data.database}"
    host="${data.digitalocean_database_cluster.terra-db-data.private_host}"
    port="${data.digitalocean_database_cluster.terra-db-data.port}"
    user="${data.digitalocean_database_cluster.terra-db-data.user}"
    password="${data.digitalocean_database_cluster.terra-db-data.password}"
  }
}

data "digitalocean_database_cluster" "terra-db-data" {
  name = "terra-db-1"
}
