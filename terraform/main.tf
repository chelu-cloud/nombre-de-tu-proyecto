module "vpc" {
  source = "./vpc"
}

module "app-cluster" {
  source = "./app-cluster"

  vpc_id            = module.vpc.vpc_id
  manager_subnet_id = module.vpc.manager_subnet_id
  workers_subnet_id = module.vpc.workers_subnet_id
  manager_private_ip = module.vpc.manager_private_ip
}

resource "local_file" "ansible_inventory" {
  content = <<-EOT
    [managers]
    manager ansible_host=${module.app-cluster.manager_public_ip}

    [workers]
    %{ for i, ip in module.app-cluster.workers_public_ips ~}
    worker-${i} ansible_host=${ip}
    %{ endfor ~}

    [all:vars]
    ansible_user=ubuntu
    ansible_ssh_private_key_file=~/.ssh/swarm_key
    ansible_ssh_common_args='-o StrictHostKeyChecking=no'
  EOT
  filename = "../ansible/inventory/hosts.ini"
}