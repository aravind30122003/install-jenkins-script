#!/bin/bash

###############################################
# Script : Reset and Reinstall Jenkins (Clean)
# Date   : 29/07/2025
# Author : Aravind
# Version: 02
###############################################

set -e

echo " Stopping Jenkins service (if running)..."
sudo systemctl stop jenkins || true

echo " Removing Jenkins and dependencies..."
sudo apt purge jenkins -y || true
sudo apt autoremove --purge -y || true

echo " Cleaning Jenkins files and logs..."
sudo rm -rf /var/lib/jenkins
sudo rm -rf /var/log/jenkins
sudo rm -rf /etc/default/jenkins
sudo rm -rf /etc/init.d/jenkins

echo " Removing Jenkins repository and GPG key..."
sudo rm -f /etc/apt/sources.list.d/jenkins.list
sudo rm -f /usr/share/keyrings/jenkins-keyring.asc

echo " Updating package list..."
sudo apt update

echo " Installing Java 17..."
sudo apt install openjdk-17-jdk -y
java -version

echo " Adding Jenkins GPG key..."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo " Adding Jenkins repository..."
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | \
    sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

echo " Updating package list again..."
sudo apt update

echo " Installing Jenkins..."
sudo apt install jenkins -y

echo " Starting and enabling Jenkins service..."
sudo systemctl start jenkins
sudo systemctl enable jenkins

echo " Allowing port 8080 through UFW (if active)..."
sudo ufw allow 8080 || true
sudo ufw reload || true

echo " Jenkins has been successfully reset and reinstalled!"
echo " Access Jenkins at: http://<your-ec2-public-ip>:8080"

