#!/bin/bash

# Update system packages
sudo yum update -y

# Install and Start Docker
sudo yum install docker -y
sudo usermod -a -G docker ec2-user
sudo systemctl start docker.service

# Authenticate with ECR (make sure EC2 instance profile has permission)
sudo aws ecr get-login-password --region us-west-1 | sudo docker login --username AWS --password-stdin <ECR-Repo-URL> ;

# Start the Jenkins server container (Jenkins WebUI will be on port 80; setup SGs appropriately)
sudo docker run -d --name jenkins-server -p 80:8080 -e AGENT_HOST="<AGENT-IP>" -e AGENT_PORT="<AGENT-SSH-PORT>"  <jenkins-server-image-name> ;
