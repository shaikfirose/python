# vpc.tf

# VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
}

# Route Table for Public Subnets (associates IGW with VPC via route table)
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  
  # Route for outbound internet traffic through the Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"  # Direct all outbound traffic
    gateway_id = aws_internet_gateway.igw.id  # Route through the Internet Gateway
  }
}

# Public Subnet 1 in Availability Zone 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"  # Specify the AZ; adjust if necessary
  map_public_ip_on_launch = true
}

# Public Subnet 2 in Availability Zone 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"  # Specify a different AZ; adjust if necessary
  map_public_ip_on_launch = true
}

# Route Table Association for Public Subnet 1
resource "aws_route_table_association" "public_rt_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

# Route Table Association for Public Subnet 2
resource "aws_route_table_association" "public_rt_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}
