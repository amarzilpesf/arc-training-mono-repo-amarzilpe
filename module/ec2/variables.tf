variable "instance_type" {
  description = "Choose instance type"
  type        = string
  default     = "t3.medium"
}

variable "ssh_key" {
  type    = string
  default = null
}

variable "path" {
  type    = string
  default = "~/Documents/"
}

variable "volume_type" {
  type    = string
  default = "gp3"
}
variable "volume_size" {
  type    = number
  default = 8
}

variable "encrypted" {
  type    = bool
  default = true
}
variable "delete_on_termination" {
  type    = bool
  default = true
}

variable "ingress_rules" {
  description = "A map of ingress rules"
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {
    ssh = {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  }
}

variable "egress_rules" {
  description = "A map of egress rules"
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {
    all_traffic = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

  }
}
