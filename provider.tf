terraform {
  #required_version = ">= 0.13"
}

# provider "kubernetes" {
#   config_path    = var.kube_path
#   config_context = var.kube_context
# }

provider "helm" {
  #version = "~> 1.3.2"
  kubernetes {
    config_path = var.kube_path
    config_context = var.kube_context
  }
}

