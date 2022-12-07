output iam_id {
    value = aws_iam_role.ec2_role_01.id
}

output ec2_profile_name {
    value = aws_iam_instance_profile.ec2_profile_01.name
}