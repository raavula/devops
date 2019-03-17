# Install Dind cluster  
chmod +x dind-cluster-v1.13.sh    

# start the cluster   
sudo ./dind-cluster-v1.13.sh up   

# add kubectl directory to PATH   
export PATH="$HOME/.kubeadm-dind-cluster:$PATH"   

# Check cluster status   
kubectl get nodes  
kubectl get pods --all-namespaces  
kubectl get services --all-namespaces       


# Running Apps   
kubectl proxy   

# k8s dashboard Access at  
http://localhost:8001/api/v1/namespaces/kube-system/services/kubernetes-dashboard:/proxy    

# Guestbook application   
cd guestbook   
cat steps.sh   
http://localhost:8001/api/v1/namespaces/default/services/frontend:/proxy/


# restart the cluster, this should happen much quicker than initial startup   
sudo ./dind-cluster-v1.13.sh up    

# stop the cluster      
sudo ./dind-cluster-v1.13.sh down    

# remove DIND containers and volumes      
sudo ./dind-cluster-v1.13.sh clean   



