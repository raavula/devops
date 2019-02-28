# Vault Implementation
We’ll be running Vault in Kubernetes, first of all we have to create the configuration file vault.hcl and insert the following:
disable_cache = true
disable_mlock = true
ui = true
 listener "tcp" {
  address 	= "127.0.0.1:8200"
  tls_disable = 1
}
 storage "consul" {
  address = "127.0.0.1:8500"
  path    = "mycompany/"
  disable_registration = "true"
}
max_lease_ttl = "10h"
default_lease_ttl = "10h"
raw_storage_endpoint = true
cluster_name = "mycompany-vault"

# Creating ConfigMap:
$ kubectl create configmap vault --from-file=vault.hcl

# Creating service.yaml:

apiVersion: v1
kind: Service
metadata:
  name: vault
  labels:
    app: vault
spec:
  type: ClusterIP
  ports:
    - port: 8200
      targetPort: 8200
      protocol: TCP
      name: vault
  selector:
    app: vault

# Create deployment.yaml as well:

apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: vault
  labels:
    app: vault
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: vault
    spec:
      containers:
      - name: vault
        command: ["vault", "server", "-config", "/vault/config/vault.hcl"]
        image: "vault:0.10.3"
        imagePullPolicy: IfNotPresent
        securityContext:
          capabilities:
            add:
              - IPC_LOCK
        volumeMounts:
          - name: configurations
            mountPath: /vault/config/vault.hcl
            subPath: vault.hcl
      - name: consul-vault-agent
        image: "consul:1.2.0"
        env:
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
          - "-retry-join=consul-0.consul.$(NAMESPACE).svc.cluster.local"
          - "-retry-join=consul-1.consul.$(NAMESPACE).svc.cluster.local"
          - "-retry-join=consul-2.consul.$(NAMESPACE).svc.cluster.local"
          - "-encrypt=$(GOSSIP_ENCRYPTION_KEY)"
          - "-domain=cluster.local"
          - "-datacenter=dc1"
          - "-disable-host-node-id"
          - "-node=vault-1"
        volumeMounts:
            - name: config
              mountPath: /consul/config
            - name: tls
              mountPath: /etc/tls  
      volumes:
        - name: configurations
          configMap:
            name: vault
        - name: config
          configMap:
            name: consul
        - name: tls
          secret:
            secretName: consul

# Applying Changes
$ kubectl apply -f service.yaml
$ kubectl apply -f deployment.yaml

If everything was done correctly, then we should see that the service is working. Let’s begin the initialization and port forwarding to your local machine:

$ kubectl port-forward vault-6f8-z2rrj 8200:8200

# Check the following in the other window:
$ export VAULT_ADDR=http://127.0.0.1:8200
For convenience, we’ll make initialization with one unsealed key.
$ vault operator init -key-shares=1 -key-threshold=1
 Unseal Key 1: DKoe652D**************yio9idW******BlkY8=
Initial Root Token: 95633ed2-***-***-***-faaded3c711e
 
Vault initialized with 1 key shares and a key threshold of 1. Please securely
distribute the key shares printed above. When the Vault is re-sealed,
restarted, or stopped, you must supply at least 1 of these keys to unseal it
before it can start servicing requests.
 
Vault does not store the generated master key. Without at least 1 key to
reconstruct the master key, Vault will remain permanently sealed!
 
It is possible to generate new unseal keys, provided you have a quorum of
existing unseal keys shares. See "vault rekey" for more information.
Make sure to save the output that you are going to get at this stage, because we need the unseal keys and root token. Now we have to unpack the vault with an unseal key:

$ vault operator unseal <key 1>
 
Key         	Value
---         	-----
Seal Type   	shamir
Sealed          false
Total Shares    1
Threshold   	1
Version     	0.10.1
Cluster Name    vault-cluster-c9499a92
Cluster ID      3b8cce45-d64e-64bb-e41d-575c6d3a7e03
HA Enabled      false
Login into the vault with root token:

$ vault login <root token>

$ vault secrets list
 
Path          Type     	Description
----          ----     	-----------
cubbyhole/    cubbyhole    per-token private secret storage
identity/ 	identity 	identity store
secret/   	kv       	key/value secret storage
sys/          system   	system endpoints used for control, policy and debugging
Save the secret:

$ vault kv put secret/apikey key="my-test-key"
 
Key              Value
---              -----
created_time 	2018-07-13T11:03:22.584234492Z
deletion_time    n/a
destroyed        false
version          1
We can even check it if we need to:

$ vault kv get secret/apikey
 
====== Metadata ======
Key              Value
---              -----
created_time 	2018-07-13T11:03:22.584234492Z
deletion_time    n/a
destroyed        false
version          1
 === Data ===
Key    Value
---    -----
key    my-test-key
Update the secret:

$ vault kv put secret/apikey key="my-test-key" owner="dev"
 
Key              Value
---              -----
created_time 	2018-07-13T11:06:00.514309494Z
deletion_time    n/a
destroyed        false
version          2
It has created the second version of data in secret/apikey. Refresh it once more:

$ vault kv put secret/apikey owner="ops"
 
Key              Value
---              -----
created_time 	2018-07-13T11:09:52.457793677Z
deletion_time    n/a
destroyed        false
version          3
Now, let’s see what we’ve got:

$ vault kv get secret/apikey
 
====== Metadata ======
Key              Value
---              -----
created_time 	2018-07-13T11:09:52.457793677Z
deletion_time    n/a
destroyed        false
version          3
 ==== Data ====
Key      Value
---      -----
owner    ops
PUT refreshes all of the data in the secret. In order to add changes without losing the old data we have to run the following command:

$ vault kv patch secret/apikey year="2018"
 
Key              Value
---              -----
created_time 	2018-07-13T11:12:38.832500503Z
deletion_time    n/a
destroyed        false
version          4
Let’s check what we have got:

$ vault kv get secret/apikey
 
====== Metadata ======
Key              Value
---              -----
created_time 	2018-07-13T11:12:38.832500503Z
deletion_time    n/a
destroyed        false
version          4
 
==== Data ====
Key      Value
---      -----
owner    ops
year 	2018
By the way, you can work with different versions:

$ vault kv get -version=1 secret/apikey
 
====== Metadata ======
Key              Value
---              -----
created_time 	2018-07-13T11:03:22.584234492Z
deletion_time    n/a
destroyed        false
version          1
 === Data ===
Key    Value
---    -----
key    my-test-key
If all of the steps are executed successfully then you should have a fully working, deployed Vault, which will make a great addition to your ecosystem.