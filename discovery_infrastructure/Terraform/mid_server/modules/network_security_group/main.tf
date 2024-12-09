resource "aws_security_group" "mid_server_sg" {
  name        = "${var.account_name}-ec2-nsg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow from Outside"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "RDP"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["10.160.0.0/16"]
  }

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.160.69.0/24"]
  }

  ingress {
    description = "SSH from Delegates"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.subnet_delegates
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    Name = "${var.account_name}-ec2-nsg"
    },
    var.tags
  )
}
