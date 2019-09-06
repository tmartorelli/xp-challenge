resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.bucket_name}"
  acl    = "private"

  tags = {
    Name        = "Mybucket"
    Environment = "Production"
  }
}


data "aws_iam_policy_document" "s3_full_access" {
  statement {
    actions = [
      "s3:*"
    ]

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}",
      "${format("%s/*", aws_s3_bucket.s3_bucket.arn)}"
    ]
  }
}

resource "aws_iam_policy" "s3_full_access" {
  name   = "s3_read_access"
  path   = "/"
  policy = "${data.aws_iam_policy_document.s3_full_access.json}"
}



