#!/bin/bash

set -e

echo "Configurando Docker para usar o ambiente do Minikube..."
eval $(minikube docker-env)

echo "Construindo a imagem Docker..."
docker build -t desafio-devops:v1 -f ../Dockerfile ../

echo "Instalando aplicação com Helm..."
helm upgrade --install desafio . \
  --namespace app-desafio \
  --create-namespace \
  --set app.name="Vinicius" \
  --set app.image.tag="v1"

echo "Deploy concluído com sucesso!"
echo "URL: http://$(minikube ip)/desafio-devops"