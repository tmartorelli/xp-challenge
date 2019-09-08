variable "db_name" {
  description = "The name for the DB istance"
  type        = "string"
  default     = "joomla"
}

variable "vpc_id" {
  description = "The ID of the vpc to use"
}


variable "private_subnet_1" {
  description = "The subnet used for DB"
  type        = "string"
}

variable "private_subnet_2" {
  description = "The subnet used for DB"
  type        = "string"
}



variable "db_subnetgroup" {
  description = "The name of the subnet group used for the DB cluster"
  type        = "string"
}


variable "db_admin" {
  description = "The username for the DB administrator user"
  type        = "string"
}


variable "db_passwd" {
  description = "The password used for administrator user access"
  type        = "string"
}

variable "db_class" {
  description = "The db instance class used for DB"
  type        = "string"
  default     = "db.t3.medium"
}

variable "region" {
  type    = "string"
  default = "eu-west-1"
}

variable "public_sg" {
  description = "The ID of the application security group"
  type        = "string"
}




