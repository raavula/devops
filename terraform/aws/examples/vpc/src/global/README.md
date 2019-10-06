#Execution steps

#Get your local IP for SG and update in myip.tf file
#Mac Example is
dig +short myip.opendns.com @resolver1.opendns.com

#Update account variable in terraform.tfvar for s3 bucket 

# To Deploy
 - make setup
 - make config
 - make plan 
 - make deploy 

# To check output
 - make output

# To Destroy
 - make destroy


