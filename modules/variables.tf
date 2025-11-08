variable "pm_api_url" { type = string }
variable "pm_api_token_id" { type = string }
variable "pm_api_token_secret" { type = string, sensitive = true }

variable "vm_name" { type = string, default = "tf-vm-01" }
variable "node"    { type = string, default = "pve" }
variable "clone_template" { type = string, default = "debian-cloudinit-template" }

variable "cores" { type = number, default = 2 }
variable "memory" { type = number, default = 2048 }
variable "disk_size" { type = string, default = "10G" }
variable "net_bridge" { type = string, default = "vmbr0" }
