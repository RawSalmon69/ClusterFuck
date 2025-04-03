locals {
  network_config = {
    master = {
      ip_address = "${var.k3s_network_cidr}.10"
      net_bridge = "vmbr1"  # Kubernetes network
    }
    worker = {
      ip_address_start = 20  # Worker IPs will start at .20, .21, etc.
      net_bridge = "vmbr1"  # Kubernetes network
    }
  }
}

# Create master node
resource "proxmox_vm_qemu" "k3s_master" {
  count       = var.master_count
  name        = "${var.cluster_name}-master-${count.index + 1}"
  desc        = "K3s master node for ${var.cluster_name}"
  target_node = var.proxmox_node
  clone       = var.template_name

  # Hardware configuration
  cores       = var.master_cores
  sockets     = 1
  memory      = var.master_memory
  agent       = 1

  # Boot configuration
  onboot      = true

  # Cloud-init settings
  ipconfig0   = "ip=${local.network_config.master.ip_address}/24,gw=${var.k3s_network_gateway}"
  ciuser      = "ubuntu"
  sshkeys     = join("\n", var.ssh_keys)

  # Network configuration
  network {
    model     = "virtio"
    bridge    = local.network_config.master.net_bridge
  }

  # Storage configuration for application data
  disk {
    type      = "scsi"
    storage   = var.storage_pool
    size      = var.master_disk_size
    backup    = true
  }

  # Delay to ensure cloud-init completes before proceeding
  provisioner "remote-exec" {
    inline = ["echo 'Waiting for cloud-init to complete...'", "cloud-init status --wait > /dev/null"]

    connection {
      type        = "ssh"
      host        = local.network_config.master.ip_address
      user        = "ubuntu"
      private_key = file(var.ssh_private_key_path)
    }
  }

  # Install K3s server
  provisioner "remote-exec" {
    inline = [
      "curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=${var.k3s_version} sh -s - server --disable traefik --disable servicelb --flannel-backend=none --write-kubeconfig-mode=644",
      "sudo cat /var/lib/rancher/k3s/server/node-token > /tmp/node-token",
      "sudo chmod 644 /tmp/node-token",
      "echo 'K3s master node installed successfully'"
    ]

    connection {
      type        = "ssh"
      host        = local.network_config.master.ip_address
      user        = "ubuntu"
      private_key = file(var.ssh_private_key_path)
    }
  }

  # Copy kubeconfig locally for management
  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -i ${var.ssh_private_key_path} ubuntu@${local.network_config.master.ip_address}:/etc/rancher/k3s/k3s.yaml ${path.module}/kubeconfig && sed -i 's/127.0.0.1/${local.network_config.master.ip_address}/g' ${path.module}/kubeconfig"
  }

  # Fetch node token for workers
  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -i ${var.ssh_private_key_path} ubuntu@${local.network_config.master.ip_address}:/tmp/node-token ${path.module}/node-token"
  }
}

# Create worker nodes
resource "proxmox_vm_qemu" "k3s_worker" {
  count       = var.worker_count
  name        = "${var.cluster_name}-worker-${count.index + 1}"
  desc        = "K3s worker node for ${var.cluster_name}"
  target_node = var.proxmox_node
  clone       = var.template_name

  # Hardware configuration
  cores       = var.worker_cores
  sockets     = 1
  memory      = var.worker_memory
  agent       = 1

  # Boot configuration
  onboot      = true

  # Cloud-init settings
  ipconfig0   = "ip=${var.k3s_network_cidr}.${local.network_config.worker.ip_address_start + count.index}/24,gw=${var.k3s_network_gateway}"
  ciuser      = "ubuntu"
  sshkeys     = join("\n", var.ssh_keys)

  # Network configuration
  network {
    model     = "virtio"
    bridge    = local.network_config.worker.net_bridge
  }

  # Additional network interface for application traffic
  network {
    model     = "virtio"
    bridge    = "vmbr2"  # Application network
  }

  # Storage configuration
  disk {
    type      = "scsi"
    storage   = var.storage_pool
    size      = var.worker_disk_size
    backup    = true
  }

  # Delays to wait for master node to be ready
  depends_on = [proxmox_vm_qemu.k3s_master]

  # Delay to ensure cloud-init completes before proceeding
  provisioner "remote-exec" {
    inline = ["echo 'Waiting for cloud-init to complete...'", "cloud-init status --wait > /dev/null"]

    connection {
      type        = "ssh"
      host        = "${var.k3s_network_cidr}.${local.network_config.worker.ip_address_start + count.index}"
      user        = "ubuntu"
      private_key = file(var.ssh_private_key_path)
    }
  }

  # Install K3s agent
  provisioner "remote-exec" {
    inline = [
      "curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=${var.k3s_version} K3S_URL=https://${local.network_config.master.ip_address}:6443 K3S_TOKEN=$(cat ${path.module}/node-token) sh -",
      "echo 'K3s worker node installed successfully'"
    ]

    connection {
      type        = "ssh"
      host        = "${var.k3s_network_cidr}.${local.network_config.worker.ip_address_start + count.index}"
      user        = "ubuntu"
      private_key = file(var.ssh_private_key_path)
    }
  }
}
