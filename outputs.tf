output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.web_server.id
}

output "instance_public_ip" {
  description = "EC2 Instance Public IP"
  value       = aws_instance.web_server.public_ip
}

output "security_group_id" {
  description = "Attached Security Group ID"
  value       = aws_security_group.allow_tls.id
}