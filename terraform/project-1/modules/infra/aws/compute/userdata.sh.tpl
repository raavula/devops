#!/bin/bash

#
# Create host file
#
cat <<EOF > /usr/local/playbooks/hosts
[local]
127.0.0.1
EOF

#
# If Any Ansible playbooks Run here
#

#ansible-playbook  /usr/local/configuration/siteBake.yml \
#  -i /usr/local/playbooks/hosts \
#  --extra-vars "region=${region}" \
#  --extra-vars "stack=${stack}" \
#  --connection=local

