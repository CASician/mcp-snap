#!/bin/bash

cd chat/ || { echo "❌ /chat/ directory not found."; exit 1; }
source venv/bin/activate
python client.py ../server/server.py
