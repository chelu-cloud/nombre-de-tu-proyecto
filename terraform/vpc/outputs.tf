output "vpc_id" {
    value = aws_vpc.main.id 
}
output "manager_subnet_id" {
    value = aws_subnet.manager_subnet.id 
}
output "workers_subnet_id" { 
    value = aws_subnet.workers_subnet.id 
}

output "manager_private_ip" { 
    value = aws_subnet.manager_subnet.id
}