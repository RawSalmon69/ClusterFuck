output "storage_node_ips" {
  description = "IP addresses of storage nodes"
  value       = proxmox_vm_qemu.storage_node.*.default_ipv4_address
}

output "node_count" {
  description = "Number of storage nodes created"
  value       = var.node_count
}

output "nfs_export_path" {
  description = "NFS export path on storage nodes"
  value       = "/data/storage"
}

output "total_storage_capacity" {
  description = "Total raw storage capacity per node"
  value       = "${var.data_disk_count} x ${var.data_disk_size} per node"
}
