resource "aws_ec2_transit_gateway" "shared_tgw" {
 
  description                     = "Transit gateway to connect mgmt,dev and prod VPC"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  tags = {
    Name        = "tgw-shared"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "mgmt_attachment" {
 
  subnet_ids         = module.mgmt_vpc.private_subnets
  transit_gateway_id = aws_ec2_transit_gateway.shared_tgw.id
  vpc_id             = module.mgmt_vpc.vpc_id
  tags = {
    "Name" = "transit-gateway-mgmt-attachment"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "dev_attachment" {
 
  subnet_ids         = module.dev_vpc.private_subnets
  transit_gateway_id = aws_ec2_transit_gateway.shared_tgw.id
  vpc_id             = module.dev_vpc.vpc_id
  tags = {
    "Name" = "transit-gateway-dev-attachment"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "prod_attachment" {
 
  subnet_ids         = module.prod_vpc.private_subnets
  transit_gateway_id = aws_ec2_transit_gateway.shared_tgw.id
  vpc_id             = module.prod_vpc.vpc_id
  tags = {
    "Name" = "transit-gateway-dev-attachment"
  }
}

# MGMT VPC TransitGateway setup
resource "aws_route" "tgw_route_mgmt_dev" {
  route_table_id         = module.mgmt_vpc.private_route_table_ids[0]
  destination_cidr_block = "10.20.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.shared_tgw.id
  depends_on = [
    aws_ec2_transit_gateway.shared_tgw
  ]
}

resource "aws_route" "tgw_route_mgmt_prod" {
  route_table_id         = module.mgmt_vpc.private_route_table_ids[0]
  destination_cidr_block = "10.30.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.shared_tgw.id
  depends_on = [
    aws_ec2_transit_gateway.shared_tgw
  ]
}

# DEV VPC TransitGateway setup
resource "aws_route" "tgw_route_dev_mgmt" {
  route_table_id         =  module.dev_vpc.private_route_table_ids[0]
  destination_cidr_block = "10.10.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.shared_tgw.id
  depends_on = [
    aws_ec2_transit_gateway.shared_tgw
  ]
}

resource "aws_route" "tgw_route_dev_prod" {
  route_table_id         = module.dev_vpc.private_route_table_ids[0]
  destination_cidr_block = "10.30.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.shared_tgw.id
  depends_on = [
    aws_ec2_transit_gateway.shared_tgw
  ]
}

# PROD VPC TransitGateway setup
resource "aws_route" "tgw_route_prod_mgmt" {
  route_table_id         = module.prod_vpc.private_route_table_ids[0]
  destination_cidr_block = "10.10.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.shared_tgw.id
  depends_on = [
    aws_ec2_transit_gateway.shared_tgw
  ]
}

resource "aws_route" "tgw_route_prod_dev" {
  route_table_id         = module.prod_vpc.private_route_table_ids[0]
  destination_cidr_block = "10.20.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.shared_tgw.id
  depends_on = [
    aws_ec2_transit_gateway.shared_tgw
  ]
}