# kubernetes-prometheus
kubectl create clusterrolebinding owner-cluster-admin-binding --clusterrole cluster-admin --user admin  
kubectl create namespace monitoring  
kubectl create -f clusterRole.yaml  
kubectl create -f config-map.yaml -n monitoring  
kubectl create  -f prometheus-deployment.yaml --namespace=monitoring  
kubectl get deployments --namespace=monitoring  
kubectl get pods --namespace=monitoring  
kubectl create -f prometheus-service.yaml --namespace=monitoring  


# Access Dashboard 
In browser open the below link where NodeIP is where the pod running in node  
http://<<Nodeip>>:30000   

OR
 
# if you use proxy 
kubctl proxy 
 
open the below link in browser   
http://localhost:8001/api/v1/namespaces/monitoring/services/prometheus-service:/proxy/graph
