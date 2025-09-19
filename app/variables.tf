
variable "cluster_endpoint" {}
variable "cluster_certificate_authority_data" {}
variable "cluster_token" {}
variable "frontend_image" {
  description = "ECR image URI for frontend (set via TF_VAR_frontend_image in CI)"
  default = ""
}
