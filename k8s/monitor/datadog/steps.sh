# Install the k8s Agent with Deamon Follow below steps 
https://app.datadoghq.com/account/settings#agent/kubernetes

kubectl create -f "https://raw.githubusercontent.com/DataDog/datadog-agent/master/Dockerfiles/manifests/rbac/clusterrole.yaml"
kubectl create -f "https://raw.githubusercontent.com/DataDog/datadog-agent/master/Dockerfiles/manifests/rbac/serviceaccount.yaml"
kubectl create -f "https://raw.githubusercontent.com/DataDog/datadog-agent/master/Dockerfiles/manifests/rbac/clusterrolebinding.yaml"
kubectl create secret generic datadog-secret --from-literal api-key="XXXXXX"

# To Run agent in masternode for Deamonset added below lines to datadog-agent.yaml file
tolerations:
      - key: node-role.kubernetes.io/master
        effect: NoSchedule

kubectl create -f datadog-agent.yaml

# Add integrations to monitor for docker and k8s
https://app.datadoghq.com/account/settings#integrations/docker
https://app.datadoghq.com/account/settings#integrations/kubernetes 


# Monitor Dashboard for Docker and k8s below link And can create an custom dashboard
https://app.datadoghq.com/dashboard/lists


# create Alerts with below Link
https://app.datadoghq.com/monitors/manage


# Check all metrics that pushed from Agent
https://app.datadoghq.com/metric/summary


# Check custom metrics how it works
https://docs.datadoghq.com/developers/metrics/custom_metrics/
 

