output "template_id" {
  description = "The ID of the created template"
  value       = proxmox_vm_qemu.template.id
}

output "template_name" {
  description = "The name of the created template"
  value       = proxmox_vm_qemu.template.name
}

output "vmid" {
  description = "The VMID of the created template"
  value       = proxmox_vm_qemu.template.vmid
}
