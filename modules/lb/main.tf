resource "aws_lb_target_group" "tg_01" {
  name     = "tg-01"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name : "tg-01"
    }
  )
}

resource "aws_lb" "lb_01" {
  name               = "lb-01"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_id]
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  # access_logs {
  #   bucket  = var.bucket_log
  #   prefix  = "lb-01"
  #   enabled = true
  # }

  tags = merge(
    var.tags,
    {
      Name : "lb-01"
    }
  )
}

resource "aws_route53_record" "lbrecord_01" {
  zone_id           = var.zone_id
  name              = format("%s%s", var.subdomain, ".ddaws-test.visiononedd.com")
  type              = "A"
  # ttl               = 60
  # records           = [aws_eip.lb.public_ip]

  alias {
    name                   = aws_lb.lb_01.dns_name
    zone_id                = aws_lb.lb_01.zone_id
    evaluate_target_health = true
  }
}

resource "aws_acm_certificate" "cert_01" {
  domain_name       = format("%s%s", var.subdomain, ".ddaws-test.visiononedd.com")
  validation_method = "DNS"

  tags = merge(
    var.tags,
    {
      Name : "cert-01"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "certrecord_01" {
  for_each = {
    for dvo in aws_acm_certificate.cert_01.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.zone_id
}

resource "aws_acm_certificate_validation" "certval_01" {
  certificate_arn         = aws_acm_certificate.cert_01.arn
  validation_record_fqdns = [for record in aws_route53_record.certrecord_01 : record.fqdn]
}

resource "aws_lb_listener" "lbl_01" {
  load_balancer_arn = aws_lb.lb_01.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_01.arn
  }
}

resource "aws_lb_listener" "lbl_02" {
  load_balancer_arn = aws_lb.lb_01.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.certval_01.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_01.arn
  }
}

resource "aws_lb_target_group_attachment" "tga_http_01" {
  count            = var.ec2_instance_count
  target_group_arn = aws_lb_target_group.tg_01.arn
  target_id        = var.instance_ids[count.index]
  port             = 80
}