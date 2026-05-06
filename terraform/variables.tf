variable "aws_region" {
  description = "The AWS region to deploy the infrastructure into"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "The EC2 instance type for the StatusPulse server"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of the SSH key pair to create for accessing the instance"
  type        = string
  default     = "statuspulse"
}

variable "root_volume_size" {
  description = "Size of the root EBS volume in GB"
  type        = number
  default     = 20
}
