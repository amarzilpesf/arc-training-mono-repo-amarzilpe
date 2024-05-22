variable "engine" {
  description = "Set the engine for rds instance"
  type        = list(string)
  default     = ["postgres", "mysql", "mariadb", ]
}

variable "engine_version" {
  description = "Choose appropriate engine version"
  type        = list(string)
  default     = ["16.1", "8.0", "10.11"]
}

variable "allocated_storage" {
  description = "Allocate Storage value"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Auto scaling max allocation storage"
  type        = number
  default     = 100
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "username" {
  description = "Master RDS username"
  type        = list(string)
  default     = ["postgres", "mysql", "mariadb"]
}
