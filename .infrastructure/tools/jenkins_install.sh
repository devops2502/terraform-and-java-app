#!/bin/bash
set -e

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y openjdk-17-jre fontconfig curl gnupg2

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update
sudo apt-get install -y jenkins

sudo systemctl start jenkins
sudo systemctl enable jenkins
