kubectl create -f cronjob.yaml
#kubectl run hello --schedule="*/1 * * * *" --restart=OnFailure --image=busybox -- /bin/sh -c "date; echo Hello from the Kubernetes cluster"
kubectl get cronjob hello
kubectl get jobs --watch
kubectl get cronjob hello
# Replace "hello-4111706356" with the job name in your system
pods=$(kubectl get pods --selector=job-name=hello-4111706356 --output=jsonpath={.items.metadata.name})
kubectl logs $pods
kubectl delete cronjob hello
