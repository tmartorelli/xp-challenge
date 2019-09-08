output "private_sg" {
  value = "${aws_security_group.private_sg.id}"
}

output "db_endpoint" {
  value = "${aws_rds_cluster.joomla.endpoint}"
}

output "db_admin" {
  value = "${aws_rds_cluster.joomla.master_username}"
}
