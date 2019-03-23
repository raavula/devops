kubectl apply -f redis-master-deployment.yaml
kubectl apply -f redis-master-service.yaml
kubectl apply -f redis-slave-deployment.yaml
kubectl apply -f redis-slave-service.yaml
kubectl apply -f frontend-deployment.yaml
kubectl apply -f frontend-service.yaml

#Commands
kubectl logs -f <POD-NAME>
kubectl get service
kubectl get pods
kubectl get pods -l app=guestbook -l tier=frontend
kubectl get deployments

#Logs 
kubectl logs -f <POD-NAME>

#Monitor logs for mutiple pods
#Download kubbetail from: https://github.com/raavula/kubetail
kubetail app1,app2

#Login to inside container
kubectl exec -it <<pod-name>> /bin/bash 

#Describe pod 
kubectl describe pod << pod-name >> 

#scale
kubectl scale deployment frontend --replicas=1

#Image upgrade
kubectl set image deployment/frontend php-redis=gcr.io/google-samples/gb-frontend:v3

# Image by patch
kubectl patch deployment frontend  -p'{"spec":{"template":{"spec":{"containers":[{"name":"php-redis","image":"gcr.io/google-samples/gb-frontend:v3"}]}}}}'
kubectl describe deployment/frontend

#Read Rollout history 
kubectl get deployments
kubectl rollout history deployment/frontend
kubectl rollout history deployment/frontend --revision 1

#Rollback to specific previously deployed version
kubectl rollout undo deployment/frontend --to-revision 1

#Rollout status 
kubectl rollout status deployment/frontend

#RUN the UI 
kubectl proxy
http://localhost:8001/api/v1/namespaces/default/services/frontend:/proxy/

