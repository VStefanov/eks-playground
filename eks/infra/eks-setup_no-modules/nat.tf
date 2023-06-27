resource "aws_eip" "eks_nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "eks_nat" {
  allocation_id = aws_eip.eks_nat_eip.id
  subnet_id = aws_subnet.public_eu_west_1a.id

  depends_on = [ aws_internet_gateway.eks_igw ]
}