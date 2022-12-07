output bucket_id {
    value = aws_s3_bucket.b_01.id
}

output bucket_log {
    value = aws_s3_bucket.b_01.bucket
}