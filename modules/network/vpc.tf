resource "aws_vpc" "lab_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = "true"
  enable_dns_support = "true"

  tags = {
    Name = "lab_vpc"
  }
}

output "lab_vpc_out" {
  value = aws_vpc.lab_vpc.id
}

output "linux_subnet_out" {
  value = aws_subnet.public_subnet_linux
}

output "windows_subnet_out" {
  value = aws_subnet.public_subnet_windows
}