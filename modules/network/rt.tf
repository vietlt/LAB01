resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.lab_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab_igw.id
  }

  tags = {
    Name = "rt"
  }
}

resource "aws_route_table_association" "rta-1" {
  subnet_id = aws_subnet.public_subnet_linux.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "rta-2" {
  subnet_id = aws_subnet.public_subnet_windows.id
  route_table_id = aws_route_table.rt.id
}
