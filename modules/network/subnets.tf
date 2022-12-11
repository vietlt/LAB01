resource "aws_subnet" "public_subnet_linux" {
  vpc_id = aws_vpc.lab_vpc.id
  cidr_block = var.public_ip[0]
  map_public_ip_on_launch = "true"

  tags = {
    Name = "public_subnet_linux"
  }
}

resource "aws_subnet" "public_subnet_windows" {
  vpc_id = aws_vpc.lab_vpc.id
  cidr_block = var.public_ip[1]
  map_public_ip_on_launch = "true"

  tags = {
    Name = "public_subnet_windows"
  }
}