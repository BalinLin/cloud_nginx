output instance_state {
    value = aws_instance.instance.*.instance_state
}

output instance_dns {
    value = aws_instance.instance.*.private_dns
}

output instance_ids {
    value = aws_instance.instance.*.id
}