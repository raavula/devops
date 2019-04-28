# Reference : https://kubernetes.io/docs/tutorials/stateful-application/mysql-wordpress-persistent-volume/
# https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/
#https://kubernetes.io/docs/concepts/storage/storage-classes/

/* note:
Warning: In local clusters, the default StorageClass uses the hostPath provisioner. hostPath volumes are only suitable for development and testing. With hostPath volumes, your data lives in /tmp on the node the Pod is scheduled onto and does not move between nodes. If a Pod dies and gets scheduled to another node in the cluster, or the node is rebooted, the data is lost.
If you are bringing up a cluster that needs to use the hostPath provisioner, the --enable-hostpath-provisioner flag must be set in the controller-manager component.
*/


kubectl apply -k ./
kubectl get secrets
kubectl get pvc
kubectl get services wordpress
#open http://Loadbalncer-elb
kubectl delete -k ./

#helm chart Deployment Reference  : https://github.com/helm/charts/tree/master/stable/wordpress
