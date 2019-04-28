# Reference : https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/
kubectl apply -f web.yaml
kubectl get service nginx
kubectl get statefulset web
kubectl get pvc -l app=nginx
kubectl scale sts web --replicas=3
kubectl patch sts web -p '{"spec":{"replicas":2}}'
kubectl delete sts web
kubectl delete svc nginx

