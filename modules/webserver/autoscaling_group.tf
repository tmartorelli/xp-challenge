resource "aws_iam_instance_profile" "instance" {
  name = "instance_launcher"
  role = "${aws_iam_role.instance.name}"
}


resource "aws_iam_role" "instance" {
  name = "instance_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

  
resource "aws_iam_role_policy_attachment" "s3_full_access" {
  role = "${aws_iam_role.instance.name}"
  policy_arn = "${var.s3_full_access_policy}"
}


