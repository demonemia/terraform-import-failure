resource "azurerm_resource_group" "resource_group" {
  name     = "resource-group-1"
  location = "East US"
}

# For simplicity, using a data source instead of spelling out the resource
data "azurerm_kubernetes_cluster" "kuberentes_cluster" {
  name                = "development-kube"
  resource_group_name = azurerm_resource_group.resource_group.name
}

provider kubernetes {
  alias = "kubernetes_cluster"

  load_config_file       = "false"
  host                   = data.azurerm_kubernetes_cluster.kuberentes_cluster.kube_admin_config.0.host
  username               = data.azurerm_kubernetes_cluster.kuberentes_cluster.kube_admin_config.0.username
  password               = data.azurerm_kubernetes_cluster.kuberentes_cluster.kube_admin_config.0.password
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.kuberentes_cluster.kube_admin_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.kuberentes_cluster.kube_admin_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.kuberentes_cluster.kube_admin_config.0.cluster_ca_certificate)
}

resource "kubernetes_namespace" "application_1" {
  provider = kubernetes.kubernetes_cluster

  metadata {
    name = "application-1"
  }
}
