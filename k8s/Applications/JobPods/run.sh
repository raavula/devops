kubectl apply -f job.yaml
kubectl describe jobs/pi
pods=$(kubectl get pods --selector=job-name=pi --output=jsonpath='{.items[*].metadata.name}')
echo $pods
kubectl logs $pods
kubectl delete jobs/pi
#kubectl delete -f ./job.yaml


