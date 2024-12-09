variable "availability_zone_1" {
  type        = string
  description = "avaialbility zone"
}

variable "availability_zone_2" {
  type        = string
  description = "secondary avaialbility zone"
}
variable "account_name" {
  type        = string
  description = "account name"

}

variable "instances" {
  description = "Instance Object from tfvars file for VM"
}

variable "ami_windows" {

  description = "Complete AMI details"

}

variable "region" {
  description = "region of resources"
}

variable "tags" {
  type        = map(string)
  description = "Entire resource tagging"
}

/*variable "mid_server_pub_key" {
  
  description = "public key for mid server"

}*/

variable "subnet_id" {

  description = "mid server subnet"

}

variable "subnet_id_2" {

  description = "mid server subnet"

}

variable "subnet_delegates" {

}

variable "vpc_id" {

  description = "vpc id"

}

variable "instance_profile" {

  description = "instance profile"

}

variable "mid_server_autoscalling_group" {}
variable "mid-server-lifecycle-termination-heartbeat-timeout" {

  description = "Timeout on ASG lifecycle heartbeats for Terminating events (in seconds)"
  default     = 100
  type        = number

}

variable "vault_url" {

  description = "KMaaS url"
}

variable "vault_namespace" {

  description = "KMaaS namespace"

}

variable "vault_role" {

  description = "KMaaS role"

}

