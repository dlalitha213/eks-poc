
terraform {
  required_providers {
    kubernetes = { source = "hashicorp/kubernetes", version = ">= 2.0" }
  }
}

provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)
  token                  = var.cluster_token
}

resource "kubernetes_namespace" "frontend" {
  metadata { name = "frontend" }
}

resource "kubernetes_deployment" "frontend_app" {
  metadata {
    name = "frontend-deployment"
    namespace = kubernetes_namespace.frontend.metadata[0].name
  }
  spec {
    replicas = 2
    selector { match_labels = { app = "frontend" } }
    template {
      metadata { labels = { app = "frontend" } }
      spec {
        container {
          name  = "frontend"
          image = var.frontend_image
          port { container_port = 80 }
        }
      }
    }
  }
}

resource "kubernetes_service" "frontend_service" {
  metadata {
    name = "frontend-service"
    namespace = kubernetes_namespace.frontend.metadata[0].name
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" = "external"
    }
  }
  spec {
    selector = { app = "frontend" }
    port { port = 80, target_port = 80 }
    type = "LoadBalancer"
  }
}

output "frontend_service_hostname" {
  value = kubernetes_service.frontend_service.status[0].load_balancer[0].ingress[0].hostname
}
