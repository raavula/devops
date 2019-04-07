#install helm fron: https://helm.sh/docs/using_helm/ 

helm install --name my-release --set sysdig.accessKey=YOUR-KEY-HERE stable/sysdig
helm list
#helm delete my-release
