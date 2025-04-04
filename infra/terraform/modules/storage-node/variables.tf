variable "prefix" {
  type        = string
  description = "Prefix to use for storage node names"
  default     = "homelab"
}

variable "proxmox_host" {
  type        = string
  description = "The hostname or IP of the Proxmox host for SSH commands"
}

variable "proxmox_node" {
  type        = string
  description = "The name of the Proxmox node"
  default     = "pve"
}

variable "template_name" {
  type        = string
  description = "Name of the VM template to clone"
}

variable "node_count" {
  type        = number
  description = "Number of storage nodes to create"
  default     = 1
}

variable "cores" {
  type        = number
  description = "Number of CPU cores for storage nodes"
  default     = 2
}

variable "memory" {
  type        = number
  description = "Amount of memory for storage nodes (in MB)"
  default     = 1024
}

variable "system_disk_storage_pool" {
  type        = string
  description = "Storage pool to use for system disks"
  default     = "local-zfs"
}

variable "system_disk_size" {
  type        = string
  description = "Size of system disk"
  default     = "20G"
}

variable "data_disk_storage_pool" {
  type        = string
  description = "Storage pool to use for data disks"
  default     = "local-zfs"
}

variable "data_disk_size" {
  type        = string
  description = "Size of each data disk"
  default     = "100G"
}

variable "data_disk_count" {
  type        = number
  description = "Number of data disks to create per node"
  default     = 1
}

variable "storage_network_cidr" {
  type        = string
  description = "Network CIDR for storage network (first 3 octets)"
  default     = "10.40.40"
}

variable "storage_network_gateway" {
  type        = string
  description = "Gateway for storage network"
  default     = "10.40.40.1"
}

variable "ip_address_start" {
  type        = number
  description = "Starting IP address (last octet) for storage nodes"
  default     = 10
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
