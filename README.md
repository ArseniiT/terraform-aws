# AWS Terraform-AWS Project: EC2 with Apache-PHP, and MySQL

This Terraform project creates two EC2 instances on AWS:
1. **Apache - PHP Server**
2. **MySQL Server**

### Clone this repository
```
git clone https://github.com/ArseniiT/terraform-aws.git
cd terraform-aws
```


## Setup and Deployment
Create a `terraform.tfvars` file from `terraform.tfvars.example` :
```
cp terraform.tfvars.example terraform.tfvars
```

In `terraform.tfvars` file, replace *** with your credentials.
```
db_username = "***"
db_password = "***"
```

Apply the Terraform configuration
```
terraform apply -var-file="terraform.tfvars"
```



### Clone this repository
```bash
git clone https://github.com/ArseniiT/terraform-aws.git
cd terraform-aws
