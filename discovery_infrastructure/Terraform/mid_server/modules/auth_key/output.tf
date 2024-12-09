output "key_name" {
  value       = aws_key_pair.key_pair_ec2.key_name
  description = "key pair name"
}
