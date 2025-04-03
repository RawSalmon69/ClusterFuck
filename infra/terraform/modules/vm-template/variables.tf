variable "template_name" {
  type        = string
  description = "Name of the VM template"
  default     = "ubuntu-2204-template"
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

variable "base_template" {
  type        = string
  description = "Base image to clone from (VM ID or name)"
}

variable "storage_pool" {
  type        = string
  description = "Storage pool to use for VM disk"
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
  default     = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILVH5G15RJeidUE0Q54Tib+BFSzyFLdKkJF7t9yFAvFl phanthawasjira@gmail.com"]
}
