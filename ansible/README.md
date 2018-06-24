# Ansible Example

This directory contains a set of examples of using Ansible tool to run on Ec2 on AWS

For example:

```
$ git clone https://github.com/raavula/devops.git
$ cd devops/ansible/examples/

$ cat <<EOF > /usr/local/playbooks/hosts
[local]
127.0.0.1
EOF

$ ansible-playbook siteBake.yml \
  -i /usr/local/playbooks/hosts \
  --extra-vars "@/tmp/bastion-config.json" \
  --extra-vars "region=us-east-1" \
  --extra-vars "service=webapp" \
  --connection=local
...
```
