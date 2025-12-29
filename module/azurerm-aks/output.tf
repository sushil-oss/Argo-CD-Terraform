output "kube_config" {
  description = "Kubeconfig for all AKS clusters"
  sensitive   = true

  value = {
    for k, v in azurerm_kubernetes_cluster.aks1 :
    k => v.kube_config_raw
  }
}

output "client_certificate" {
  description = "Client certificates for all AKS clusters"
  sensitive   = true

  value = {
    for k, v in azurerm_kubernetes_cluster.aks1 :
    k => v.kube_config[0].client_certificate
  }
}
