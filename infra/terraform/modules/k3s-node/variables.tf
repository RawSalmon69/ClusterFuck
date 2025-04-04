variable "cluster_name" {
  type        = string
  description = "Name of the K3s cluster"
  default     = "homelab"
}

variable "proxmox_node" {
  type        = string
  description = "The name of the Proxmox node"
  default     = "pve"
}

variable "proxmox_host" {
  type        = string
  description = "The hostname or IP of the Proxmox host for SSH commands"
}

variable "template_name" {
  type        = string
  description = "Name of the VM template to clone"
}

variable "storage_pool" {
  type        = string
  description = "Storage pool to use for VM disks"
  default     = "local-zfs"
}

variable "k3s_version" {
  type        = string
  description = "Version of K3s to install"
  default     = "v1.27.3+k3s1"
}

variable "master_count" {
  type        = number
  description = "Number of master nodes to create"
  default     = 1
}

variable "worker_count" {
  type        = number
  description = "Number of worker nodes to create"
  default     = 3
}

variable "master_cores" {
  type        = number
  description = "Number of CPU cores for master nodes"
  default     = 2
}

variable "master_memory" {
  type        = number
  description = "Amount of memory for master nodes (in MB)"
  default     = 2048
}

variable "master_disk_size" {
  type        = string
  description = "Disk size for master nodes"
  default     = "30G"
}

variable "worker_cores" {
  type        = number
  description = "Number of CPU cores for worker nodes"
  default     = 2
}

variable "worker_memory" {
  type        = number
  description = "Amount of memory for worker nodes (in MB)"
  default     = 2048
}

variable "worker_disk_size" {
  type        = string
  description = "Disk size for worker nodes"
  default     = "40G"
}

variable "k3s_network_cidr" {
  type        = string
  description = "Network CIDR for K3s cluster (first 3 octets)"
  default     = "10.20.20"
}

variable "k3s_network_gateway" {
  type        = string
  description = "Gateway for K3s network"
  default     = "10.20.20.1"
}

variable "ssh_keys" {
  type        = list(string)
  description = "List of SSH public keys to add to authorized_keys"
}

variable "ssh_private_key_path" {
  type        = string
  description = "Path to SSH private key for provisioning"
  sensitive   = true
}
