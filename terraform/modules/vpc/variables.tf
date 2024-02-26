variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["15.0.0.0/20", "15.0.16.0/20"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["15.0.128.0/20", "15.0.144.0/20"]
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "aws_nat_gateway" {
  type    = string
  default = "activesg-ng"
}