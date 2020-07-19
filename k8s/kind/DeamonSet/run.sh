Reference Link:  https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/

kubectl apply -f fluentd.yaml 

kubectl get ds 
kubectl get pods -o wide 

# DeamonSet will takecar to bring up this pod in each node (master and worker)

