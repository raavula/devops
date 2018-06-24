# Variables 
#SSP  - shirdi sai parivar

account              = "ssp-devops"
stack                = "opsstack1"
owner                = "raavula"

# Default region, zones
region              = "us-east-1"
default_azs         = "us-east-1a,us-east-1b"

#--------------------------------------------------------------
# Infrastruture [ Network, Controller ]
#--------------------------------------------------------------

# NAT
nat_azs                 = "us-east-1a"

# Bastion
bastion_flavor          = "t2.micro"
bastion_azs             = "us-east-1a"

#--------------------------------------------------------------
# VPC network plan
#--------------------------------------------------------------

# VPC
vpc_cidr                   = "10.0.0.0/16"
vpc_dns_resolver           = "10.0.0.2"

# Public subnet cidrs
nat_cidrs                  = "10.0.0.32/28"
bastion_cidrs              = "10.0.0.0/28"

# Private subnet cidrs
application_cidrs            = "10.0.4.0/24,10.0.14.0/24"

