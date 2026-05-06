# StatusPulse Terraform Infrastructure

This directory contains Terraform Infrastructure as Code (IaC) to spin up the required AWS resources to run the StatusPulse application.

## Resources Created

- **AWS EC2 Instance**: An Ubuntu 22.04 server to host Docker, the StatusPulse stack, reverse proxy, and Uptime Kuma.
- **Security Group**: Configured to allow SSH (22), HTTP (80), and HTTPS (443) traffic.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed locally.
- An [AWS Account](https://aws.amazon.com/) with programmatic access (Access Key ID & Secret Access Key).
- An existing EC2 Key Pair in your chosen AWS region.

## Configuration

The main variables that you can customize are defined in `variables.tf`. 

You can override defaults by creating a `terraform.tfvars` file:

```hcl
aws_region    = "us-east-1"
instance_type = "t3.micro"
key_name      = "your-aws-ssh-key-name" # REQUIRED
```

## Step-by-Step Usage

1. **Initialize Terraform**
   Downloads the required AWS provider plugins.
   ```bash
   terraform init
   ```

2. **Plan the Deployment**
   Review the resources that Terraform will create.
   ```bash
   terraform plan
   ```

3. **Apply the Configuration**
   Deploy the infrastructure to AWS. You will be prompted to type `yes` to confirm.
   ```bash
   terraform apply
   ```

4. **Access the Server**
   After applying, Terraform will output the `server_public_ip`. Use this IP to SSH into your fresh server and begin running the deployment scripts (or Ansible playbook).
   ```bash
   ssh -i /path/to/your-key.pem ubuntu@<server_public_ip>
   ```

5. **Destroy the Infrastructure**
   When you no longer need the resources, you can tear them down easily.
   ```bash
   terraform destroy
   ```
