resource "aws_secretsmanager_secret" "sms_01" {
  name = "sms-01"
  recovery_window_in_days = 0

  tags = merge(
    var.tags,
    {
      Name : "sms-01"
    }
  )
}