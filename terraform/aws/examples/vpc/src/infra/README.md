#Execution steps
# To Deploy
 - make setup
 - make config
 - make plan 
 - make deploy 

# To check output
 - make output

# To Destroy
 - make destroy

#To Login to bastion
chmod 400 local_sshkey_opsstack
ssh -i local_sshkey_opsstack1 root@bastion_public_ip

