resource "aws_route_table" "private" {
  vpc_id = aws_vpc.eks_main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks_nat.id
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eks_main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }
}

resource "aws_route_table_association" "private_eu_west_1a" {
    subnet_id = aws_subnet.private_eu_west_1a.id
    route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_eu_west_1b" {
    subnet_id = aws_subnet.private_eu_west_1b.id
    route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public_eu_west_1a" {
    subnet_id = aws_subnet.public_eu_west_1a.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_eu_west_1b" {
    subnet_id = aws_subnet.public_eu_west_1b.id
    route_table_id = aws_route_table.public.id
}