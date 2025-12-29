rgs = {
  rg1= {
    name     = "resource-group-1"
    location = "eastus"
  }
}

akss = {
  aks1 = {
    name                = "aks-cluster-1"
    location            = "eastus"
    resource_group_name = "resource-group-1"
    dns_prefix          = "aksdns1"
    default_node_pool = {
      name       = "nodepool1"
      node_count = 1
      vm_size    = "standard_dc2ads_v5"
    }
  }
}