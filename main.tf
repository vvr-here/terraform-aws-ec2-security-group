resource "aws_instance" "web_server" {
  ami           = var.ami_id          # Uses the Ubuntu AMI from variables
  instance_type = var.instance_type   # Uses "t3.micro" from variables

  # CRITICAL LINK:
  # This attaches our custom security group to this EC2 instance.
  # The square brackets [] mean a list of IDs.
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  tags = {
    Name = "Terraform-EC2-Instance-security-grp"
  }
}
