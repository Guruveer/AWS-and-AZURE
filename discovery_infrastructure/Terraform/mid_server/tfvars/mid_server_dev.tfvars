#account_id        = "340502687561"
account_name        = "nbs-shared-snow-dev"
region              = "eu-west-2"
availability_zone_1 = "eu-west-2c"
availability_zone_2 = "eu-west-2c"
subnet_id           = "subnet-0f6d97c864346ec80"
subnet_id_2         = "subnet-0f6d97c864346ec80"
vpc_id              = "vpc-09b19308425818c2b"
instance_profile    = "nbs-shared-snow-dev-servicenow-ec2-ip"
subnet_delegates    = ["10.164.149.64/26", "10.164.149.192/26", "10.164.149.128/26"]
ami_windows = {
  name = "nbs-lz-windows-2019-minimal-*"
  #id = "ami-05eb1ec5448833838"
  owner               = "391635538753"
  source              = "391635538753/nbs-lz-windows-2019-minimal-*"
  virtualization_type = "hvm"
  root_device_type    = "ebs"

}

tags = {
  "business_unit"      = "NBS10"
  "product_code"       = "CA049"
  "application_id"     = "ServiceNow Cloud Discovery"
  "cost_centre"        = "V317"
  "support_team_owner" = "LV3_ServiceNow_Support"
  "environment"        = "Dev"
  "project_code"       = "A622303"
}

instances = {
  mid_server = {
    ec2_count                     = 1
    sku                           = "t2.xlarge"
    subnet_id                     = "subnet-0f6d97c864346ec80"
    name_prefix                   = "mid-server"
    enable_accelerated_networking = true
    delete_os_disk_on_termination = true
    os                            = "windows"
    zone_2                        = "no"
    volume = {
      device_name    = "/dev/xvda"
      aws_ebs_volume = 200
      type           = "gp3"
    }
  }

  mid_server_dr = {
    ec2_count                     = 0
    sku                           = "t2.xlarge"
    subnet_id                     = "subnet-0f6d97c864346ec80"
    name_prefix                   = "mid-server-2"
    enable_accelerated_networking = true
    delete_os_disk_on_termination = true
    os                            = "windows"
    zone_2                        = "yes"
    volume = {
      device_name    = "/dev/xvda"
      aws_ebs_volume = 200
      type           = "gp3"
    }
  }
}

vault_url       = "https://kmaas.nbs-kmaas-preprod.aws.nbscloud.co.uk/"
vault_namespace = "aws/nbs-shared-snow-dev"
vault_role      = "nbs-shared-snow-dev-role-vault-aws-auth"

mid_server_autoscalling_group = {

  mid_server_desired_capacity = 1
  mid_server_max_capacity     = 1
  mid_server_min_capacity     = 1

}
