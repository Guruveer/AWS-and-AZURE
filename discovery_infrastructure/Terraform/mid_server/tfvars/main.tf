data "aws_subnet" "mid_server_subnet" {
  id = var.subnet_id
}

data "aws_subnet" "mid_server_subnet_2" {
  id = var.subnet_id_2
}

data "aws_ami" "windows" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_windows.name]
  }

  filter {
    name   = "virtualization-type"
    values = [var.ami_windows.virtualization_type]
  }

  filter {
    name   = "root-device-type"
    values = [var.ami_windows.root_device_type]
  }

  owners = [var.ami_windows.owner]
}

data "aws_vpc" "mid_server_vpc" {
  id = var.vpc_id
}

data "vault_generic_secret" "mid_server_pub_key" {
  path = "secrets/midserver"
}
