
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = ">= 19.0"
  cluster_name = var.cluster_name
  cluster_version = "1.30"
  vpc_id = var.vpc_id
  subnet_ids = var.subnet_ids
  manage_aws_auth = true

  fargate_profiles = {
    frontend = {
      name = "frontend"
      selectors = [
        { namespace = "frontend" }
      ]
    }
  }
}

output "cluster_endpoint" { value = module.eks.cluster_endpoint }
output "cluster_certificate_authority_data" { value = module.eks.cluster_certificate_authority_data }
