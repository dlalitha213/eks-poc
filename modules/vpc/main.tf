
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  tags = { Name = "${var.name_prefix}-vpc" }
}

resource "aws_subnet" "public" {
  count = 2
  vpc_id = aws_vpc.this.id
  cidr_block = cidrsubnet(var.cidr_block, 8, count.index)
  availability_zone = element(var.azs, count.index)
  map_public_ip_on_launch = true
  tags = { Name = "${var.name_prefix}-public-${count.index}" }
}

resource "aws_subnet" "private" {
  count = 2
  vpc_id = aws_vpc.this.id
  cidr_block = cidrsubnet(var.cidr_block, 8, count.index + 10)
  availability_zone = element(var.azs, count.index)
  tags = { Name = "${var.name_prefix}-private-${count.index}" }
}

output "vpc_id" { value = aws_vpc.this.id }
output "public_subnet_ids" { value = aws_subnet.public[*].id }
output "private_subnet_ids" { value = aws_subnet.private[*].id }
