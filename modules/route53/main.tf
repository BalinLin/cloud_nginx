resource "aws_route53_zone" "ddaws-test" {
  name = "ddaws-test.visiononedd.com"

  tags = merge(
    var.tags,
    {
      Name : "ddaws-test.visiononedd.com"
    }
  )
}
