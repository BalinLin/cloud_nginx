variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "aws_profile" {
  type        = string
  description = "AWS CLI profile"
}

variable stack_name {
  type = string
}

variable vpc_cidr {
  type = string
}

variable vpc_subnet_newbits {
  type = number
}

variable vpc_subnet_count {
  type = number
}

variable ec2_instance_type {
  description = "EC2 instance type for worker"
  type        = string
}

variable ec2_instance_count {
  description = "EC2 instance count"
  type        = number
}

variable ec2_ami {
  description = "AMI ID for EC2 instance"
  type        = string
}

variable zone_id {
  description = "Hosted zone id"
  type        = string
}

variable subdomain {
  description = "Subdomain name"
  type        = string
}

variable nginx_shell_path {
  type        = string
}
