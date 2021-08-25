resource "azurerm_log_analytics_workspace" "kubernetes" {
  name                = "Kubernetes-${var.clmi_cluster_name}-Logs"
  location            = azurerm_resource_group.cluster-rg.location
  resource_group_name = azurerm_resource_group.cluster-rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  internet_ingestion_enabled = false
  internet_query_enabled = false
}



resource "azurerm_log_analytics_workspace" "audit" {
  name                = "Audit"
  resource_group_name = azurerm_resource_group.cluster-rg.name
  location            = azurerm_resource_group.cluster-rg.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
  internet_ingestion_enabled = false
  internet_query_enabled = false
}
