# Create namespace
kubectl create namespace logging

#Elastic search
kubectl create -f elastic.yaml -n logging
kubectl get pods -n logging
kubectl get service -n logging

#Kibana
kubectl create -f kibana.yaml -n logging
kubectl get pods -n logging
kubectl get service -n logging


kubectl proxy 
http://localhost:8001/api/v1/namespaces/logging/services/kibana:/proxy/app/kibana
