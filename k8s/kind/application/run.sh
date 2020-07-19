kubectl apply -k ./

kubectl get secrets
kubectl get pvc
kubectl get pods
kubectl get services wordpress
#expose wordpress service
http://localhost:32406
#kubectl proxy 
http://localhost:8001/api/v1/namespaces/default/services/wordpress:/proxy/wp-admin/install.php

kubectl delete -k ./
