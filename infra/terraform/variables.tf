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

# Common variables for all environments
variable "proxmox_node" {
  type        = string
  description = "The name of the Proxmox node"
  default     = "pve"
}

variable "template_name" {
  type        = string
  description = "Name of the VM template to use as base image"
  default     = "ubuntu-2204-template"
}

variable "ssh_keys" {
  type        = list(string)
  description = "List of SSH public keys to add to authorized_keys"
  default     = []
}

variable "default_gateway" {
  type        = string
  description = "Default gateway IP address"
  default     = "192.168.1.1"
}
