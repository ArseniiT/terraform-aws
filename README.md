# Terraform-AWS Project: EC2 with Apache-PHP, and MySQL

This Terraform project creates two EC2 instances on AWS:
1. **Apache - PHP Server**
2. **MySQL Server**




## Instructions

### 1. You can run the project inside a Vagrant virtual machine
This project includes a `Vagrantfile` that allows you to set up a local virtual machine for testing.
You can run all Terraform commands inside the Vagrant VM.

Start the VM
```
vagrant up
```
Connect to the VM
```
vagrant ssh
```


### 2. Set up AWS credentials inside the VM
To use Terraform with AWS, you need to configure AWS credentials.
You can find them under **AWS Academy** => **AWS Details** => **AWS CLI: Show**.

 #### 2.1. Configure AWS CLI with the command:

```
aws configure
```

Enter the following details:
```
AWS Access Key ID [None]: ***
AWS Secret Access Key [None]: ***
Default region name [None]: us-east-1
Default output format [None]: json
```
#### 2.2. Create or open the `~/.aws/credentials` file by running:
```
sudo nano ~/.aws/credentials
```
Paste all the credentials you obtained from **AWS Academy** into this file.



### 3. Clone this repository
```
git clone https://github.com/ArseniiT/tf-aws.git
cd tf-aws
```


### 4. Initialize Terraform
```
terraform init
```

### 5.  Deployment
Apply the Terraform configuration
```
terraform plan
terraform apply -var-file="terraform.tfvars"
```

### 6.  URL

Once Terraform has successfully applied , you will see the public URL in the console.
