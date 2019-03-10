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
 

# Create s3 bucket for state files   
aws s3api create-bucket --bucket raavula-kops-s3-bucket-for-cluster-state --region us-east-1

# Export Variables
export NAME=privatekopscluster.k8s.local   
export KOPS_STATE_STORE=s3://raavula-kops-s3-bucket-for-cluster-state    

# KOPS PRIVATE CLUSTER CREATION:    
kops create cluster \ 
--cloud=aws \  
--master-zones=us-east-1a,us-east-1b,us-east-1c \  
--zones=us-east-1a,us-east-1b,us-east-1c \  
--node-count=2 \  
--topology private \  
--networking kopeio-vxlan \  
--node-size=t2.micro \  
--master-size=t2.micro \  
${NAME}  


# Deploy your cluster    
kops update cluster ${NAME} --yes    

*** Go for a coffee or just take a 10~15 minutes walk. After that, the cluster will be up-and-running. We can check this with the following commands: ****   

# Validate cluster  
kops validate cluster  

# Check Server ELB   
grep server ~/.kube/config    


*** But, all the cluster instances (masters and worker nodes) will have private IP's only (no AWS public IP's).    
    Then, in order to reach our instances, we need to add a "bastion host" to our cluster.  ******    

# ADDING A BASTION HOST TO OUR CLUSTER.  
Below command opens a edit file in case if want to change any config like HA, Falvor etc    
kops create instancegroup bastions --role Bastion --subnet utility-us-east-1a --name ${NAME} 

# Deploy the changes   
kops update cluster ${NAME} --yes   

# Validate cluster   
kops validate cluster  

# Login to Private Nodes Via Bastion host   
##get bastion FQDN  
aws elb --output=table describe-load-balancers|grep DNSName.\*bastion|awk '{print $4}'   
ssh -i ~/.ssh/id_rsa admin@bastion-privatekopscluste-bgl0hp-XXXXX.us-east-1.elb.amazonaws.com     
##login to any node     
ssh admin@ip-1XX-XX-XX-XX.ec2.internal    

## Destroy cluster   
kops delete cluster ${NAME} --yes   

# Delete s3 bucket  
aws s3 rb s3://raavula-kops-s3-bucket-for-cluster-state --force   

