variable "pm_api_url" {
  description = "The URL for the Proxmox API"
  type        = string
}

variable "pm_api_token_id" {
  description = "The Proxmox API Token ID"
  type        = string
  sensitive   = true
}

variable "pm_api_token_secret" {
  description = "The Proxmox API Token Secret"
  type        = string
  sensitive   = true
}

variable "proxmox_node" {
  description = "The name of the Proxmox node to deploy to"
  type        = string
  default     = "pve"
}

variable "vm_template_name" {
  description = "The name of the VM template to clone"
  type        = string
  default     = "ubuntu-2204-cloudinit-template" # Change this to your template name
}
