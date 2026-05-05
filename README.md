# Enterprise Cloud Infrastructure: Automated AWS Swarm Cluster

[![Terraform](https://img.shields.io/badge/Terraform-1.5+-623CE4?logo=terraform)](https://www.terraform.io/)
[![Ansible](https://img.shields.io/badge/Ansible-2.14+-EE0000?logo=ansible)](https://www.ansible.com/)
[![Docker Swarm](https://img.shields.io/badge/Docker-Swarm-2496ED?logo=docker)](https://www.docker.com/)
[![Security: OIDC](https://img.shields.io/badge/Security-OIDC_Auth-green)](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect)

Este repositorio contiene la arquitectura completa de una infraestructura elástica y automatizada en **AWS**. El objetivo es demostrar un flujo real de **GitOps**, donde la infraestructura se define mediante código (IaC), se configura automáticamente y se despliega a través de pipelines de CI/CD.

---

## Arquitectura de Red y Sistemas

La infraestructura ha sido diseñada siguiendo el principio de **Mínimo Privilegio** y **Alta Disponibilidad**:

- **Networking (VPC):** Segmentación en subredes públicas (para el NAT Gateway/ALB) y privadas para los nodos del clúster.
- **Orquestación:** Clúster de **Docker Swarm** autogestionado.
- **Provisionamiento:** Terraform modularizado para separar el ciclo de vida de la red del de la computación.
- **Gestión de Configuración:** Ansible Roles para endurecimiento (hardening) del OS y configuración de la malla de red de Docker.

---

## Stack Tecnológico

| Capa | Herramienta | Función |
| :--- | :--- | :--- |
| **IaC** | Terraform | Aprovisionamiento de VPC, IGW, Subnets, Security Groups y EC2. |
| **Config Management** | Ansible | Instalación de dependencias, Docker Engine y orquestación de nodos. |
| **Container Engine** | Docker Swarm | Gestión de contenedores y Service Discovery. |
| **CI/CD** | GitHub Actions | Pipelines automatizados para `plan/apply` de Terraform. |

---

## Estructura del Repositorio

```text
├── .github/
│   └── workflows/        # Pipelines de CI/CD (GitHub Actions)
├── ansible/
│   ├── roles/            # Roles reutilizables (Docker, Swarm-Master, Swarm-Worker)
│   ├── inventory/
│   │   └── hosts.ini     # Inventario de nodos
│   ├── site.yml          # Playbook principal
│   └── ansible.cfg       # Optimización de conexiones SSH
└── terraform/
    ├── modules/          # Módulos encapsulados (VPC, EC2)
    ├── main.tf           # Entrada principal (Root module)
    ├── variables.tf      # Variables parametrizadas
    ├── outputs.tf        # Outputs exportados
    └── providers.tf      # Configuración de AWS y Backend remoto
```

---

## Seguridad y Buenas Prácticas

- **Zero Hardcoded Credentials:** No se almacenan claves de AWS. El proyecto utiliza **OIDC** para que GitHub Actions asuma roles de IAM temporales directamente, sin secretos de larga duración.
- **State Management:** Uso de **S3 + DynamoDB** para almacenamiento remoto y bloqueo del estado de Terraform (`terraform.tfstate`), evitando condiciones de carrera en entornos de equipo.
- **Idempotencia:** Todos los Playbooks de Ansible están diseñados para ser ejecutados múltiples veces sin alterar el estado final si no hay cambios.
- **Principio de Mínimo Privilegio:** Los Security Groups limitan el tráfico estrictamente al necesario entre capas.

---

## Despliegue Rápido

### Pre-requisitos

- AWS CLI configurado (`aws configure`)
- Terraform `>= 1.5`
- Ansible `>= 2.14`

### Paso 1: Infraestructura con Terraform

```bash
cd terraform
terraform init
terraform plan -out=main.tfplan
terraform apply "main.tfplan"
```

### Paso 2: Configuración del Clúster con Ansible

```bash
cd ../ansible
# El inventario se genera dinámicamente o se define en hosts.ini
ansible-playbook -i inventory/hosts.ini site.yml
```

### Paso 3: Verificar el estado del Swarm

```bash
# Conectarse al nodo manager y listar los servicios activos
ssh ec2-user@<MANAGER_IP> "docker node ls && docker service ls"
```

---

## Limpieza de Recursos

>  **Disclaimer:** Este proyecto incurre en costes reales de AWS. Ejecuta el siguiente comando al finalizar las pruebas para evitar cargos inesperados.

```bash
cd terraform
terraform destroy
```

---

## Licencia

Distribuido bajo la licencia MIT. Consulta el archivo `LICENSE` para más información.

---

Developed with ❤️ by chelucloud / cheludev (my other github) · [LinkedIn](https://www.linkedin.com/in/jose-luis-salvador-martin-b88ba3292/)
