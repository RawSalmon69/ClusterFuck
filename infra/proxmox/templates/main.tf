resource "proxmox_vm_qemu" "template" {
  name        = var.template_name
  desc        = "Ubuntu 22.04 LTS template for Terraform deployments"
  target_node = var.proxmox_node
  clone       = var.base_template
  full_clone  = true

  # VM settings
  cores       = 2
  sockets     = 1
  memory      = 2048
  onboot      = false

  # Set to template
  template    = true

  # Cloud-init settings
  ciuser      = "ubuntu"
  cipassword  = var.ci_password
  ipconfig0   = "ip=dhcp"
  sshkeys     = join("\n", var.ssh_keys)

  # Disks
  disk {
    type      = "scsi"
    storage   = var.storage_pool
    size      = "20G"
    backup    = true
  }

  # Network interfaces
  network {
    model     = "virtio"
    bridge    = "vmbr0"  # Management network
  }

  # Ensure cloud-init is properly regenerated
  provisioner "local-exec" {
    command = "sleep 15 && ssh root@${var.proxmox_host} qm set ${self.vmid} --boot c --bootdisk scsi0"
  }
}
