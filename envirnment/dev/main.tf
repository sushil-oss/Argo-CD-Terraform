module "resource-groups" {
  source = "../../module/resource-group"
  rgs    = var.rgs
}

module "aks-clusters" {
  depends_on = [ module.resource-groups ]
  source     = "../../module/azurerm-aks"
  akss       = var.akss
}

