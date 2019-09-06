resource "aws_rds_cluster_instance" "db_istances" {
  count              = 2
  identifier         = "aurora-joomla-${count.index}"
  cluster_identifier = "${aws_rds_cluster.joomla.id}"
  instance_class     = "${var.db_class}"
  db_subnet_group_name = "${var.db_subnetgroup}"
}

resource "aws_rds_cluster" "joomla" {
  cluster_identifier = "aurora-cluster-joomla"
  availability_zones = ["${var.region}a", "${var.region}b"]
  database_name      = "${var.db_name}"
  master_username    = "${var.db_admin}"
  master_password    = "${var.db_passwd}"
  db_subnet_group_name = "${var.db_subnetgroup}"
  vpc_security_group_ids = ["${aws_security_group.private_sg.id}"]
  skip_final_snapshot = true
}

resource "aws_db_subnet_group" "private_db_subnet_group" {
  name       = "${var.db_subnetgroup}"
  subnet_ids = ["${var.private_subnet_1}", "${var.private_subnet_2}"]

  tags = {
    Name = "My DB subnet group"
  }
}



resource "aws_security_group" "private_sg" {
  name        = "private_sg"
  description = "This security group will be applied to database servers"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${var.public_sg}"]
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${var.public_sg}"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }
}