resource "azurerm_resource_group" "resource_group" {
  name     = "resource-group-1"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "kuberentes_cluster" {
  name                = "example-aks1"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}


provider kubernetes {
  alias = "kubernetes_cluster"

  load_config_file       = "false"
  host                   = azurerm_kubernetes_cluster.kuberentes_cluster.kube_admin_config.0.host
  username               = azurerm_kubernetes_cluster.kuberentes_cluster.kube_admin_config.0.username
  password               = azurerm_kubernetes_cluster.kuberentes_cluster.kube_admin_config.0.password
  client_certificate     = base64decode(azurerm_kubernetes_cluster.kuberentes_cluster.kube_admin_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.kuberentes_cluster.kube_admin_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.kuberentes_cluster.kube_admin_config.0.cluster_ca_certificate)
}

resource "kubernetes_namespace" "application_1" {
  provider = kubernetes.kubernetes_cluster

  metadata {
    name = "application-1"
  }
}

resource "null_resource" "test_resource" {}
