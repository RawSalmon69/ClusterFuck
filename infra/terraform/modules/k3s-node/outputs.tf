output "master_ips" {
  description = "IP addresses of K3s master nodes"
  value       = proxmox_vm_qemu.k3s_master.*.default_ipv4_address
}

output "worker_ips" {
  description = "IP addresses of K3s worker nodes"
  value       = proxmox_vm_qemu.k3s_worker.*.default_ipv4_address
}

output "kubeconfig_path" {
  description = "Path to the generated kubeconfig file"
  value       = "${path.module}/kubeconfig"
}

output "master_node_count" {
  description = "Number of master nodes created"
  value       = var.master_count
}

output "worker_node_count" {
  description = "Number of worker nodes created"
  value       = var.worker_count
}

output "k3s_version" {
  description = "Version of K3s installed"
  value       = var.k3s_version
}
