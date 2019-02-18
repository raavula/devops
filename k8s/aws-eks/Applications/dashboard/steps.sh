#Deploy below configs
kubectl apply -f kubernetes-dashboard.yaml
kubectl apply -f heapster.yaml
kubectl apply -f influxdb.yaml
kubectl apply -f heapster-rbac.yaml
kubectl apply -f eks-admin-service-account.yaml 
kubectl apply -f eks-admin-cluster-role-binding.yaml

#Execute below commands
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')
lsof -ti:8001 | xargs kill -9 
kubectl proxy
http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/ 
