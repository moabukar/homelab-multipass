#!/bin/bash

# Get the multipass list output
multipass_output=$(multipass list)

# Extract IP addresses
master_ip=$(echo "$multipass_output" | awk '/k8s-master/ {print $3}')
worker1_ip=$(echo "$multipass_output" | awk '/k8s-worker1/ {print $3}')
worker2_ip=$(echo "$multipass_output" | awk '/k8s-worker2/ {print $3}')

# Generate the inventory file
cat > inventory <<EOF
[master]
k8s-master ansible_host=$master_ip

[nodes]
k8s-worker1 ansible_host=$worker1_ip
k8s-worker2 ansible_host=$worker2_ip

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/id_rsa
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF

echo "Inventory file generated successfully."

# Create group_vars directory if it doesn't exist
mkdir -p group_vars

# Generate the all.yml file in group_vars
cat > group_vars/all.yml <<EOF
---
k3s_master_ip: $master_ip
k3s_node_token:
EOF

echo "group_vars/all.yml file generated successfully."
