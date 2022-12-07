resource "aws_s3_bucket" "b_01" {
  bucket = "balin-bucket-02"

  tags = merge(
    var.tags,
    {
      Name : "balin-bucket-02"
    }
  )
}

resource "aws_s3_bucket_acl" "acl_01" {
  bucket = aws_s3_bucket.b_01.id
  acl    = "private"
}