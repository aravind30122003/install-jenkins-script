#!/bin/bash

##################################
# Script : Jenkins installation
# Date   : 28/07/2025
# Name   : Aravind
# version : 01
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

echo "Updating package list..."
sudo apt update
echo "Download and add the Jenkins GPG key:"
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
	     https://pkg.jenkins.io/debian/jenkins.io-2023.key
echo "Add the Jenkins repository to your system's sources list:"

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
	     https://pkg.jenkins.io/debian binary/ | sudo tee \
	          /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "Installing Jenkins..."
sudo apt install jenkins -y

echo "Starting and enabling Jenkins..."
sudo systemctl start jenkins
sudo systemctl enable jenkins

echo "Allowing port 8080 through UFW (if active)..."
sudo ufw allow 8080 || true
sudo ufw reload || true

echo "Jenkins setup completed!"

echo "Access Jenkins at: http://your-ec2-public-ip:8080"



