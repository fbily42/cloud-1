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

echo "🌐 Retrieving public IP addresses..."
INSTANCE_IPS=$(terraform output -json instance_public_ips | jq -r '.[]')

FIRST_IP=$(echo "$INSTANCE_IPS" | head -n1)

echo "🔁 DuckDNS update"
curl -s "https://www.duckdns.org/update?domains=$DUCKDNS_DOMAIN&token=$DUCKDNS_TOKEN&ip=$FIRST_IP&verbose=true"
echo "✅ DuckDNS updated: https://$DUCKDNS_DOMAIN.duckdns.org -> $FIRST_IP"

cd ../ansible

echo "📝 Generating Ansible inventory file..."
echo "[cloud1]" > inventory.ini

i=1
for IP in $INSTANCE_IPS; do
  echo "instance${i} ansible_host=${IP} ansible_user=ubuntu ansible_ssh_private_key_file=$SSH_PATH ansible_python_interpreter=/usr/bin/python3 ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> inventory.ini
  ((i++))
done

echo "📦 Deploying with Ansible..."
ansible-playbook -i inventory.ini playbook.yml

echo "✅ Deployment completed successfully!"
echo -e "\n🔑 To connect via SSH:\n"
echo "ssh -i $SSH_PATH ubuntu@$FIRST_IP"
