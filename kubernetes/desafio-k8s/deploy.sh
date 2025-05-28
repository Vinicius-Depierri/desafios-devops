#!/bin/bash

set -e

GREEN='\033[1;32m'
CHECK="\xE2\x9C\x94" 

echo "Configurando Docker para usar o ambiente do Minikube..."
eval $(minikube docker-env)

echo "Construindo a imagem Docker..."
docker build -t desafio-devops:v1 -f ../Dockerfile ../

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