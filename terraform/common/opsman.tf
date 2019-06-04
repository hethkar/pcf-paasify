locals {
  opsman_password = "${random_string.opsman_password.result}"
}

resource "random_string" "opsman_password" {
  length  = 8
  special = false
}

data "template_file" "az_configuration" {
  template = "${chomp(file("${path.module}/templates/az.json"))}"

  vars {
    az_string = "${join(",", formatlist("{\"name\":\"%s\"}", var.azs))}"
  }
}

data "template_file" "network_assignment_configuration" {
  template = "${chomp(file("${path.module}/templates/network_assignment.json"))}"

  vars {
    az = "${var.azs[0]}"
  }
}

data "template_file" "om_configuration" {
  template = "${chomp(file("${path.module}/templates/opsman_config.yml"))}"

  vars {
    az = "${var.azs[0]}"
    provided_configuration = "${var.opsman_configuration}"
  }
}

resource "null_resource" "setup_opsman" {

  provisioner "local-exec" {
    command = "sleep 60"
  }

  provisioner "file" {
    content     = "${var.ssl_cert}"
    destination = "/tmp/tempest.crt"
  }

  provisioner "file" {
    content     = "${var.ssl_private_key}"
    destination = "/tmp/tempest.key"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/opsman/"
    destination = "/tmp"
  }

  provisioner "remote-exec" {
    inline = ["chmod +x /tmp/provision_opsman.sh && /tmp/provision_opsman.sh ${var.pivnet_token} ${var.opsman_host} ${local.opsman_password} ${var.dependency_blocker}"]
  }

  provisioner "file" {
    content     = "${data.template_file.tile_az_configuration.rendered}"
    destination = "~/config/az-noservices-config.json"
  }

  provisioner "file" {
    content     = "${data.template_file.tile_az_services_configuration.rendered}"
    destination = "~/config/az-services-config.json"
  }

  provisioner "file" {
    content     = "${data.template_file.om_configuration.rendered}"
    destination = "~/config/opsman-config.yml"
  }

  provisioner "remote-exec" {
    inline = ["configure_opsman"]
  }

  provisioner "remote-exec" {
    inline = ["chmod +x /tmp/post_install_opsman.sh && /tmp/post_install_opsman.sh ${var.bosh_director_ip}"]
  }

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}


resource "null_resource" "cleanup_opsman" {

  provisioner "remote-exec" {
    when = "destroy"

    inline = ["destroy_opsman ${var.opsman_id} ${var.apps_domain} ${var.sys_domain}"]
  }

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }

  depends_on = ["null_resource.setup_opsman"]
}