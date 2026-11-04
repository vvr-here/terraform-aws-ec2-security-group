variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-2"   # Sydney region
}

variable "ami_id" {
  description = "Ubuntu 20.04 LTS AMI ID"
  type        = string
  default     = "ami-0dd60a46ecc6eac16" # Pre-configured OS image ID in Sydney
}

variable "instance_type" {
  type    = string
  default = "t3.micro"             # 2 vCPUs, 1 GiB RAM (Free tier eligible)
}

variable "cidr_ipv4" {
  type    = string
  default = "88.34.23.54/32"       # /32 means exactly ONE single IPv4 IP address
}

variable "cidr_ipv6" {
  type    = string
  default = "2600:1f18:429:5c00::/56" # IPv6 network range
}
