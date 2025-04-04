resource "proxmox_vm_qemu" "template" {
  vmid        = 100
  name        = var.template_name
  desc        = "Ubuntu 22.04 LTS template for Terraform deployments"
  target_node = var.proxmox_node

  // Clone from the existing VM with ID 9000
  clone       = "ubuntu-2204-template"  // Directly reference the VM ID
  full_clone  = true

  // Basic VM configuration
  cores       = 2
  sockets     = 1
  memory      = 2048

  // Ensure it doesn't auto-start (it's meant to be a template)
  onboot      = false

  // Cloud-init settings
  ciuser      = "ubuntu"
  cipassword  = var.ci_password
  ipconfig0   = "ip=dhcp"
  sshkeys     = join("\n", var.ssh_keys)

  // Network interface
  network {
    model     = "virtio"
    bridge    = "vmbr0"
  }

  // Enable qemu-guest-agent
  agent       = 1

  // Prevent the VM from actually starting when created
  oncreate    = false
}

// Convert VM to template after creation
resource "null_resource" "convert_to_template" {
  depends_on = [proxmox_vm_qemu.template]

  // Give the VM creation time to complete before converting
  provisioner "local-exec" {
    command = "sleep 30 && ssh root@${var.proxmox_host} 'qm template ${proxmox_vm_qemu.template.vmid}'"
  }
}
