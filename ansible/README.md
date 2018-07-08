# Ansible Example

This repository contains examples and best practices for building Ansible Playbooks.
For example:

```
$ git clone https://github.com/raavula/devops.git
$ cd devops/ansible/

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
