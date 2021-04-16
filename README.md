# helm-module-nv
Terraform Module - Helm Neuvector Deployment

## Versions

| Name | Version |
|------|---------|
| terraform | >= 0.13.0|
| terraform helm provider| ~> 1.3.2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| tag | neuvector version to deploy or update | `string` | `{}` | yes |
| helm_name | helm name deployment | `string` | `{}` | yes |
| ns | neuvector deployment namespace | `string` | `{}` | yes |
| webui_service | NodePort/LoadBalancer ... | `string` | `[]` | yes |
| containerd | Set to true, if the container runtime is containerd | `bool` | `[]` | no |
| containerd_path | If containerd is enabled, this local containerd socket path will be used /var/run/containerd/containerd.sock	 | 
| scanner_replicas | # replicas of scanners | `string` | `[]` | yes |
| controller_replicas | # replicas of controllers | `string` | `[]` | yes |
| registry_username | dockerhub username | `string` | `[]` | yes |
| registry_password  | dockerhub password | `string` | `[]` | yes |


### How to deploy

- Create the NV deployment file:

## Step 1: Export first your k8s context values:

```
# default path:  ~/.kube/config
# if you don't know your context, please check the context using this command:  ```kubectl config get-contexts```
export KUBE_CTX="context-name"
export KUBE_CONFIG_PATH="~/.kube/config"
```

## Step 2 Create and updatethe values in the file - nv-deployment.tf
```
module "nv-deployment" {
    source                  = "git::https://github.com/devseclabs/nv-deployment.git?ref=main"

    #see provider.tf - k8s context configured in ~/-kube/config
    context                 =   "context-name"

    # dockerhub by default
    registry_username   = "mi-registry-user"
    #registry_password   = ""
    #registry_server     = "registry-server"

    #config enable
    enable_config = true
    pass = "nvlabs123"

    #nv conf
    manager_svc_type = "LoadBalancer"
    scanner_replicas = 1
    controller_replicas = 3
    nv_version = "4.2.1"

    #license data
    license = "license.txt"
}
```
## Step 3: Init your conf and Apply
-  Deploy and Manage your deployment using terraform:
    - init your plugins  - ```terraform init```
    - plan your deployment - ```terraform plan```
    - apply the changes in your cluster ```terraform apply```

### Clean Up
- destroy your deployment: ```terraform destroy```
