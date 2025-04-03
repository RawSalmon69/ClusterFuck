resource "proxmox_vm_qemu" "template" {
  name        = var.template_name
  desc        = "Ubuntu 22.04 LTS template for Terraform deployments"
  target_node = var.proxmox_node

  # Clone from your existing template
  clone       = "ubuntu-2204-template"  # or var.base_template
  full_clone  = true

  # Template settings
  cores       = 2
  sockets     = 1
  memory      = 2048
  onboot      = false  # Templates shouldn't auto-start

  # Cloud-init settings
  ciuser      = "ubuntu"
  cipassword  = var.ci_password
  ipconfig0   = "ip=dhcp"
  sshkeys     = join("\n", var.ssh_keys)

  # Network interfaces
  network {
    model     = "virtio"
    bridge    = "vmbr0"
  }
}

# Convert the VM to a template after creation
resource "null_resource" "convert_to_template" {
  depends_on = [proxmox_vm_qemu.template]

  provisioner "local-exec" {
    command = "sleep 30 && ssh root@${var.proxmox_host} 'qm template ${proxmox_vm_qemu.template.vmid}'"
  }
}
