#!/bin/bash

set -e

APP_NAME="desafio-devops"
IMAGE_NAME="${APP_NAME}:v1"

echo "Configurando Docker para usar o ambiente do Minikube..."
eval $(minikube docker-env)

echo "Construindo a imagem Docker..."
docker build -t $IMAGE_NAME ../app

echo "Criando namespace..."
kubectl apply -f namespace.yaml

echo "Deployando ingress-nginx..."
kubectl apply -f deploy-ingress-nginx.yaml

echo "Aguardando o ingress-nginx ficar pronto..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

echo "Criando configmap..."
kubectl apply -f configmap.yaml

echo "Criando deployment..."
kubectl apply -f deployment.yaml

echo "Criando service..."
kubectl apply -f service.yaml

echo "Criando ingress..."
kubectl apply -f ingress.yaml

echo "Deploy concluído com sucesso!"