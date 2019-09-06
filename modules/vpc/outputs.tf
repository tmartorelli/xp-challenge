output "vpc_id" {
  value = "${aws_vpc.default.id}"
}


output "private_subnet_1" {
  value = "${aws_subnet.private_subnet_1.id}"
}

output "private_subnet_2" {
  value = "${aws_subnet.private_subnet_2.id}"
}

output "public_subnet_1" {
  value = "${aws_subnet.public_subnet_1.id}"
}

output "public_subnet_2" {
  value = "${aws_subnet.public_subnet_2.id}"
}

output "dmz_subnet_1" {
  value = "${aws_subnet.dmz_subnet_1.id}"
}

output "dmz_subnet_2" {
  value = "${aws_subnet.dmz_subnet_2.id}"
}