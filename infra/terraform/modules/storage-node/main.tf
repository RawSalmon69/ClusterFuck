# Storage node module - simplified based on working k3s module
resource "proxmox_vm_qemu" "storage_node" {
  count       = var.node_count
  name        = "${var.prefix}-storage-${count.index + 1}"
  desc        = "Storage node for ${var.prefix}"
  target_node = var.proxmox_node
  clone       = var.template_name

  # Hardware configuration
  cores       = var.cores
  sockets     = 1
  memory      = var.memory
  agent       = 1

  # Boot configuration - don't include here
  onboot      = true

  # Cloud-init settings
  ipconfig0   = "ip=${var.storage_network_cidr}.${var.ip_address_start + count.index}/24,gw=${var.storage_network_gateway}"
  ciuser      = "ubuntu"
  sshkeys     = join("\n", var.ssh_keys)

  # Network interfaces
  network {
    model     = "virtio"
    bridge    = "vmbr3"  # Storage network
  }

  network {
    model     = "virtio"
    bridge    = "vmbr0"  # Management network
  }

  # Important - run this BEFORE creating additional disks
  provisioner "local-exec" {
    command = "ssh root@${var.proxmox_host} 'qm set ${self.vmid} --boot c --bootdisk scsi0'"
  }

  # After boot config is set, add data disk
  provisioner "local-exec" {
    command = "ssh root@${var.proxmox_host} 'qm set ${self.vmid} --scsi1 ${var.data_disk_storage_pool}:${var.data_disk_size}'"
  }

  # Delay to ensure cloud-init completes before proceeding
  provisioner "remote-exec" {
    inline = ["echo 'Waiting for cloud-init to complete...'", "cloud-init status --wait > /dev/null"]
    connection {
      type        = "ssh"
      host        = "${var.storage_network_cidr}.${var.ip_address_start + count.index}"
      user        = "ubuntu"
      private_key = file(var.ssh_private_key_path)
    }
  }

  # Basic storage node setup
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nfs-kernel-server lvm2",
      "echo 'Storage node basic setup completed'",

      # Setup data disks (simplified)
      "sudo mkfs.ext4 /dev/sdb",
      "sudo mkdir -p /data/storage",
      "echo '/dev/sdb /data/storage ext4 defaults 0 2' | sudo tee -a /etc/fstab",
      "sudo mount -a",
      "sudo chmod 777 /data/storage",

      # Setup NFS exports
      "echo '/data/storage *(rw,sync,no_subtree_check,no_root_squash)' | sudo tee /etc/exports",
      "sudo exportfs -a",
      "sudo systemctl restart nfs-kernel-server"
    ]
    connection {
      type        = "ssh"
      host        = "${var.storage_network_cidr}.${var.ip_address_start + count.index}"
      user        = "ubuntu"
      private_key = file(var.ssh_private_key_path)
    }
  }
}
