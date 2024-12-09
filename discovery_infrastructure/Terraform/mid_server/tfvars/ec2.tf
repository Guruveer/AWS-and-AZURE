module "key_pairs" {
  source             = "../modules/auth_key"
  mid_server_pub_key = data.vault_generic_secret.mid_server_pub_key.data["mid_server_ssh_pub"]
}

module "mid_server_nsg" {

  source           = "../modules/network_security_group"
  account_name     = var.account_name
  vpc_id           = var.vpc_id
  subnet_delegates = var.subnet_delegates
  tags             = var.tags
}

module "mid_servers" {
  depends_on                                         = [module.key_pairs, module.mid_server_nsg]
  for_each                                           = var.instances
  source                                             = "../modules/ec2"
  template_sshd                                      = data.template_file.open_sshd_exec.rendered
  account_name                                       = var.account_name
  availability_zone_1                                = var.availability_zone_1
  availability_zone_2                                = var.availability_zone_2
  key_pair_name                                      = module.key_pairs.key_name
  nsg_id                                             = module.mid_server_nsg.nsg_id
  subnet_id                                          = data.aws_subnet.mid_server_subnet.id
  subnet_id_2                                        = data.aws_subnet.mid_server_subnet_2.id
  vpc_id                                             = data.aws_vpc.mid_server_vpc.id
  ami_windows_id                                     = data.aws_ami.windows.id
  mid_server_desired_capacity                        = var.mid_server_autoscalling_group.mid_server_desired_capacity
  mid_server_max_capacity                            = var.mid_server_autoscalling_group.mid_server_max_capacity
  mid_server_min_capacity                            = var.mid_server_autoscalling_group.mid_server_min_capacity
  mid-server-lifecycle-termination-heartbeat-timeout = var.mid-server-lifecycle-termination-heartbeat-timeout

  #mid_server_pub_key   = data.vault_generic_secret.mid_server_pub_key.data["mid_server_ssh_pub"]
  instance_profile = var.instance_profile
  #sshd_file_path     = "${path.module}/templates/opensshd.ps1"
  #mid_server_pem_key = data.vault_generic_secret.mid_server_pub_key.data["mid_server_ssh_pem"]
  tags            = var.tags
  instance_object = var.instances[each.key]
}
