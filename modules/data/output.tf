output "s3_full_access_policy" {
  value = "${aws_iam_policy.s3_full_access.arn}"
}

