#namespace
kubectl create ns sysdig-agent

#secrets
kubectl create secret generic sysdig-agent --from-literal=access-key=<your sysdig access key> -n sysdig-agent

#cluster role, service account
kubectl apply -f sysdig-agent-clusterrole.yaml -n sysdig-agent
kubectl create serviceaccount sysdig-agent -n sysdig-agent
kubectl create clusterrolebinding sysdig-agent --clusterrole=sysdig-agent --serviceaccount=sysdig-agent:sysdig-agent  

#config Map
kubectl apply -f sysdig-agent-configmap.yaml -n sysdig-agent

#Deamonset
kubectl apply -f sysdig-agent-daemonset-v2.yaml -n sysdig-agent


#Access Sysdig Monitor: 
SaaS: https://app.sysdigcloud.com
Log in with your Sysdig user name and password. 
Select the Explore tab to see if metrics are displayed. 


