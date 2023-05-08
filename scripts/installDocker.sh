#!/bin/bash

# REMOVE OLD VERSIONS
sudo apt-get remove docker docker-engine docker.io containerd runc

# INSTALL DEPENDANCES
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg

# ADD DOCKER'S OFFICIAL GPG KEY
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# SETUP DOCKER REPO
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# INSTALL DOCKER
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
