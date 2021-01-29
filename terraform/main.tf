terraform {
  required_version = ">= 0.14"
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}

variable "compute_names" {
    type = list(string)
    default = ["compute-0", "compute-1"]
    description = "A list of hostnames for the compute nodes"
}

variable "cluster_name" {
    type = string
    description = "Name for cluster, used as prefix for resources"
}

variable "key_pair" {
    type = string
    description = "Name of an existing keypair in OpenStack"
}

variable "login_flavor" {
    type = string
}

variable "login_image" {
    type = string
}

variable "compute_flavor" {
    type = string
}

variable "compute_image" {
    type = string
}

variable "cidr" {
    type = string
    default = "192.168.42.0/24"
    description = "Range in CIDR notation of created subnet"
}

resource "openstack_networking_network_v2" "cluster" {
    name           = var.cluster_name
    admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "cluster" {
    name            = var.cluster_name
    network_id      = openstack_networking_network_v2.cluster.id
    cidr            = var.cidr
    ip_version      = 4
}

resource "openstack_compute_instance_v2" "login" {
  name = "${var.cluster_name}-login-0"
  image_name = var.login_image
  flavor_name = var.login_flavor
  key_pair = var.key_pair
  network {
    uuid = openstack_networking_network_v2.cluster.id
  }
}


resource "openstack_compute_instance_v2" "compute" {

  for_each = toset(var.compute_names)

  name = "${var.cluster_name}-${each.value}"
  image_name = var.compute_image
  flavor_name = var.compute_flavor
  #flavor_name = "compute-A"
  key_pair = var.key_pair
  network {
    uuid = openstack_networking_network_v2.cluster.id
  }
}

# TODO: needs fixing for case where creation partially fails resulting in "compute.network is empty list of object"
resource "local_file" "hosts" {
  content  = templatefile("${path.module}/inventory.tpl",
                          {
                            "cluster_name": var.cluster_name
                            "login": openstack_compute_instance_v2.login,
                            "computes": openstack_compute_instance_v2.compute,
                          },
                          )
  filename = "../inventory/hosts"
}
