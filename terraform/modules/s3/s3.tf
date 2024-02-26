resource "awscc_s3_bucket" "s3bucket" {

  public_access_block_configuration = {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
  provisioner "local-exec" {
    command = "echo ${self.bucket_name} > file.txt"
  }
}

resource "aws_s3_object" "object" {
  bucket = awscc_s3_bucket.s3bucket.bucket_name
  key    = "index.html"
  source = "./index.html"
  etag   = filemd5("./index.html")
  
}

output "s3bucketname" {
  value = awscc_s3_bucket.s3bucket.bucket_name
}