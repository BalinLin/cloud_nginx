resource aws_vpc vpc_01 {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = merge(
    var.tags,
    {
      Name : substr(var.vpc_cidr, 0, length(var.vpc_cidr) - 3)
    }
  )
}

resource "aws_eip" "eip_01" {
  vpc      = true
}

resource "aws_internet_gateway" "gw_01" {
  vpc_id = aws_vpc.vpc_01.id

  tags = merge(
    var.tags,
    {
      Name : "${substr(var.vpc_cidr, 0, length(var.vpc_cidr) - 3)}-ig-01"
    }
  )

  depends_on = [aws_vpc.vpc_01]
}

resource "aws_security_group" "sg_01" {
  name        = "sgroup-01"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc_01.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] # [aws_vpc.vpc_01.cidr_block]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] # [aws_vpc.vpc_01.cidr_block]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  ingress {
    description      = "HTTPS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] # [aws_vpc.vpc_01.cidr_block]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    var.tags,
    {
      Name : "${substr(var.vpc_cidr, 0, length(var.vpc_cidr) - 3)}-sgroup-01"
    }
  )

  depends_on = [aws_vpc.vpc_01]
}

resource aws_subnet sn_01 {
  count = var.vpc_subnet_count

  vpc_id            = aws_vpc.vpc_01.id
  cidr_block        = cidrsubnet(var.vpc_cidr, var.vpc_subnet_newbits, count.index)
  availability_zone = count.index == 0 ? format("%s%s", var.region, "a") : format("%s%s", var.region, "c")
  map_public_ip_on_launch = count.index == 0 ? "true" : "false"

  tags = merge(
    var.tags,
    {
      Name : "${substr(var.vpc_cidr, 0, length(var.vpc_cidr) - 3)}-subnet-01-${count.index}"
    }
  )

  depends_on = [aws_internet_gateway.gw_01]
}

resource "aws_nat_gateway" "natgw_01" {
  allocation_id = aws_eip.eip_01.id
  subnet_id     = aws_subnet.sn_01[0].id

  tags = merge(
    var.tags,
    {
      Name : "${substr(var.vpc_cidr, 0, length(var.vpc_cidr) - 3)}-natgw-01"
    }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw_01]
}

resource "aws_route_table" "rt_ig_01" {
  vpc_id = aws_vpc.vpc_01.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_01.id
  }

  tags = merge(
    var.tags,
    {
      Name : "${substr(var.vpc_cidr, 0, length(var.vpc_cidr) - 3)}-rt-ig-01"
    }
  )

  depends_on = [aws_internet_gateway.gw_01]
}

resource "aws_route_table_association" "rta_ig_01" {
  subnet_id      = aws_subnet.sn_01[0].id
  route_table_id = aws_route_table.rt_ig_01.id
}

resource "aws_route_table" "rt_nat_01" {
  vpc_id = aws_vpc.vpc_01.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw_01.id
  }

  tags = merge(
    var.tags,
    {
      Name : "${substr(var.vpc_cidr, 0, length(var.vpc_cidr) - 3)}-rt-nat-01"
    }
  )

  depends_on = [aws_nat_gateway.natgw_01]
}

resource "aws_route_table_association" "rta_nat_01" {
  subnet_id      = aws_subnet.sn_01[1].id
  route_table_id = aws_route_table.rt_nat_01.id
}