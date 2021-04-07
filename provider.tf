terraform {
  required_version = ">= 0.13"
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  # UPDATE YOUR CONTEXT
  config_context = var.context
}

provider "helm" {
  version = "~> 1.3.2"
}
