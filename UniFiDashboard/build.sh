#!/bin/bash

# Set script to exit on error
set -e

echo "🛠️  Checking for Python and Pip..."

# Detect Python version
if command -v python3 &>/dev/null; then
    PYTHON="python3"
elif command -v python &>/dev/null; then
    PYTHON="python"
else
    echo "❌ Python is not installed. Please install Python and rerun the script."
    exit 1
fi

# Detect Pip version
if command -v pip3 &>/dev/null; then
    PIP="pip3"
elif command -v pip &>/dev/null; then
    PIP="pip"
else
    echo "❌ Pip is not installed. Please install Pip and rerun the script."
    exit 1
fi

echo "✅ Python found: $($PYTHON --version)"
echo "✅ Pip found: $($PIP --version)"

# Ask the user for the UniFi IP address
read -p "🔹 Enter your UniFi Controller IP (e.g., https://192.168.1.1:8443): " UNIFI_IP

# Validate the IP format
if [[ ! "$UNIFI_IP" =~ ^https?://[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+(:[0-9]+)?$ ]]; then
    echo "❌ Invalid IP format. Please enter a valid UniFi Controller IP (e.g., https://192.168.1.1:8443)."
    exit 1
fi

# Update the IP address in main.py
echo "🔄 Updating UniFi Controller IP in main.py..."
sed -i "s|UNIFI_HOST = .*|UNIFI_HOST = \"$UNIFI_IP\"|" main.py
echo "✅ UniFi Controller IP updated to: $UNIFI_IP"

# Install dependencies
echo "📦 Installing dependencies..."
$PIP install -r requirements.txt
$PIP install pyinstaller

# Run PyInstaller to create an executable
APP_NAME="unifi_dashboard"
echo "🚀 Building the application with PyInstaller..."
$PYTHON -m PyInstaller --onefile --name "$APP_NAME" main.py

# Clean up unnecessary files
echo "🧹 Cleaning up..."
rm -rf build *.spec

# Provide final steps
echo -e "\n✅ Setup Complete! Follow these steps to use the application:"
echo "-----------------------------------------------------"
echo "1️⃣  Navigate to the 'dist' folder: cd dist"
echo "2️⃣  Run the application: ./${APP_NAME}"
echo "-----------------------------------------------------"
echo "🎉 Enjoy your UniFi Dashboard!"
