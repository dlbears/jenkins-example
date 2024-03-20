#!/bin/bash

# Update system packages
sudo yum update -y

# Install and Start Docker
sudo yum install docker -y
sudo usermod -a -G docker ec2-user
sudo systemctl start docker.service

# Authenticate with ECR (make sure EC2 instance profile has permission)
# Note: if you are in a private subnet make sure to create the necessary VPC Endpoints (2 ECR Interface EPs, 1 S3 Gateway EP)
sudo aws ecr get-login-password --region us-west-1 | sudo docker login --username AWS --password-stdin <ECR-Repo-URL> ;

# Start the Jenkins server container (make sure to configure SG to allow access over port 2222)
# Alternate: Forward the EC2 SSH Agent into docker and change to -p 22:22
sudo docker run -d --name jenkins-agent -p 2222:22 <jenkins-agent-image-name> ;
