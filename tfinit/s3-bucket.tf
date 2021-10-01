
resource "aws_s3_bucket" "terraform_state" {
  depends_on = [null_resource.gen_idfile]
  bucket     = format("tf-eks-state-%s", random_id.id1.hex)
  // This is only here so we can destroy the bucket as part of automated tests. You should not copy this for production
  // usage
  force_destroy = true

  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = true
  }

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  lifecycle {
    ignore_changes = [bucket]
  }
}



resource "aws_s3_bucket_public_access_block" "example" {
	bucket = aws_s3_bucket.terraform_state.id
	block_public_acls   = true
	block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}
