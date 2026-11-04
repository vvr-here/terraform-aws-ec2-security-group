# AWS EC2 & Security Group Deployment with Terraform

[![Terraform](https://img.shields.io/badge/Terraform-1.5%2B-623CE4?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS Provider](https://img.shields.io/badge/AWS%20Provider-5.0%2B-FF9900?logo=amazon-aws&logoColor=white)](https://registry.terraform.io/providers/hashicorp/aws/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This repository contains modular, production-ready **HashiCorp Terraform** code to provision an **Amazon EC2 instance** attached to a custom **AWS Security Group** with standalone IPv4/IPv6 ingress and egress rules.

---

## 📁 Repository Structure

```text
├── .gitignore
├── README.md
├── providers.tf         # Terraform and AWS provider configuration
├── variables.tf         # Input variables for CIDR blocks, instance type, AMI, etc.
├── security_groups.tf   # Security group and granular ingress/egress rules
├── main.tf              # EC2 instance definition and security group attachment
└── outputs.tf           # Exported values (Public IP, Instance ID, SG ID)
```

---

## 🏗️ Architecture Overview

* **Region:** `ap-southeast-2` (Sydney)
* **Instance:** `t3.micro` (Ubuntu 20.04 LTS)
* **Security Rules:**
  * **Ingress (HTTPS/TLS - Port 443):** Restricted to allowed IPv4 CIDR range.
  * **Ingress (Custom App - Port 8080):** Restricted to allowed IPv6 CIDR range.
  * **Egress (Outbound):** All traffic permitted for IPv4 and IPv6.

---

## 💻 Configuration Files

### 1. `providers.tf`
Specifies the required Terraform version and AWS provider (`~> 5.0` is required for modern security group rule resources).

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

### 2. `variables.tf`
Centralizes configurable parameters to keep the codebase flexible and maintainable.

```hcl
variable "aws_region" {
  description = "AWS region for provisioning resources"
  type        = string
  default     = "ap-southeast-2"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance (Ubuntu 20.04 LTS in ap-southeast-2)"
  type        = string
  default     = "ami-0dd60a46ecc6eac16"
}

variable "instance_type" {
  description = "EC2 instance size"
  type        = string
  default     = "t3.micro"
}

variable "cidr_ipv4" {
  description = "Allowed IPv4 CIDR block for inbound TLS"
  type        = string
  default     = "88.34.23.54/32"
}

variable "cidr_ipv6" {
  description = "Allowed IPv6 CIDR block for inbound port 8080"
  type        = string
  default     = "2600:1f18:429:5c00::/56"
}
```

### 3. `security_groups.tf`
Utilizes decoupled rule resources (`aws_vpc_security_group_ingress_rule` and `aws_vpc_security_group_egress_rule`) to prevent state drift and dependency cycles.

```hcl
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Security group allowing TLS and custom ingress/egress rules"

  tags = {
    Name = "allow_tls"
  }
}

# --- Ingress Rules ---

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.cidr_ipv4
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"

  tags = {
    Name = "allow-tls-ipv4"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv6         = var.cidr_ipv6
  from_port         = 8080
  to_port           = 8080
  ip_protocol       = "tcp"

  tags = {
    Name = "allow-8080-ipv6"
  }
}

# --- Egress Rules ---

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # Semantically equivalent to all ports and protocols

  tags = {
    Name = "egress-all-ipv4"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # Semantically equivalent to all ports and protocols

  tags = {
    Name = "egress-all-ipv6"
  }
}
```

### 4. `main.tf`
Provisions the EC2 instance and binds the created security group to it.

```hcl
resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = var.instance_type

  # Associate custom security group with the instance
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  tags = {
    Name = "Terraform-EC2-Instance-security-grp"
  }
}
```

### 5. `outputs.tf`
Displays key connection details upon successful deployment.

```hcl
output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.web_server.id
}

output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.web_server.public_ip
}

output "security_group_id" {
  description = "The ID of the created Security Group"
  value       = aws_security_group.allow_tls.id
}
```

---

## 🚀 Getting Started

### Prerequisites

1. **Terraform CLI** installed (`v1.5.0` or higher). Verify with:
   ```bash
   terraform version
   ```
2. **AWS CLI** installed and authenticated with necessary permissions (`AmazonEC2FullAccess`):
   ```bash
   aws sts get-caller-identity
   ```

---

### Step-by-Step Deployment

1. **Clone the repository:**
   ```bash
   git clone https://github.com/<your-username>/terraform-ec2-security-group.git
   cd terraform-ec2-security-group
   ```

2. **Initialize Terraform:**
   Initializes the working directory and downloads the AWS provider plugins.
   ```bash
   terraform init
   ```

3. **Format and Validate Code:**
   Ensure formatting standards and validate syntax.
   ```bash
   terraform fmt -check
   terraform validate
   ```

4. **Generate Execution Plan:**
   Review the resources that will be provisioned.
   ```bash
   terraform plan
   ```

5. **Apply Configuration:**
   Deploy the resources to your AWS account.
   ```bash
   terraform apply -auto-approve
   ```

---

## 🧹 Cleanup & Resource Destruction

To avoid incurring ongoing charges for the EC2 instance, destroy all created resources when finished:

```bash
terraform destroy -auto-approve
```

---

## 🔒 Security Best Practices Implemented

* **Decoupled Security Rules:** Utilizes `aws_vpc_security_group_ingress_rule` rather than inline `ingress` blocks, eliminating circular dependency errors and minimizing accidental rule deletion during updates.
* **Principle of Least Privilege:** Ports 443 and 8080 are constrained to explicit CIDR blocks rather than open to the entire internet (`0.0.0.0/0`).
* **Environment Parameterization:** Variable-driven architecture enables quick swapping across testing, staging, and production environments.

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
