#!/bin/bash
cd /var/www/
mysql --user=admin --host=aurora-cluster-joomla.cluster-cntggvxcnzd7.eu-west-1.rds.amazonaws.com --password=adminadmin
drop database joomla;
create database joomla character set utf8 collate utf8_general_ci;
use joomla
source joomla.sql