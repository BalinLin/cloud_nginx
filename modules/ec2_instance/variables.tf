variable tags {
  type = map(any)
}

variable instance_type {
  type = string
}

variable ec2_instance_count {
  type = number
}

variable ami {
  type = string
}

variable disk_size {
  type = number
}

variable disk_type {
  type = string
}

variable subnet_id {
  type = string
}

variable sg_id {
  type = string
}

variable ec2_profile {
  type = string
}

variable nginx_shell_path {
  type  = string
}

variable region {
  type = string
}