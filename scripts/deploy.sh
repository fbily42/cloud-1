#!/bin/bash

set -e

ENV_FILE=".env"

if [ ! -f "$ENV_FILE" ]; then
  echo "❌ ERREUR : fichier $ENV_FILE introuvable."
  exit 1
fi

export $(grep -v '^#' "$ENV_FILE" | xargs)

echo "🔧 Initializing Terraform..."
cd terraform
terraform init

echo "🚀 Running Terraform apply..."
terraform apply -auto-approve

echo "🌐 Retrieving public IP address..."
INSTANCE_IP=$(terraform output -raw instance_public_ip)

echo "🔁 DuckDNS update"
curl -s "https://www.duckdns.org/update?domains=$DUCKDNS_DOMAIN&token=$DUCKDNS_TOKEN&ip=$INSTANCE_IP&verbose=true"
echo "✅ DuckDNS updated: https://$DUCKDNS_DOMAIN.duckdns.org -> $INSTANCE_IP"

cd ../ansible

echo "📝 Generating Ansible inventory file..."
cat <<EOF > inventory.ini
[cloud1]
instance ansible_host=${INSTANCE_IP} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_python_interpreter=/usr/bin/python3
EOF

echo "📦 Deploying with Ansible..."
ansible-playbook -i inventory.ini playbook.yml

echo "✅ Deployment completed successfully!"
