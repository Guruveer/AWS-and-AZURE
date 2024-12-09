variable "availability_zone_1" {
  type        = string
  description = "avaialbility zone"
}

variable "availability_zone_2" {
  type        = string
  description = "second avaialbility zone"
}

variable "account_name" {
  type        = string
  description = "account name"

}

variable "instance_object" {
  description = "Instance Object from tfvars file for VM"
}

variable "ami_windows_id" {

  description = "AMI id for windows"

}

variable "tags" {
  type        = map(string)
  description = "Entire resource tagging"
}

/*variable "mid_server_pub_key" {

  description = "servers ssh key"

}*/

variable "key_pair_name" {

  description = "key pair name"

}

variable "subnet_id" {

  description = "mid server subnet"

}

variable "subnet_id_2" {

  description = "mid server subnet"

}

variable "vpc_id" {

  description = "vpc id"

}

variable "nsg_id" {
  description = "network security group id"
}

variable "instance_profile" {

  description = "instance profile"

}

variable "mid_server_desired_capacity" {}
variable "mid_server_max_capacity" {}
variable "mid_server_min_capacity" {}
variable "mid-server-lifecycle-termination-heartbeat-timeout" {}

variable "template_sshd" {

  description = "open sshd template"

}

/*variable "sshd_file_path" {

}

variable "mid_server_pem_key" {

  description = "servers ssh key"

}*/
