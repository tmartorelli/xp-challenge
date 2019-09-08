# xp-challenge

## Tooling
For this exercise I've decided to use terraform. The code is available in this repository and it's split up into four different modules:
- VCP
- DATA
- DATABASE
- WEBSERVER


The VPC module contains the code related to the creation of the VPC, subnets, nat gateway, internet gateway, elastic ip and route tables.

The Data module contains the code related to the S3 bucket creation and bucket access policy.

The Database module contains the code related to the creation of the mysql cluster and the “private” security group (The security group used to manage Inbound/outbound database communication).

The Webserver module contains the code related to the creation of the webserver stack, the launch configuration and the autoscaling group which takes care of managing the scale up and scale down of the instances through the cloudwatch alarms.


## How to run it?

I'm assuming terraform and the awscli are installed.

*Before starting:*
- change the S3 bucket name in the test.tf environment file
- change the path to s3 files in the test.tf enviroment file
-  set the `min_instances` and `max_instances` for the webserver module accordingly (default min 2 default max 4)
- change the `key_pair` value in the test.tf enviroment file with the name of the key pair used.

```
# install infrastructure

cd environments/test
terraform apply 

#Terraform will ask you to enter the values of the database password, the joomla account and the site name

adminadmin
example@example.com
cms-kata
```

When terraform apply is finished, the last step is to change the aurora cluster endpoint name in the "import_db.sh" script and then run it.
The "import_db" script will take care of importing the joomla template db with his tables.

# Approach

For high availability purposes i wanted to use a subnet in each availability zone in the region (I've actually used 2 out of 3 to save costs during tests).
I decided to create a private subnet for DB instances, a public subnet for hosting webserver and DMZ subnet for the loadbalancer.

To get a high security level, I defined two loadbalancer listener (HTTPS listener and HTTP listener). On the HTTP listener I configured redirecting on port 443 (In this simulation exercise I used a self sign certificate).


Regarding the alarms, both to manage the autoscaling and to check the 4xx requests returned by application, I decided to use cloudwatch alarms.

Note that I choose to use a NAT gateway inside an extra public subnet to let the private instances (Like DB instances) connect to the internet. The best option would be to put 3 NAT gateways - one for each AZ - but I've kept it simple.

Unfortunately I didn't have enough time to configure logrotation.

Regarding the rotation of the logs, I thought of configuring it through logrotate which together with s3cmd allow to perform the rotation directly on the bucket s3.

The only operation I've chosen to keep manual, is the import of the DB precisely because it must be done only the first time it is started.


I decided to store the terraform state locally as I was the only person accessing the code, but the best option is to store the state in S3.










