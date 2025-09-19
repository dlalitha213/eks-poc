
variable "cidr_block" { default = "10.0.0.0/16" }
variable "name_prefix" { default = "eks" }
variable "azs" {
  type = list(string)
  default = ["ap-south-1a", "ap-south-1b"]
}
