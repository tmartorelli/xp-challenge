resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.bucket_name}"
  acl    = "private"

  provisioner "local-exec" {
    command = "aws s3 cp ${var.path_s3_file} s3://${var.bucket_name}/webserver_bucket/ --recursive"
  }

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



