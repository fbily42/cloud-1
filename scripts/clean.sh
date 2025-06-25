#!/bin/bash

set -e

echo "🧨 Destroying Terraform infrastructure..."
cd terraform
terraform destroy -auto-approve

cd ../ansible

echo "🧼 Cleaning generated inventory..."
rm -f inventory.ini

echo "🗑️ Cleaning Terraform state files..."
cd ../terraform
rm -f terraform.tfstate terraform.tfstate.backup .terraform.lock.hcl
rm -rf .terraform

echo "✅ Cleanup completed!"
