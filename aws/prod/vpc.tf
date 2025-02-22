# VPC and Internet Gateway
resource "aws_vpc" "projectsprint" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    project = "projectsprint"
    Name    = "projectsprint-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.projectsprint.id

  tags = {
    project = "projectsprint"
    Name    = "projectsprint-igw"
  }
}

# Subnets
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.projectsprint.id
  cidr_block              = "10.0.16.0/21"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true

  tags = {
    project = "projectsprint"
    Name    = "projectsprint-subnet-public-a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.projectsprint.id
  cidr_block              = "10.0.24.0/21"
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = true

  tags = {
    project = "projectsprint"
    Name    = "projectsprint-subnet-public-b"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.projectsprint.id
  cidr_block        = "10.0.0.0/21"
  availability_zone = "ap-southeast-1a"

  tags = {
    project = "projectsprint"
    Name    = "projectsprint-subnet-private-a"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.projectsprint.id
  cidr_block        = "10.0.8.0/21"
  availability_zone = "ap-southeast-1b"

  tags = {
    project = "projectsprint"
    Name    = "projectsprint-subnet-private-b"
  }
}

# Public Route Table and Association
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.projectsprint.id

  tags = {
    project = "projectsprint"
    Name    = "projectsprint-route-table-public"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

# Private Route Table and Associations
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.projectsprint.id

  tags = {
    project = "projectsprint"
    Name    = "projectsprint-route-table-private"
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private.id
}

# ECR API endpoint
# resource "aws_vpc_endpoint" "ecr_api" {
#   vpc_id              = aws_vpc.projectsprint.id
#   service_name        = "com.amazonaws.${var.region}.ecr.api"
#   vpc_endpoint_type   = "Interface"
#   subnet_ids          = [aws_subnet.private_a.id, aws_subnet.private_b.id]
#   security_group_ids  = [module.projectsprint_all_sg.security_group_id]
#   private_dns_enabled = true
# }

# ECR Docker endpoint
# resource "aws_vpc_endpoint" "ecr_dkr" {
#   vpc_id              = aws_vpc.projectsprint.id
#   service_name        = "com.amazonaws.${var.region}.ecr.dkr"
#   vpc_endpoint_type   = "Interface"
#   subnet_ids          = [aws_subnet.private_a.id, aws_subnet.private_b.id]
#   security_group_ids  = [module.projectsprint_all_sg.security_group_id]
#   private_dns_enabled = true
# }

# CloudWatch Logs endpoint
# resource "aws_vpc_endpoint" "logs" {
#   vpc_id              = aws_vpc.projectsprint.id
#   service_name        = "com.amazonaws.${var.region}.logs"
#   vpc_endpoint_type   = "Interface"
#   subnet_ids          = [aws_subnet.private_a.id, aws_subnet.private_b.id]
#   security_group_ids  = [module.projectsprint_all_sg.security_group_id]
#   private_dns_enabled = true
# }

# S3 endpoint
# resource "aws_vpc_endpoint" "s3" {
#   vpc_id            = aws_vpc.projectsprint.id
#   service_name      = "com.amazonaws.${var.region}.s3"
#   vpc_endpoint_type = "Gateway"
#   route_table_ids   = [aws_route_table.private.id]
# }
