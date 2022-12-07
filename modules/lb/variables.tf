variable tags {
  type = map(any)
}

variable vpc_id {
  type = string
}

variable subnet_ids {
  type = list(string)
}

variable sg_id {
  type = string
}

variable bucket_log {
  type = string
}

variable ec2_instance_count {
  type = number
}

variable instance_ids {
  type = list(string)
}

variable zone_id {
  description = "Hosted zone id"
  type        = string
}

variable subdomain {
  description = "Subdomain name"
  type        = string
}