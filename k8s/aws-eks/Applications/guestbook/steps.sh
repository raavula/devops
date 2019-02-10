kubectl apply -f redis-master-controller.json
kubectl apply -f redis-master-service.json
kubectl apply -f redis-slave-controller.json
kubectl apply -f redis-slave-service.json
kubectl apply -f guestbook-controller.json
kubectl apply -f guestbook-service.json


# http://a7a95c2b9e69711e7b1a3022fdcfdf2e-1985673473.us-west-2.elb.amazonaws.com:3000
