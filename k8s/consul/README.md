# Open file in https://dillinger.io/
# Consul implementation
Before you start to implement the Consul you have to install the following:
1.consul
2.cfssl and cfssljson 1.2
# Generation of TLS Certificates
RPS communication between each Consul element will be encrypted with TLS. Now we have to Initiate Certificate Authority (CA):
ca-config.json
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "default": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "8760h"
      }
    }
  }
}

ca-csr.json
{
  "hosts": [
    "cluster.local"
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Kubernetes",
      "OU": "CA",
      "ST": "Oregon"
    }
  ]

consul-csr.json
{
  "CN": "server.dc1.cluster.local",
  "hosts": [
    "server.dc1.cluster.local",
    "127.0.0.1"
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Comnsul",
      "OU": "Consul",
      "ST": "Oregon"
    }
  ]
}

cfssl gencert -initca ca-csr.json | cfssljson -bare ca
Create certificate and key for Consul:

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca/ca-config.json \
  -profile=default \
  ca/consul-csr.json | cfssljson -bare consul
Now we have the following files:

ca-key.pem
ca.pem
consul-key.pem
consul.pem
Generate the Consul Gossip Encryption Key


# Saving gossip key and TLS Certificates in Secret:
Gossip communication between Consul elements will be encrypted with a shared key. 
Generate and save the key:
GOSSIP_ENCRYPTION_KEY=$(consul keygen)
Creating the Consul Secret and ConfigMap

kubectl create secret generic consul \
  --from-literal="gossip-encryption-key=${GOSSIP_ENCRYPTION_KEY}" \
  --from-file=ca.pem \
  --from-file=consul.pem \
  --from-file=consul-key.pem
Now we have to save Consul Configuration in ConfigMap:

# configmap creation
kubectl create configmap consul --from-file=server.json
server.json:
				 						
{
  "ca_file": "/etc/tls/ca.pem",
  "cert_file": "/etc/tls/consul.pem",
  "key_file": "/etc/tls/consul-key.pem",
  "verify_incoming": true,
  "verify_outgoing": true,
  "verify_server_hostname": true,
  "ports": {
    "https": 8443
  }
}

# Consul Service
kubectl create -f service.yaml

service.yaml:
apiVersion: v1
kind: Service
metadata:
  name: consul
  labels:
    name: consul
spec:
  clusterIP: None
  ports:
    - name: http
      port: 8500
      targetPort: 8500
    - name: https
      port: 8443
      targetPort: 8443
    - name: rpc
      port: 8400
      targetPort: 8400
    - name: serflan-tcp
      protocol: "TCP"
      port: 8301
      targetPort: 8301
    - name: serflan-udp
      protocol: "UDP"
      port: 8301
      targetPort: 8301
    - name: serfwan-tcp
      protocol: "TCP"
      port: 8302
      targetPort: 8302
    - name: serfwan-udp
      protocol: "UDP"
      port: 8302
      targetPort: 8302
    - name: server
      port: 8300
      targetPort: 8300
    - name: consuldns
      port: 8600
      targetPort: 8600
  selector:
    app: consul
# StatfulSet
Deploying 3 Pods:
kubectl create -f statefulset.yaml

statefulset.yaml:
apiVersion: apps/v1beta1
kind: StatefulSet
metadata:
  name: consul
spec:
  serviceName: consul
  replicas: 5
  template:
    metadata:
      labels:
        app: consul
    spec:
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            - labelSelector:
                matchExpressions:
                  - key: app
                    operator: In
                    values:
                      - consul
              topologyKey: kubernetes.io/hostname
      terminationGracePeriodSeconds: 10
      securityContext:
        fsGroup: 1000
      containers:
        - name: consul
          image: "consul:1.2.0"
          env:
            - name: POD_IP
              valueFrom:
                fieldRef:
                  fieldPath: status.podIP
            - name: GOSSIP_ENCRYPTION_KEY
              valueFrom:
                secretKeyRef:
                  name: consul
                  key: gossip-encryption-key
            - name: NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
          args:
            - "agent"
            - "-advertise=$(POD_IP)"
            - "-bind=0.0.0.0"
            - "-bootstrap-expect=3"
            - "-retry-join=consul-0.consul.$(NAMESPACE).svc.cluster.local"
            - "-retry-join=consul-1.consul.$(NAMESPACE).svc.cluster.local"
            - "-retry-join=consul-2.consul.$(NAMESPACE).svc.cluster.local"
            - "-client=0.0.0.0"
            - "-config-file=/consul/myconfig/server.json"
            - "-datacenter=dc1"
            - "-data-dir=/consul/data"
            - "-domain=cluster.local"
            - "-encrypt=$(GOSSIP_ENCRYPTION_KEY)"
            - "-server"
            - "-ui"
            - "-disable-host-node-id"
          volumeMounts:
            - name: config
              mountPath: /consul/myconfig
            - name: tls
              mountPath: /etc/tls
          lifecycle:
            preStop:
              exec:
                command:
                - /bin/sh
                - -c
                - consul leave
          ports:
            - containerPort: 8500
              name: ui-port
            - containerPort: 8400
              name: alt-port
            - containerPort: 53
              name: udp-port
            - containerPort: 8443
              name: https-port
            - containerPort: 8080
              name: http-port
            - containerPort: 8301
              name: serflan
            - containerPort: 8302
              name: serfwan
            - containerPort: 8600
              name: consuldns
            - containerPort: 8300
              name: server
      volumes:
        - name: config
          configMap:
            name: consul
        - name: tls
          secret:
            secretName: consul

# Checking the launched nodes:
kubectl get pods
NAME READY STATUS RESTARTS AGE
consul-0 1/1 Running 0 50s
consul-1 1/1 Running 0 29s
consul-2 1/1 Running 0 15s
Final Check

# Forward the port to the local machine:
kubectl port-forward consul-1 8500:8500
Forwarding from 127.0.0.1:8500 -> 8500
Forwarding from [::1]:8500 -> 8500

# Run the command:
consul members 
Node Address Status Type Build Protocol DC 
consul-0 10.176.4.30:8301 alive server 1.2.0 2 dc1 
consul-1 10.176.4.31:8301 alive server 1.2.0 2 dc1 
consul-2 10.176.1.16:8301 alive server 1.2.0 2 dc1

# Check the Web-UI
Simply open the http://127.0.0.1:8500 in your browser.
If all the steps above were done correctly, then you have the Consul ready to help with your needs.



