#!/bin/bash

##################################
# Script : Jenkins installation
# Date   : 28/07/2025
# Name   : Aravind
# Version: 01
##################################

set -e

echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

echo "Installing Java 17..."
sudo apt install openjdk-17-jdk -y
java -version

if systemctl is-active --quiet jenkins; then
    echo "⚠️ Jenkins is already installed and running."
    exit 0
fi

echo "Adding Jenkins repository and key..."

# Add the Jenkins GPG key (updated for 2025)
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null

# Add the repository using the correct format
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | \
    sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "Updating APT after adding Jenkins repo..."
sudo apt update

echo "Installing Jenkins..."
sudo apt install jenkins -y

echo "Starting and enabling Jenkins..."
sudo systemctl start jenkins
sudo systemctl enable jenkins

echo "Allowing port 8080 through UFW (if active)..."
sudo ufw allow 8080 || true
sudo ufw reload || true

echo "✅ Jenkins setup completed!"
echo "🌐 Access Jenkins at: http://<your-ec2-public-ip>:8080"




