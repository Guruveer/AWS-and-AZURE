#setting key pair
resource "aws_key_pair" "key_pair_ec2" {
  key_name   = "key_pair_mid_server"
  public_key = var.mid_server_pub_key
}
