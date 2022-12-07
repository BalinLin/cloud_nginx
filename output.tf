output vpc_id {
    value = module.vpc.vpc_id
}

output instance_state {
    value = module.ec2.*.instance_state
}

output instance_dns {
    value = module.ec2.*.instance_dns
}

output ec2_profile_name {
    value = module.iam.ec2_profile_name
}

output iam_id {
    value = module.iam.iam_id
}

output db_id {
    value = module.rds.db_id
}

output bucket_id {
    value = module.s3.bucket_id
}

output subnet_ids {
    value = module.vpc.subnet_ids
}

output route53_id {
    value = module.route53.route53_id
}

output lb_id {
    value = module.lb.lb_id
}

output sms_id {
    value = module.sm.sms_id
}
