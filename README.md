# Projeto WordPress Kubernetes com Terraform

Este projeto implementa um servidor WordPress e bancos de dados PostgreSQL e Redis em um cluster Kubernetes utilizando Minikube e Terraform.

## Pré-requisitos

- Minikube instalado e configurado.
- Terraform versão 0.15 ou superior.

## Estrutura de Diretórios

A estrutura do projeto está organizada da seguinte forma:

- `/wordpress` - Contém os arquivos Terraform para o deployment do WordPress.
- `/databases` - Contém os arquivos Terraform para os deployments dos bancos de dados PostgreSQL e Redis.
- `/scripts` - Scripts auxiliares como o `load_data.py` para carregar dados nos bancos de dados.
- `/configmaps` - Contém Configmap para executar o script Python da pasta `scripts`.
- `README.md` - Documentação do projeto.

## Implantação

### WordPress

O deployment do WordPress está configurado para ser acessível externamente e possui escalabilidade automática.

### Bancos de Dados

Os deployments dos bancos de dados PostgreSQL e Redis são persistentes e configurados para retenção de dados após reinicializações. Acesso controlado é concedido à equipe.

## Uso

Para realizar o deploy do ambiente completo, siga os passos abaixo:

1. Inicie o Minikube com `minikube start`. Garanta que sua instalação esteja usando Kubernetes na versão 1.28.
2. Navegue até o diretório do serviço desejado e execute `terraform init`, `terrafom plan` e por fim `terraform apply` para as pastas do projeto seguindo a sequência abaixo.

    - databases
    - Na raíz do projeto para criar o configmap
    - wordpress

## Variáveis

As variáveis necessárias, como nomes de usuários e senhas, estão documentadas em cada módulo do Terraform e podem ser configuradas conforme a necessidade do ambiente. IMPORTANTE: Lembre-se, este é apenas um projeto de exemplo para ambiente de desenvolvimento local. Para ambientes produtivos, utilizar Hashicorp Vault para armazenar as credenciais de acesso.

## Carregamento de Dados

Para carregar dados nos bancos de dados, utilize o script `load_data.py` disponível na pasta `/scripts`. Veja o Configmap existente para uso.

## Contato

Pedro Duarte
