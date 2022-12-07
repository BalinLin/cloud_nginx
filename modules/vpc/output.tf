output vpc_id {
    value = aws_vpc.vpc_01.id
}

output subnet_ids {
    value = aws_subnet.sn_01[*].id
}

output sg_id {
    value = aws_security_group.sg_01.id
}
