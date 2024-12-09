variable "account_name" {
  type        = string
  description = "account name"

}

variable "vpc_id" {

  description = "vpc id"

}

variable "tags" {
  type        = map(string)
  description = "Entire resource tagging"
}

variable "subnet_delegates" {

}
