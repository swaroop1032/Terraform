variable "name"        { type = string }
variable "node"        { type = string }
variable "clone_template" { type = string }

variable "cores"       { type = number  ; default = 2 }
variable "sockets"     { type = number  ; default = 1 }
variable "memory"      { type = number  ; default = 2048 }
variable "scsihw"      { type = string  ; default = "virtio-scsi-pci" }

variable "disk_size"   { type = string  ; default = "10G" }
variable "disk_storage"{ type = string  ; default = "local-lvm" }
variable "disk_type"   { type = string  ; default = "scsi" }

variable "net_model"   { type = string  ; default = "virtio" }
variable "net_bridge"  { type = string  ; default = "vmbr0" }

variable "os_type"     { type = string  ; default = "cloud-init" }
variable "ipconfig0"   { type = string  ; default = "ip=dhcp" }
variable "onboot"      { type = bool    ; default = true }
