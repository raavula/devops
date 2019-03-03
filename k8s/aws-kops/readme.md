# Install kops 
#On Mac:
curl -OL https://github.com/kubernetes/kops/releases/download/1.10.0/kops-darwin-amd64 
chmod +x kops-darwin-amd64 
mv kops-darwin-amd64 /usr/local/bin/kops  
#you can also install using Homebrew  
brew update && brew install kops  

# Verify Kops command 
kops version

#On Linux:  
wget https://github.com/kubernetes/kops/releases/download/1.10.0/kops-linux-amd64    
chmod +x kops-linux-amd64   
mv kops-linux-amd64 /usr/local/bin/kops     

# ***** NOTE *********   
Replace all string "raavula" with your own domain string   

# Create route53 domain   
#execute below command by replace with  raavula.com with your owndomain name   

#if we create domain[like raavula.com] first time it charges nearly $12 per year   
1.https://console.aws.amazon.com/route53/home#DomainRegistration:    
2.will get nearly 3 Emails one for Registration confirm and second verified and third route 53 creation success   

aws route53 list-hosted-zones | jq '.HostedZones[] | select(.Name=="raavula.com.") | .Id  
aws route53 list-resource-record-sets --hosted-zone-id XXXXX  
vi subdomain.json  
edit values Name and ResourceRecords with above output [.com,.net,.org,.uk]     
aws route53 list-hosted-zones | jq '.HostedZones[] | select(.Name=="raavula.com.") | .Id'    
aws route53 change-resource-record-sets --hosted-zone-id "/hostedzone/XXXXXXXX" --change-batch file://subdomain.json  


# Verify domain 
dig NS dev.raavula.com  

# Save state in S3 bucket
aws s3 mb s3://clusters.dev.raavula.com

# Export profile
export KOPS_STATE_STORE=s3://clusters.dev.raavula.com 

# Build your cluster configuration   
kops create cluster --zones=us-east-1c useast1.dev.raavula.com   

# Update any config   
kops update cluster  
kops get cluster   
kops edit cluster useast1.dev.raavula.com   
kops edit ig --name=useast1.dev.raavula.com nodes   
kops edit ig --name=useast1.dev.raavula.com master-us-east-1c    

# Create an cluster in AWS  
kops update cluster useast1.dev.raavula.com --yes  
#wait for 5 min until cluster created  

# Verify cluster status
kubectl get nodes   
kubectl get pods --all-namespaces   


# Update and Rollout config  
kops edit ig nodes  
kops update cluster  
kops update cluster --yes   
kops rolling-update cluster  

  
# Cleanup   
kops delete cluster useast1.dev.raavula.com --yes  
vi subdomain.json    
Replce CREATE with DELETE   

aws route53 list-hosted-zones | jq '.HostedZones[] | select(.Name=="raavula.com.") | .Id'   
aws route53 change-resource-record-sets --hosted-zone-id "/hostedzone/XXXXXXXX" --change-batch file://subdomain.json    

aws s3 rb s3://clusters.dev.raavula.com --force


#if you want to delete your own domain execute below command.  
aws route53 list-hosted-zones | jq '.HostedZones[] | select(.Name=="raavula.com.") | .Id'   
aws route53 delete-hosted-zone --id YYYYYY   
Go To Below and delete Registered Domain     
https://console.aws.amazon.com/route53/home?region=us-east-1#DomainListing:   
