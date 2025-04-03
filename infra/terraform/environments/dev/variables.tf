# Variables for dev environment

variable "proxmox_api_url" {
  type        = string
  description = "The URL of the Proxmox API"
  sensitive   = true
}

variable "proxmox_api_token_id" {
  type        = string
  description = "The token ID for Proxmox API authentication"
  sensitive   = true
}

variable "proxmox_api_token_secret" {
  type        = string
  description = "The token secret for Proxmox API authentication"
  sensitive   = true
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
  description = "Name of the VM template"
  default     = "ubuntu-2204-template"
}

variable "base_template" {
  type        = string
  description = "Base image to clone from (VM ID or name)"
  default     = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
}

variable "storage_pool" {
  type        = string
  description = "Storage pool to use for VM disks"
  default     = "local-zfs"
}

variable "ci_password" {
  type        = string
  description = "Password for the default cloud-init user"
  sensitive   = true
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
