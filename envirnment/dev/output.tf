output "aks_kube_config" {
  value     = module.aks-clusters.kube_config
  sensitive = true
}

output "aks_client_certificate" {
  value     = module.aks-clusters.client_certificate
  sensitive = true
}
