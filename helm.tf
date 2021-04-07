#NAMESPACE CONF
resource "kubernetes_namespace" "nv-ns" {
  metadata {
    
    labels = {
      mylabel = "neuvector"
    }

    name = var.ns
  }
}

#SECRET DOCKERHUB CONF
resource "kubernetes_secret" "dockerhub" {
  metadata {
    name = "docker-cfg"
    namespace = var.ns
  }

  data = {
    ".dockerconfigjson" = <<DOCKER
{
  "auths": {
    "${var.registry_server}": {
      "auth": "${base64encode("${var.registry_username}:${var.registry_password}")}"
    }
  }
}
DOCKER
  }

  type = "kubernetes.io/dockerconfigjson"
  depends_on = [kubernetes_namespace.nv-ns]
}

#HELM RELEASE CONF
resource "helm_release" "nv-helm" {
 name       = var.helm_name
 namespace  =  var.ns
 repository = var.helm_repo
 chart      = var.helm_chart

   set {
     name  = "imagePullSecrets"
     value = var.secret_name
   }
   set {
     name  = "cve.scanner.replicas"
     value = var.scanner_replicas
   }
   set {
     name  = "controller.replicas"
     value = var.controller_replicas
   }
   
    set {
      name = "manager.svc.type"
      value = var.webui_service
    }

   set {
     name  = "tag"
     value = var.tag
   }

   set {
     name  = "containerd.enabled"
     value = var.containerd
   }

   set {
     name  = "containerd.path"
     value = var.containerd_path
   }

    set {
     name  = "controller.configmap.enabled"
     value = var.configmap
   }

    dynamic "set" {
    for_each = var.configmap == "true" ? 1 : 0
    content {
      name  = "controller.configmap.data"
      value = file(var.config_data)
    }
  }
  #   set {
  #    count = var.configmap == "true" ? 1 : 0
  #    name  = "controller.configmap.data"
  #    value = file(var.config_data)
  #  }

    set {
     name  = "controller.pvc.enabled"
     value = var.pvc_conf
   }
   
   

   depends_on = [kubernetes_secret.dockerhub]
}