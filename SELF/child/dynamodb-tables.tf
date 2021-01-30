resource "aws_dynamodb_table" "terraform_locks" {
 
  #depends_on=[aws_s3_bucket.terraform_state]
  name         = format("terraform_locks_%s",lower(basename(path.cwd)))
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}