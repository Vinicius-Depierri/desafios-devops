# Desafio DevOps com Helm e Kubernetes

Este projeto consiste em uma aplicação Node.js containerizada e implantada em um cluster Kubernetes utilizando Helm Charts. A aplicação responde com uma saudação personalizada utilizando uma variável de ambiente.

## 🧩 Desafio

O objetivo deste desafio é criar um ambiente para a aplicação utilizando Kubernetes e Helm, utilizando Ingress, ConfigMaps, Probes e boas práticas de deploy automatizado.

---

## 📦 Estrutura do Projeto

- `app/`: Aplicação Node.js simples
- `desafio-devops/`: Helm Chart
- `deploy.sh`: Script para build e deploy com Minikube
- `Dockerfile`: Container da aplicação

---

## 🔍 Processo de Resolução dos Desafios

1. **Containerização da Aplicação**
   - Criado `Dockerfile` baseado em `node:9-alpine`.
   - A aplicação expõe a porta 3000 e retorna uma saudação com a variável `NAME`.

2. **Criação do Helm Chart**
   - Utilizado Helm Chart com templates:
     - `deployment.yaml`: define pods, health checks, resources e uso de `ConfigMap`.
     - `service.yaml`: expõe a aplicação internamente via `ClusterIP`.
     - `ingress.yaml`: mapeia o endpoint para acesso externo via `Ingress NGINX`.
     - `configmap.yaml`: armazena a variável de ambiente `NAME`.
     - `values.yaml`: define os valores que serão usados nas variáveis, como nome, imagem, portas, probes, ingress, etc.

4. **Probes e Recursos**
   - Adição de `liveness` e `readiness probes` para garantir alta disponibilidade.
   - Definido `requests` e `limits` de CPU/memória para a aplicação.

5. **Deploy Automatizado**
   - Script `deploy.sh` automatiza o processo:
     - Configura Docker para o ambiente Minikube.
     - Realiza o build da imagem localmente.
     - Executa instalação via `helm upgrade --install`.

6. **Ingress Controller**
   - Adicionada dependência do `ingress-nginx` no `Chart.yaml`.
   - Configuração no `values.yaml` permite ativar/desativar e customizar o Ingress.

---

## 🚀 Como Utilizar a Solução

1. **Pré-requisitos**
   - [x] Docker
   - [x] Minikube
   - [x] Helm 3.x
   - [x] kubectl

2. **Passos para Deploy**
   ```bash
   chmod +x deploy.sh
   ./deploy.sh
   ```

3. **Acesso à aplicação**
   Após o deploy:
   - Obtenha o IP do Minikube:  
     `minikube ip`
   - Acesse a aplicação via navegador:  
     `http://<minikube-ip>/desafio-devops`

   A aplicação irá responder:
   ```
   Olá Vinicius!
   ```

---

## 🛠 Tecnologias Utilizadas

- Node.js (v9)
- Docker
- Kubernetes
- Helm
- Minikube
- Ingress-NGINX

---

## ✅ Conclusão

Este projeto demonstra a capacidade de empacotar, parametrizar e implantar aplicações em Kubernetes utilizando Helm Charts, aplicando boas práticas como health checks, recursos limitados e deploy automatizado com Minikube.
