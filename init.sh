#!/bin/bash

# --- 1. SETUP SERVER ENVIRONMENT ---
cd server
echo "[MCP Snap] Checking server environment..."

# Check if the 'venv' directory already exists
if [ -d venv ]; then
    echo "[MCP Snap] Virtual environment 'server/venv' already exists. Skipping creation and installation."
else
    # Create Venv, Activate, Install, and Deactivate
    echo "[MCP Snap] Creating virtual environment for server..."
    python -m venv venv

    echo "[MCP Snap] Installing requirements for server..."
    # Note: Using '|| true' here is a common pattern to prevent the entire script from failing
    # if the venv activation fails due to shell incompatibilities, though it usually works.
    source venv/bin/activate || true 
    pip install -r requirements.txt
    deactivate
    echo "[MCP Snap] Server setup complete."
fi

# Change back to the parent directory and then into the chat directory
cd ../chat
echo "[MCP Snap] Checking chat environment..."

# --- 2. SETUP CHAT ENVIRONMENT ---

# Check if the 'venv' directory already exists
if [ -d venv ]; then
    echo "[MCP Snap] Virtual environment 'chat/venv' already exists. Skipping creation and installation."
else
    # Create Venv, Activate, Install, and Deactivate
    echo "[MCP Snap] Creating virtual environment for chat..."
    python -m venv venv

    echo "[MCP Snap] Installing requirements for chat..."
    source venv/bin/activate || true
    pip install -r requirements.txt
    deactivate
    echo "[MCP Snap] Chat setup complete."
fi

echo "[MCP Snap] All environments checked and set up successfully."
