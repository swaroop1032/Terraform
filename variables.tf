variable "pm_api_url" {
  description = "The URL for the Proxmox API (e.g., https://192.168.1.10:8006)"
  type        = string
}

variable "pm_api_token_id" {
  description = "The Proxmox API Token ID"
  type        = string
  sensitive   = true # Marks this as a secret
}

variable "pm_api_token_secret" {
  description = "The Proxmox API Token Secret"
  type        = string
  sensitive   = true # Marks this as a secret
}

variable "proxmox_node" {
  description = "The name of the Proxmox node to deploy to"
  type        = string
  default     = "pve" # Change this to your node name
}

variable "vm_template_name" {
  description = "The name of the VM template to clone"
  type        = string
  default     = "ubuntu-2204-cloudinit-template" # Change this to your template name
}

# variable "ssh_public_key" {
#   description = "Public SSH key for the cloud-init user"
#   type        = string
#   default     = "ssh-rsa AAAAB3NzaC1yc2EAAA..." # Paste your public key here
# }
