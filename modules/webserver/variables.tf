variable "ssh_cidr" {
  description = "The cidr list allowed to ssh"
  type = "list"
  default = ["0.0.0.0/0"]
}

variable "vpc_id" {
  description = "VPC ID to use"
  type = "string"
}

variable "min_instances" {
  description = "The minimum size of the instances"
  type = "string"
  default = "2"
}

variable "max_instances" {
  description = "The maximum size of the instances"
  type = "string"
  default = "2"
}

variable "scaling_adjust_alarm" {
  description = "The number of the instances to scale up or destroy"
  type = "string"
  default = "1"
}

variable "cpu_alarm_metric" {
  description = "The name used for the CPU metrics"
  type = "string"
  default = "CPU_Utilization"
}

variable "alarm_time" {
  description = "The lifetime alarm before the scale start"
  type = "string"
  default = "120"
}

variable "scale_up_alarm_threshold" {
  description = "The % threshold used for the high CPU utilization check"
  type = "string"
  default = "80"
}


variable "scale_down_alarm_threshold" {
  description = "The % threshold used for the low CPU utilization check"
  type = "string"
  default = "20"
}

variable "s3_full_access_policy" {
  description = "The ARN of the S3 policy used to access s3 bucket for content"
  type = "string"
}

variable "dmz_subnet_1" {
  description = "The ID of the subnet used for hosting loadbalancer"
  type = "string"
}

variable "dmz_subnet_2" {
  description = "The ID of the subnet used for hosting loadbalancer"
  type = "string"
}

variable "public_subnet_1" {
  description = "The ID of the subnet used for webservers"
  type = "string"
}

variable "public_subnet_2" {
  description = "The ID of the subnet used for webservers"
  type = "string"
}


variable "private_sg" {
  description = "The ID of the security group used for databases"
  type = "string"
}

variable "instance_type" {
  description = "Webserver instance type"
  type = "string"
  default = "t2.micro"
}


variable "ami" {
  description = "AWS AMI to use for the webserver instance"
  type = "string"
  default = "ami-0ce71448843cb18a1"
}

variable "key_pair" {
  description = "The name of the key pair to use when launching instances"
  type = "string"
}


