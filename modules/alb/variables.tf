
variable "vpc_id" {}
variable "subnet_ids" { type = list(string) }
variable "name" { default = "alb" }
