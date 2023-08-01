data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "nuvolar" {
  ami           = data.aws_ami.ubuntu.id
  ebs_optimized = true
  instance_type = "t3.medium"
  key_name      = aws_key_pair.nuvolar.key_name
  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }
  vpc_security_group_ids      = [aws_security_group.nuvolar.id]
  subnet_id                   = aws_subnet.pub.id
  user_data_base64            = filebase64("${path.module}/user-data.sh")
  user_data_replace_on_change = true

  tags = {
    Name = "nuvolar"
  }
  lifecycle {
    ignore_changes        = [ami]
    create_before_destroy = true
  }
}

resource "tls_private_key" "nuvolar" {
  algorithm = "RSA"
}

resource "local_sensitive_file" "nuvolar-key" {
  content  = tls_private_key.nuvolar.private_key_pem
  filename = "cloud-keys/nuvolar.pem"
}

output "nuvolar-ssh" {
  value = "ssh -i cloud-keys/nuvolar.pem ubuntu@${aws_eip.nuvolar.public_ip}"
}

resource "aws_key_pair" "nuvolar" {
  key_name   = "nuvolar"
  public_key = tls_private_key.nuvolar.public_key_openssh
}

resource "aws_eip" "nuvolar" {
  instance = aws_instance.nuvolar.id
  domain   = "vpc"
}
