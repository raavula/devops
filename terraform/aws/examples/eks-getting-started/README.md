# Terraform dependency 
#make sure version v0.11 and above 

# Kubectl dependency
#brew install kubernetes-cli
# make sure version greater 1.10 or above 
# kubectl version  
# brew install bash-completion@2
# Follow the “caveats” section of brew’s output to add the appropriate bash completion path to your local .bashrc.

# Authenticator dependency
#install aws-iam-authenticator
#curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/darwin/amd64/aws-iam-authenticator
#chmod +x aws-iam-authenticator
#mv aws-iam-authenticator /usr/local/bin/heptio-authenticator-aws
#heptio-authenticator-aws help

# Execution
#make setup
#make plan 
#make deploy

# Output the files
#make output

# kubctl for cluster 
#copy kubectl config from output and place it in ~/.kube/config

# copy config-auth-map from output into config_map_aws_auth.yaml 
#kubectl apply -f config_map_aws_auth.yaml

# Deploy pod in worker-node
# dashboard
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
#kubectl get pods --all-namespaces

# Heapster
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/heapster.yaml

# Heapster-DB
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/influxdb.yaml

# cluster role bind to dash-board
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/rbac/heapster-rbac.yaml
#kubectl apply -f apps/eks-admin-service-account.yaml
#kubectl apply -f eks-admin-cluster-role-binding.yaml


# connect to Dashboard
#kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')

# kill any procee runs on 8001
#lsof -ti:8001 | xargs kill -9
#kubectl proxy


# Open the Dashboard
#http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/

# paste Token which is generated for login

# Cleanup cluster
#make destroy
