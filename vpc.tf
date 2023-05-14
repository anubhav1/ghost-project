# Creating VPC
resource "aws_vpc" "ghostvpc" {
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "default"
  tags = {
    Name = "GhostVPC"
  }
}

# Creating 1st Public subnet 
resource "aws_subnet" "public-subnet-a" {
  vpc_id                  = aws_vpc.ghostvpc.id
  cidr_block             = "${var.public_subnet_A_cidr}"
  map_public_ip_on_launch = true
  availability_zone = "${var.primary_region_azs[0]}"
tags = {
    Name = "Public Subnet A"
  }
}

# Creating 2nd Public subnet 
resource "aws_subnet" "public-subnet-b" {
  vpc_id                  = aws_vpc.ghostvpc.id
  cidr_block             = "${var.public_subnet_B_cidr}"
  map_public_ip_on_launch = true
  availability_zone = "${var.primary_region_azs[1]}"
tags = {
    Name = "Public Subnet B"
  }
}

# Creating 1st application subnet 
resource "aws_subnet" "application-subnet-a" {
  vpc_id                  = aws_vpc.ghostvpc.id
  cidr_block             = "${var.application_subnet_A_cidr}"
  map_public_ip_on_launch = false
  availability_zone = "${var.primary_region_azs[0]}"
tags = {
    Name = "Application Subnet A"
  }
}
# Creating 2nd application subnet 
resource "aws_subnet" "application-subnet-b" {
  vpc_id                  = aws_vpc.ghostvpc.id
  cidr_block             = "${var.application_subnet_B_cidr}"
  map_public_ip_on_launch = false
  availability_zone = "${var.primary_region_azs[1]}"
tags = {
    Name = "Application Subnet B"
  }
}

# Creating internet Gateway
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.ghostvpc.id
}

# Creating Route table for public subnets
resource "aws_route_table" "public-route-table" {
    vpc_id = "${aws_vpc.ghostvpc.id}"
route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet-gateway.id
    }  
tags = {
        Name = "Public Route Table"
    }
}

# Associating Route Table to Public Subnet 1
resource "aws_route_table_association" "pbrt1" {
    subnet_id = aws_subnet.public-subnet-a.id
    route_table_id = "${aws_route_table.public-route-table.id}"
}

# Associating Route Table to Public Subnet 1
resource "aws_route_table_association" "pbrt2" {
    subnet_id = aws_subnet.public-subnet-b.id
    route_table_id = "${aws_route_table.public-route-table.id}"
}

resource "aws_eip" "elastic-ip-a" {
  vpc = true
}

resource "aws_eip" "elastic-ip-b" {
  vpc = true
}

resource "aws_nat_gateway" "public-nateway-a" {
  allocation_id = aws_eip.elastic-ip-a.id
  subnet_id     = aws_subnet.public-subnet-a.id

  tags = {
    Name = "NAT Gateway A"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.internet-gateway]
}

resource "aws_nat_gateway" "public-nateway-b" {
  allocation_id = aws_eip.elastic-ip-b.id
  subnet_id     = aws_subnet.public-subnet-b.id

  tags = {
    Name = "NAT Gateway B"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.internet-gateway]
}


# Creating Routes for App Subnet
resource "aws_route_table" "app-route-table-a" {
    vpc_id = "${aws_vpc.ghostvpc.id}"
route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.public-nateway-a.id
    }  
tags = {
        Name = "App Route Table A"
    }
}

resource "aws_route_table" "app-route-table-b" {
    vpc_id = "${aws_vpc.ghostvpc.id}"
route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.public-nateway-b.id
    }  
tags = {
        Name = "App Route Table B"
    }
}

# Associating App Route Table1 to App Subnet 1
resource "aws_route_table_association" "apprt1" {
    subnet_id = aws_subnet.application-subnet-a.id
    route_table_id = "${aws_route_table.app-route-table-a.id}"
}

# Associating Route Table2 to App Subnet 2
resource "aws_route_table_association" "apprt2" {
    subnet_id = aws_subnet.application-subnet-b.id
    route_table_id = "${aws_route_table.app-route-table-b.id}"
}