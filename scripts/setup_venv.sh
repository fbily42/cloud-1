#!/bin/bash

set -e

VENV_NAME="$HOME/.cloud1"
ENV_FILE=".env"

# Charge les variables depuis .env
if [ ! -f "$ENV_FILE" ]; then
  echo "❌ ERREUR : fichier $ENV_FILE introuvable."
  exit 1
fi

# Lire toutes les lignes non commentées (#) et non vides
export $(grep -v '^#' "$ENV_FILE" | xargs)

# 1. Créer le venv s’il n’existe pas
if [ -d "$VENV_NAME" ]; then
  echo "⚠️ Le venv '$VENV_NAME' existe déjà."
else
  echo "📦 Création du venv Python dans $VENV_NAME..."
  python3 -m venv "$VENV_NAME"
fi

# 2. Activer le venv
echo "🚀 Activation du venv..."
source "$VENV_NAME/bin/activate"

# 3. Mise à jour de pip
pip install --upgrade pip

# 4. Installer Ansible
if ! pip show ansible > /dev/null 2>&1; then
  echo "🔧 Installation d'Ansible..."
  pip install ansible
else
  echo "✅ Ansible est déjà installé."
fi

# 5. Installer Terraform
if ! command -v terraform > /dev/null; then
  echo "⬇️ Téléchargement de Terraform..."
  TEMP_DIR=$(mktemp -d)
  curl -fsSL https://releases.hashicorp.com/terraform/1.12.2/terraform_1.12.2_linux_amd64.zip -o $TEMP_DIR/terraform.zip
  unzip $TEMP_DIR/terraform.zip -d "$VENV_NAME/bin/"
  chmod +x "$VENV_NAME/bin/terraform"
  rm -rf $TEMP_DIR
  echo "✅ Terraform installé localement dans le venv."
else
  echo "✅ Terraform est déjà disponible (globalement ou dans le path)."
fi

echo "🌍 Version Ansible : $(ansible --version | head -n1)"
echo "🌍 Version Terraform : $(terraform version | head -n1)"

# 5. Ajouter les credentials AWS à l'activation du venv
AWS_EXPORTS=$(cat <<EOF

# === AWS credentials ===
export AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY"
export AWS_DEFAULT_REGION="$AWS_DEFAULT_REGION"
EOF
)

# Ajoute seulement si non déjà présent
if ! grep -q "AWS_ACCESS_KEY_ID" "$VENV_NAME/bin/activate"; then
  echo "$AWS_EXPORTS" >> "$VENV_NAME/bin/activate"
  echo "🔐 AWS credentials ajoutés au venv (activation automatique)."
else
  echo "✅ Les exports AWS sont déjà présents dans le venv."
fi

echo "✅ Le venv est prêt. Pour l’utiliser, tape :"
echo "   source $VENV_NAME/bin/activate"
