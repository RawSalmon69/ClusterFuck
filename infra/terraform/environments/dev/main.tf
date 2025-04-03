# Dev environment configuration for homelab
# This creates minimal resources for dev/testing

# Import common provider configuration
provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure     = true
}

# Create the Ubuntu VM template (if it doesn't exist)
module "vm_template" {
  source = "../../modules/vm-template"

  template_name       = var.template_name
  proxmox_node        = "proxmox"
  proxmox_host        = var.proxmox_host
  base_template       = var.base_template
  storage_pool        = var.storage_pool
  ci_password         = var.ci_password
  ssh_keys            = var.ssh_keys
}

# Create minimal K3s cluster for development
module "k3s_cluster" {
  source = "../../modules/k3s-node"

  cluster_name        = "dev"
  proxmox_node        = var.proxmox_node
  template_name       = module.vm_template.template_name
  storage_pool        = var.storage_pool

  # Dev environment only needs minimal cluster
  master_count        = 1
  worker_count        = 1

  # Reduced specs for dev environment
  master_cores        = 2
  master_memory       = 4096
  master_disk_size    = "30G"

  worker_cores        = 2
  worker_memory       = 4096
  worker_disk_size    = "40G"

  # Network configuration
  k3s_network_cidr    = var.k3s_network_cidr
  k3s_network_gateway = var.k3s_network_gateway

  # SSH configuration
  ssh_keys            = var.ssh_keys
  ssh_private_key_path = var.ssh_private_key_path

  # Make sure template exists before creating cluster
  depends_on = [module.vm_template]
}

# For dev environment, we'll use a minimal storage setup
module "storage" {
  source = "../../modules/storage-node"

  prefix                  = "dev"
  proxmox_node            = var.proxmox_node
  template_name           = module.vm_template.template_name

  # Only one storage node for dev
  node_count              = 1

  # Reduced specs for dev environment
  cores                   = 1
  memory                  = 2048
  system_disk_size        = "20G"

  # Just one data disk for dev
  data_disk_count         = 1
  data_disk_size          = "50G"

  # Network configuration
  storage_network_cidr    = var.storage_network_cidr
  storage_network_gateway = var.storage_network_gateway

  # SSH configuration
  ssh_keys                = var.ssh_keys
  ssh_private_key_path    = var.ssh_private_key_path

  # Make sure template exists before creating storage nodes
  depends_on = [module.vm_template]
}
