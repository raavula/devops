#Reference : https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/

kubectl apply -f web.yaml
kubectl get service nginx
kubectl get statefulset web
kubectl get pods -w -l app=nginx
kubectl get pods -l app=nginx

for i in 0 1; do kubectl exec "web-$i" -- sh -c 'hostname'; done

kubectl run -i --tty --image busybox:1.28 dns-test --restart=Never --rm
#nslookup web-0.nginx

kubectl get pod -w -l app=nginx
kubectl delete pod -l app=nginx
#outout 
pod "web-0" deleted
pod "web-1" deleted

kubectl get pvc -l app=nginx

for i in 0 1; do kubectl exec "web-$i" -- sh -c 'echo "$(hostname)" > /usr/share/nginx/html/index.html'; done
for i in 0 1; do kubectl exec web-$i -- chmod 755 /usr/share/nginx/html; done
for i in 0 1; do kubectl exec -i -t "web-$i" -- curl http://localhost/; done


kubectl scale sts web --replicas=5
kubectl patch sts web -p '{"spec":{"replicas":3}}'
kubectl patch statefulset web -p '{"spec":{"updateStrategy":{"type":"RollingUpdate"}}}'
kubectl patch statefulset web --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/image", "value":"gcr.io/google_containers/nginx-slim:0.8"}]'


for p in 0 1 2; do kubectl get pod "web-$p" --template '{{range $i, $c := .spec.containers}}{{$c.image}}{{end}}'; echo; done

