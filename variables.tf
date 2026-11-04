variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "ap-southeast-2"
}

variable "ami_id" {
  description = "Ubuntu 20.04 LTS AMI ID for ap-southeast-2"
  type        = string
  default     = "ami-0dd60a46ecc6eac16"
}

variable "instance_type" {
  description = "EC2 instance sizing"
  type        = string
  default     = "t3.micro"
}

variable "cidr_ipv4" {
  description = "Allowed IPv4 CIDR for ingress TLS traffic"
  type        = string
  default     = "88.34.23.54/32"
}

variable "cidr_ipv6" {
  description = "Allowed IPv6 CIDR for ingress port 8080 traffic"
  type        = string
  default     = "2600:1f18:429:5c00::/56"
}