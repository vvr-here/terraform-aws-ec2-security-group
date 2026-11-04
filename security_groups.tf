resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow inbound TLS & app traffic"

  tags = {
    Name = "allow_tls"
  }
}

# --- Ingress Rules ---

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  # Connects this rule to the security group created above
  security_group_id = aws_security_group.allow_tls.id

  # Only allow this specific IPv4 address
  cidr_ipv4   = var.cidr_ipv4

  # Port 443 is HTTPS/TLS
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"

  tags = {
    Name = "security_group-1"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv6         = var.cidr_ipv6

  # Port 8080 is typically used for web applications / microservices
  from_port   = 8080
  to_port     = 8080
  ip_protocol = "tcp"

  tags = {
    Name = "security_group-2"
  }
}

# --- Egress Rules ---

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0" # 0.0.0.0/0 means ANY IPv4 address on the internet
  ip_protocol       = "-1"        # "-1" is AWS notation for "ALL protocols & ALL ports"

  tags = {
    Name = "security_group-3"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv6         = "::/0"      # ::/0 is IPv6 equivalent of 0.0.0.0/0 (all internet)
  ip_protocol       = "-1"        # All protocols & all ports

  tags = {
    Name = "security_group-4"
  }
}
