# AWS EC2 Instance & Security Group Deployment with Terraform

[![Terraform](https://img.shields.io/badge/Terraform-1.5%2B-623CE4?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS Provider](https://img.shields.io/badge/AWS%20Provider-5.0%2B-FF9900?logo=amazon-aws&logoColor=white)](https://registry.terraform.io/providers/hashicorp/aws/latest)
[![Validation](https://img.shields.io/badge/Validated-Passing-success?logo=checkmarx&logoColor=white)](#validation--testing)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A production-ready Terraform configuration to deploy an Amazon EC2 instance (Ubuntu 20.04 LTS) in `ap-southeast-2` (Sydney) with a decoupled, granular AWS Security Group managing both IPv4 and IPv6 traffic.

---

## 📑 Table of Contents

- [Architecture Overview](#-architecture-overview)
- [Project Structure](#-project-structure)
- [Terraform Codebase](#-terraform-codebase)
  - [1. providers.tf](#1-providerstf)
  - [2. variables.tf](#2-variablestf)
  - [3. security_groups.tf](#3-security_groupstf)
  - [4. main.tf](#4-maintf)
  - [5. outputs.tf](#5-outputstf)
- [Quick Start](#-quick-start)
- [Validation & Verification](#-validation--verification)
- [Key Improvements & Fixes](#-key-improvements--fixes)
- [Cleanup](#-cleanup)
- [License](#-license)

---

## 🏛️ Architecture Overview
