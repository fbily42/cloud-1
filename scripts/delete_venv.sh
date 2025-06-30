#!/bin/bash

VENV_NAME="$HOME/.cloud1"

if [ -d "$VENV_NAME" ]; then
  echo "🧹 Suppression du venv '$VENV_NAME'..."
  rm -rf "$VENV_NAME"
  echo "✅ Venv supprimé."
else
  echo "ℹ️ Aucun venv trouvé à $VENV_NAME"
fi
