resource "aws_db_subnet_group" "dbsg_01" {
  name       = "dbsg-01"
  subnet_ids = var.subnet_ids

  tags = merge(
    var.tags,
    {
      Name : "dbsg-01"
    }
  )
}

resource "aws_db_instance" "db_01" {
  allocated_storage      = 10
  db_name                = "BalinPostgres"
  engine                 = "postgres"
  engine_version         = "13.7"
  instance_class         = "db.t3.micro"
  username               = "balin_postgres"
  password               = "balin_password"
  # parameter_group_name  = "balin.postgresql.13.7"
  db_subnet_group_name   = aws_db_subnet_group.dbsg_01.name
  vpc_security_group_ids = [var.sg_id]
  skip_final_snapshot    = true

  tags = merge(
    var.tags,
    {
      Name : "PostgreSQL"
    }
  )
}