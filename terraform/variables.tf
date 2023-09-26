variable "do_token" {
  type      = string
  sensitive = true
}

variable "do_region" {
  type = string
}

variable "do_webserver_tag" {
  type = string
}

variable "datadog_api_key" {
  type      = string
  sensitive = true
}

variable "datadog_app_key" {
  type      = string
  sensitive = true
}

variable "datadog_api_url" {
  type = string
}

variable "domain_name" {
  type = string
}
