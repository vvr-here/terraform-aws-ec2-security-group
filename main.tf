resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = var.instance_type

  # Attaches the EC2 instance to the created security group
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  tags = {
    Name = "Terraform-EC2-Instance-security-grp"
  }
}