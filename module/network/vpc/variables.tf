variable "region" {
  description = "Select region for services deployment."
  type        = string
  default     = ""
}

variable "profile" {
  description = "Select profile to use."
  type        = string
  default     = ""
}

variable "vpc_name" {
  description = "Give vpc name"
  type        = string
  default     = "main"
}

variable "cidr_block" {
  description = "cide block range"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Provides an public subnet resource"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr" {
  description = "Provides an private subnet resource"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-1a", "us-east-1b"]
}