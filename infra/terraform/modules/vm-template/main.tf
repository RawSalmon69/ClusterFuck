resource "proxmox_vm_qemu" "template" {
  name        = var.template_name
  desc        = "Ubuntu 22.04 LTS template for Terraform deployments"
  target_node = var.proxmox_node

  # Clone from your existing template
  clone       = "9000"  # or var.base_template if you've defined that variable
  full_clone  = true    # Use full clone for production VMs

  # Set to template
  provisioner "local-exec" {
    command = "sleep 15 && ssh root@${var.proxmox_host} 'qm set ${self.vmid} --boot c --bootdisk scsi0 && qm template ${self.vmid}'"
  }

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
