# AWS account creation  
#make sure created and account in aws and created a role and assign policy   
#get aws access key and secret key for your account   

# Terraform dependency
#make sure version v0.11 and above   
terraform version

# Install aws-cli 
#https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html 

# Seup Environment with your values
export AWS_ACCESS_KEY_ID=AKIAXXXX   
export AWS_SECRET_ACCESS_KEY=68XXXXXX   
export AWS_DEFAULT_REGION=us-east-1     
PATH="<your installed path>/Terraform/v0.11.10/:$PATH"    
export PATH 

# Kubectl dependency
brew install kubernetes-cli 
#make sure version greater 1.10 or above   
kubectl version  
brew install bash-completion@2    
#Follow the “caveats” section of brew’s output to add the appropriate bash completion path to your local .bashrc. 

# Authenticator dependency
#install aws-iam-authenticator   
curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/darwin/amd64/aws-iam-authenticator   
chmod +x aws-iam-authenticator    
mv aws-iam-authenticator /usr/local/bin/heptio-authenticator-aws      
heptio-authenticator-aws help     

# Pre condition check
#verify : curl http://whatismyip.akamai.com/  or open in browser   
#verify aws credentials are set in console or not by either 'aws configure' or 'aws s3 ls'    

# Configure stack name 
vi setup.sh    
replace raavula with some string (new stack name)   
sh setup.sh    

# Execution
make setup   
make plan    
make deploy    

# Output the files
make output    

# kubctl for cluster
#copy kubectl config from output and place it in ~/.kube/config        

# Config map configuration    
#copy config-auth-map from output into config_map_aws_auth.yaml    
kubectl apply -f config_map_aws_auth.yaml     

# Deploy Apps in worker-node 
#Guestbook Application - FrontEnd, BackEnd and Redis cluster DB   
cd Applications/guestbook/   
cat steps.sh     

#dashboard Application
cd Applications/dashboard/   
cat steps.sh

# connect to Dashboard   
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')   

# kill any procee runs on 8001   
lsof -ti:8001 | xargs kill -9    
kubectl proxy
    
# Open the Dashboard    
http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/    
#paste Token which is generated for login    

# Cleanup cluster  
cd Applications/dashboard/  
sh cleanup.sh  
cd Applications/guestbook/  
sh cleanup.sh  
make destroy    

