kubectl create secret generic mysql-pass --from-literal=password=YOUR_PASSWORD
kubectl get secrets
kubectl create -f mysql-deployment.yaml
kubectl get pvc
kubectl get pods
kubectl create -f wordpress-deployment.yaml
kubectl get pvc
kubectl get pods
kubectl get services wordpress

