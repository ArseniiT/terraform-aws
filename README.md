# AWS Terraform-AWS Project: EC2 with Apache-PHP, and MySQL

This Terraform project creates two EC2 instances on AWS:
1. **Apache - PHP Server**
2. **MySQL Server**



## Setup and Deployment
Create a `terraform.tfvars` file:
```
db_username = "***"
db_password = "***"
```
Apply Terraform configuration
```
terraform apply -var-file="terraform.tfvars"
```



### Clone this repository
```bash
git clone https://github.com/ArseniiT/terraform-aws.git
cd terraform-aws
