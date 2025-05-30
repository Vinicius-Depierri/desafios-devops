# 💻 Desafio DevOps com Helm e Kubernetes

## 🎯 Objetivo

- Construir a imagem docker da aplicação.
- Criar os manifestos de recursos kubernetes para rodar a aplicação (`deployments`, `services`, `ingresses`, `configmap` e qualquer outro que você considere necessário).
- Criar um **script** para a execução do deploy em uma única execução.
- A aplicação deve ter seu deploy realizado com uma **única linha de comando** em um cluster kubernetes local.
- Todos os pods devem estar rodando.
- A aplicação deve responder à uma **URL específica** configurada no ingress.

---

## 📁 Estrutura de Arquivos

```bash
.
├── app/
│  ├── app.js
│  └── package.json
├── desafio-devops/
│  ├── chart.yaml
│  ├── chart.lock
│  ├── values.yaml
│  ├── deploy.sh
│  └── templates/
│     ├── deployment.yaml
│     ├── service.yaml
│     ├── ingress.yaml
│     ├── configmap.yaml
│     └── README.md
└── Dockerfile
```

---

## 🔍 Processo de Resolução

1. **Criação do Helm Chart**
   - Adoção de Helm Charts para padronizar a implantação e permitir configuração dinâmica através de valores.
   - Organização dos templates seguindo as melhores práticas de separação de responsabilidades.
   - Criação de um ConfigMap para definir a variável de ambiente NAME para meu nome.
   - Criação de um Service do tipo ClusterIP para comunicação interna entre pods.
   - Implementação do Ingress com NGINX Controller para roteamento externo, incluindo:
      - Path específico (/desafio-devops) para isolamento de rotas.
      - Rewrite rules para substituição do nome via annotation.
   - Integração do Ingress-Nginx como subchart para garantir a instalação automática.

2. **Probes e Recursos**
   - Adição de `liveness` e `readiness probes` para garantir alta disponibilidade.
   - Definido `requests` e `limits` de CPU/memória para a aplicação.

3. **Deploy Automatizado**
   - Script `deploy.sh` automatiza o processo:
     - Configura Docker para o ambiente Minikube.
     - Realiza o build da imagem localmente.
     - Executa instalação via `helm upgrade --install`.

4. **Ingress Controller**
   - Adicionada dependência do `ingress-nginx` no `Chart.yaml`.
   - Configuração no `values.yaml` permite ativar/desativar e customizar o Ingress.

5. **Boas Práticas**
   - Isolamento em namespaces dedicados (app-desafio e ingress-nginx).
   - Configuração de probes com tempos personalizados para inicialização da aplicação.
   - Controle de versão da imagem Docker através de tags.

---

## 🚀 Como Utilizar

### Pré-requisitos

   -  Docker
   -  Minikube
   -  Helm 3.x
   -  kubectl

### Passos

1. Dar permissão de execução ao script e executá-lo:

   ```bash
   chmod +x deploy.sh
   ./deploy.sh
   ```

2. Acessar a aplicação:

   - Ao final da execução do script será mostrado a URL para acessar a aplicação:
     `URL: http://$(minikube ip)/desafio-devops`
   - Como o Minikube roda em uma VM com IP próprio e expõe os serviços NodePort em portas altas (ex: 30000), utilize `sudo socat TCP-LISTEN:80,fork TCP:<minikube ip>:30000` para fazer o redirecionamento.
   - Acesse a aplicação via navegador:  
     `http://localhost/desafio-devops`
     

3. A aplicação irá responder:
   ```
   Olá Vinicius!
   ```

