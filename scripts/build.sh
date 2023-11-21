#!/bin/sh

# Login and build
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $1

docker build -t l3-cats-repo cats
docker build -t l3-dogs-repo dogs

docker tag l3-cats-repo:latest $1/l3-cats-repo:latest
docker tag l3-dogs-repo:latest $1/l3-dogs-repo:latest

docker push $1/l3-cats-repo:latest
docker push $1/l3-dogs-repo:latest
