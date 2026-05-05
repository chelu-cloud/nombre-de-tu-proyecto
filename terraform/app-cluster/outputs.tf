output "manager_public_ip" { value = aws_instance.manager.public_ip }
output "manager_private_ip" { value = aws_instance.manager.private_ip }
output "workers_public_ips" { value = aws_instance.workers[*].public_ip }
output "workers_private_ips" { value = aws_instance.workers[*].private_ip }
output "security_group_id" { value = aws_security_group.swarm_sg.id }
