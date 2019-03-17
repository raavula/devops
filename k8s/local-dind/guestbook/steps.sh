kubectl apply -f redis-master-deployment.yaml
kubectl apply -f redis-master-service.yaml
kubectl apply -f redis-slave-deployment.yaml
kubectl apply -f redis-slave-service.yaml
kubectl apply -f frontend-deployment.yaml
kubectl apply -f frontend-service.yaml
kubectl scale deployment frontend --replicas=1


#Commands
kubectl logs -f <POD-NAME>
kubectl get service
kubectl get pods
kubectl get pods -l app=guestbook -l tier=frontend

#Monitor logs for mutiple pods
#Download kubbetail from: https://github.com/raavula/kubetail
kubetail app1,app2

#Login to inside container
kubectl exec -it <<pod-name>> /bin/bash 

#Describe pod 
kubectl describe pod << pod-name >> 

#RUN the UI 
kubectl proxy
http://localhost:8001/api/v1/namespaces/default/services/frontend:/proxy/

