## network
data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["arc-poc-vpc"]
  }
}

data "aws_subnets" "private" {
  filter {
    name = "tag:Name"

    values = [
      "arc-demo-Dev-private-subnet-private-ap-south-1a",
      "arc-demo-Dev-private-subnet-private-ap-south-1b",
    ]
  }
}
