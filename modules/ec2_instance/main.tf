resource aws_ebs_volume ebs {
  availability_zone = format("%s%s", var.region, "c") # intented hardcode
  count             = var.ec2_instance_count
  size              = var.disk_size
  type              = var.disk_type
  encrypted         = true
  tags = merge(
    var.tags,
    {
      Name: "${var.subnet_id}-disk"
    }
  )
}

resource aws_instance instance {
  count                  = var.ec2_instance_count
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  iam_instance_profile   = var.ec2_profile

  tags = merge(
    var.tags,
    {
      Name : "${var.subnet_id}-instance"
    }
  )

  user_data = file("${var.nginx_shell_path}")
}

resource "aws_volume_attachment" "ebs_att" {
  count       = var.ec2_instance_count
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs[count.index].id
  instance_id = aws_instance.instance[count.index].id
}