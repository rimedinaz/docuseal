#!/bin/bash
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$SCRIPT_DIR/.."
REPO_ROOT="$SCRIPT_DIR/../.."
ENV_FILE="$ROOT_DIR/.env"

echo "Setting up DocuSeal Standalone Stack..."

# Check artifacts
if [ ! -d "$ROOT_DIR/artifacts/fonts" ] || [ ! -f "$ROOT_DIR/artifacts/model.onnx" ]; then
    echo "Artifacts missing. Attempting to download..."
    if [ -x "$SCRIPT_DIR/download_artifacts.sh" ]; then
        "$SCRIPT_DIR/download_artifacts.sh"
    else
        echo "Error: download_artifacts.sh not found or not executable."
        exit 1
    fi
fi

# Check DocuSeal source existence (basic check)
if [ ! -f "$REPO_ROOT/Gemfile" ] && [ ! -f "$REPO_ROOT/package.json" ]; then
    echo "Warning: DocuSeal source code (Gemfile/package.json) not found in $REPO_ROOT."
    echo "Ensure this 'standalone' directory is placed inside the DocuSeal repository root."
    echo "Or clone the repository into the parent directory."
    read -p "Do you want to attempt to clone DocuSeal here? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Check if directory is empty enough
        if [ "$(ls -A $REPO_ROOT | grep -v standalone | grep -v .git)" ]; then
             echo "Directory $REPO_ROOT is not empty. Cannot clone safely."
             exit 1
        fi
        git clone https://github.com/docusealco/docuseal.git "$REPO_ROOT/docuseal_tmp"
        mv "$REPO_ROOT/docuseal_tmp/"* "$REPO_ROOT/"
        mv "$REPO_ROOT/docuseal_tmp/".* "$REPO_ROOT/" 2>/dev/null || true
        rm -rf "$REPO_ROOT/docuseal_tmp"
    else
        echo "Aborting."
        exit 1
    fi
fi

# Create .version file if missing
if [ ! -f "$REPO_ROOT/.version" ]; then
    echo "Creating dummy .version file..."
    echo "0.0.0-standalone" > "$REPO_ROOT/.version"
fi

# Generate .env with SECRET_KEY_BASE if missing
if [ ! -f "$ENV_FILE" ]; then
    echo "Creating .env file..."
    SECRET_KEY_BASE=$(openssl rand -hex 64 2>/dev/null || echo "changeme_please_change_me_$(date +%s)_$(od -A n -t d -N 2 /dev/urandom | tr -d ' ')")
    echo "SECRET_KEY_BASE=$SECRET_KEY_BASE" > "$ENV_FILE"
    echo "Generated new SECRET_KEY_BASE in .env"
elif ! grep -q "SECRET_KEY_BASE" "$ENV_FILE"; then
    echo "Appending SECRET_KEY_BASE to .env..."
    SECRET_KEY_BASE=$(openssl rand -hex 64 2>/dev/null || echo "changeme_please_change_me_$(date +%s)_$(od -A n -t d -N 2 /dev/urandom | tr -d ' ')")
    echo "SECRET_KEY_BASE=$SECRET_KEY_BASE" >> "$ENV_FILE"
fi

echo "Building and starting containers..."
cd "$ROOT_DIR"
docker compose up -d --build

echo "DocuSeal stack is running."
echo "Access it at https://localhost or https://<your-ip>"
