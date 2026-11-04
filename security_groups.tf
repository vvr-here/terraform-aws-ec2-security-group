resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow inbound TLS & app traffic"

  tags = {
    Name = "allow_tls"
  }
}
