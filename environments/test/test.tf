provider "aws" {
  region = "eu-west-1"

  #   profile = "terraform-user"
}

module "vpc" {
  source      = "../../modules/vpc"
  environment = "test"
}


module "data" {
  source      = "../../modules/data"
  bucket_name = "xp-bucket-test"
}

variable "db_passwd" {
  description = "The password used for DB administrator user"
  type        = "string"
}



module "database" {
  source           = "../../modules/database"
  vpc_id           = "${module.vpc.vpc_id}"
  db_name          = "joomla"
  db_admin         = "admin"
  db_passwd        = "${var.db_passwd}"
  db_subnetgroup   = "db_private_subnet_group"
  private_subnet_1 = "${module.vpc.private_subnet_1}"
  private_subnet_2 = "${module.vpc.private_subnet_2}"
  public_sg        = "${module.webserver.public_sg}"
}

variable "site_name" {
  description = "Your desired site name"
  type        = "string"
}

variable "jml_mail" {
  description = "The email for joomla account"
  type        = "string"
}



module "webserver" {
  source                = "../../modules/webserver"
  vpc_id                = "${module.vpc.vpc_id}"
  s3_full_access_policy = "${module.data.s3_full_access_policy}"
  private_sg            = "${module.database.private_sg}"
  ssh_cidr              = ["0.0.0.0/0"]
  public_subnet_1       = "${module.vpc.public_subnet_1}"
  public_subnet_2       = "${module.vpc.public_subnet_2}"
  dmz_subnet_1          = "${module.vpc.dmz_subnet_1}"
  dmz_subnet_2          = "${module.vpc.dmz_subnet_2}"
  key_pair              = "macbook"
  max_instances         = "4"
  db_name               = "${module.database.db_name}"
  db_endpoint           = "${module.database.db_endpoint}"
  db_admin              = "${module.database.db_admin}"
  db_passwd             = "${var.db_passwd}"
  jml_mail              = "${var.jml_mail}"
  site_name             = "${var.site_name}"

}

