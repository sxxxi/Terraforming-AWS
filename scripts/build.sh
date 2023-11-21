#!/bin/sh

# Login and build
aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin $1

sudo docker build -t l3-cats-repo cats
sudo docker build -t l3-dogs-repo dogs

sudo docker tag l3-cats-repo:latest $1/l3-cats-repo:latest
sudo docker tag l3-dogs-repo:latest $1/l3-dogs-repo:latest

sudo docker push $1/l3-cats-repo:latest
sudo docker push $1/l3-dogs-repo:latest
