provider "aws" {
  region = "eu-west-1"

  #   profile = "terraform-user"
}

module "vpc" {
  source      = "../../modules/vpc"
  environment = "test"
}

#module "database" {
# source  = "../../modules/database"
# subnets = "${module.vpc.private_subnets}"
}

# module "webserver" {
#   source = "../../modules/webserver"
# }

