# AWS EC2 & Security Group with Terraform

[![Terraform](https://img.shields.io/badge/Terraform-1.5%2B-623CE4?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS Provider](https://img.shields.io/badge/AWS%20Provider-5.0%2B-FF9900?logo=amazon-aws&logoColor=white)](https://registry.terraform.io/providers/hashicorp/aws/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A clean Terraform setup to deploy an **Ubuntu 20.04 EC2 instance** in `ap-southeast-2` (Sydney) with a dedicated **Security Group** managing IPv4 and IPv6 traffic.

---

## 📁 Project Structure

```text
├── providers.tf         # AWS Provider (~> 5.0)
├── variables.tf         # Region, AMI, Instance type, CIDRs
├── security_groups.tf   # Security group & ingress/egress rules
├── main.tf              # EC2 instance with SG attached
└── outputs.tf           # Instance ID, Public IP, SG ID
```

---

## 💻 Terraform Files

### `providers.tf`
```hcl
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
```

### `variables.tf`
```hcl
variable "aws_region" {
  default = "ap-southeast-2"
}

variable "ami_id" {
  default = "ami-0dd60a46ecc6eac16" # Ubuntu 20.04 LTS
}

variable "instance_type" {
  default = "t3.micro"
}

variable "cidr_ipv4" {
  default = "88.34.23.54/32"
}

variable "cidr_ipv6" {
  default = "2600:1f18:429:5c00::/56"
}
```

### `security_groups.tf`
```hcl
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow inbound TLS & app traffic"
  tags        = { Name = "allow_tls" }
}

# --- Ingress ---
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.cidr_ipv4
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv6         = var.cidr_ipv6
  from_port         = 8080
  to_port           = 8080
  ip_protocol       = "tcp"
}

# --- Egress ---
resource "aws_vpc_security_group_egress_rule" "allow_all_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}
```

### `main.tf`
```hcl
resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  tags = {
    Name = "Terraform-EC2-Instance-security-grp"
  }
}
```

### `outputs.tf`
```hcl
output "instance_id" {
  value = aws_instance.web.id
}

output "instance_public_ip" {
  value = aws_instance.web.public_ip
}

output "security_group_id" {
  value = aws_security_group.allow_tls.id
}
```

---

## 🚀 How to Run

```bash
# 1. Initialize working directory
terraform init

# 2. Check plan
terraform plan

# 3. Apply changes
terraform apply -auto-approve

# 4. Clean up / Destroy
terraform destroy -auto-approve
```

---

## 🛠️ Key Fixes Included

* **AWS Provider `~> 5.0`:** Required for `aws_vpc_security_group_*_rule` resources (v3.x fails).
* **Direct Variable References:** Fixed quotes around variables (`var.cidr_ipv4` instead of `"cidr_ipv4"`).
* **Security Group Binding:** Added `vpc_security_group_ids` to `aws_instance` so the security group is actually attached.

---

## 📄 License
This repository is licensed under the MIT License
