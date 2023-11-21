#!/bin/sh

# $1 is the ecr url

# Setup Docker
if command -v docker &> /dev/null
then
  sudo yum update
  sudo yum install docker
  sudo systemctl enable --now docker 
  sudo groupadd docker
  sudo usermod -aG docker ec2-user
fi

cd ~

# Login and pull
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $1

cats=$1/l3-cats-repo:latest
dogs=$1/l3-dogs-repo:latest

docker pull $cats
docker pull $dogs

# Deploy
docker run -dp 8081:80 $dogs
docker run -dp 8080:80 $cats




