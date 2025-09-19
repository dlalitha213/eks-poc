
variable "region" {
  default = "ap-south-1"
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "cluster_name" {
  default = "frontend-eks"
}
variable "github_oidc_role_name" {
  default = "github-oidc-role"
}
