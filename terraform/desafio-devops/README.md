# 💻 Desafio Terraform - Provisionamento de EC2 com Docker e Apache

## 🎯 Objetivo

- Criar uma instância `t2.micro` (AWS) Linux utilizando **Terraform**.
- A instância deve ter apenas as portas **80** e **443** abertas para todos os IPs.
- A porta **SSH (22)** deve estar acessível apenas para um **range de IP** definido.
- Utilizar **módulos do Terraform** para provisionamento de VPC, EC2 e Security Group.

### 🔁 Inputs esperados

- IP ou range necessário para liberação da porta SSH.
- Região da AWS onde a instância será provisionada.

### 📤 Output

- IP público da instância EC2.

---

## 📁 Estrutura de Arquivos

```bash
.
├── main.tf
├── outputs.tf
├── providers.tf
├── variables.tf
├── terraform.tfvars
├── data.tf
└── README.md
```

---

## 🔍 Processo de Resolução

1. **Módulos**: utilização de módulos da comunidade (`terraform-aws-modules`) para manter o projeto limpo, reutilizável e próximo das boas práticas.
2. **VPC customizada**:
   - Criação de uma VPC com subnet pública e ACL padrão para permitir comunicação externa.
   - Foi usado um `data source` para obter a zona de disponibilidade da região definida, tornando o projeto mais flexível.
   - **OBS**: Não foi utilizado o parâmetro `default` na variável `provider_region` para exigir o valor quando o comando **Apply** for executado.
3. **Instância EC2**:
   - AMI pública do Ubuntu.
   - Tipo `t2.micro` para se manter dentro do tier gratuito.
   - Docker pré-instalado via `user_data`.
   - Apache executado dentro de um container Docker.
4. **Segurança**:
   - Porta 22 liberada apenas para IPs definidos via variável (`ip_range_ssh`).
   - Portas 80 e 443 liberadas para todos os IPs (necessário para acesso HTTP/HTTPS).
   - - **OBS**: Não foi utilizado o parâmetro `default` na variável `ip_range_ssh` para exigir o valor quando o comando **Apply** for executado.
5. **Boas práticas**:
   - Utilização de outputs para retornar o IP da instância.
   - Separação de arquivos (`main.tf`, `outputs.tf`, `variables.tf`, `providers.tf`).
   - Inclusão de `user_data_replace_on_change = true` para recriar automaticamente a instância quando o houver alterações no `user_data`.

---

## 🚀 Como utilizar

### Pré-requisitos

- Terraform
- AWS CLI configurado (`aws configure`)
- Chave SSH pública gerada em `~/.ssh/desafio.pub`

### Passos

1. Execute os comandos Terraform:

   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

2. Quando os comandos **Plan** e **Apply** forem executados, será necessário inserir o valor das variáveis `provider_region` e `ip_range_ssh`.

3. Após o provisionamento, o IP público da instância será exibido no terminal:

   ```
   Outputs:
   public_instance_ip = "XX.XX.XX.XX"
   ```

4. Acesse o IP via navegador e você verá a página padrão do Apache:

   ```
   http://<public ip>
   ```
