variable "env_name" {
  type = "string"
}

variable "iaas" {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "azs" {
  type = "list"
}

variable "ssl_cert" {
  type        = "string"
  description = "the contents of an SSL certificate to be used by the LB"
}

variable "ssl_private_key" {
  type        = "string"
  description = "the contents of an SSL private key to be used by the LB"
}

variable "opsman_id" {
  type = "string"
}

variable "opsman_ip" {
  type = "string"
}

variable "opsman_host" {
  type = "string"
}

variable "opsman_ssh_key" {
  type = "string"
}

variable "opsman_user" {
  type = "string"
}

variable "opsman_password" {
  type = "string"
  default = ""
}

variable "opsman_configuration" {
  type = "string"
  description = "YAML formatted string that contains OpsMan configuration for the director"
}

variable "bosh_director_ip" {
  type = "string"
}

variable "pivnet_token" {
  type = "string"
}

variable "vm_extensions" {
  type = "list"
  default = []
}

variable "pas_product_configuration" {
  type = "string"
}

variable "apps_domain" {
  type = "string"
}

variable "sys_domain" {
  type = "string"
}

variable "pas_version" {
  type = "string"
  default = "2.5.2"
}

variable "tiles" {
  type    = "list"
  default = []
}

variable "tile_versions" {
  type = "map"

  default = {
    "mysql" = "2.5.4"
    "redis" = "2.0.1"
    "rabbit" = "1.15.7"
    "scs" = "2.0.7"
    "metrics" = "1.6.0"
    "healthwatch" = "1.5.2"
    "pcc" = "1.8.0"
  }
}

variable "healthwatch_mysql_instance_type" {
  type = "string"
  default = "automatic"
}

variable "healthwatch_forwarder_instance_type" {
  type = "string"
  default = "automatic"
}

variable "metrics_mysql_instance_type" {
  type = "string"
  default = "automatic"
}

variable "metrics_postgres_instance_type" {
  type = "string"
  default = "automatic"
}

variable "logger_endpoint_port" {
  default = "443"
}

variable "wavefront_token" {
  type    = "string"
  default = ""
}

variable "dependency_blocker" {
  type = "string"
  description = "This is used to ensure various resources block appropriately"
}

variable "web_elb_names" {
  type    = "list"
}

variable "ssh_elb_name" {
  type    = "string"
}

variable "compute_instances" {
  type    = "string"
}