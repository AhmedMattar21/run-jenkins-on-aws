#!/bin/bash

# INSTALL JAVA JDK
sudo apt install openjdk-11-jdk

# ADD JENKINS REPO AND ITS KEY
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# INSTALL JENKINS
sudo apt-get update
sudo apt-get install jenkins

# ADD JENKINS PERMISSION TO DOCKER
sudo groupadd -f docker
sudo usermod -aG docker jenkins
newgrp docker