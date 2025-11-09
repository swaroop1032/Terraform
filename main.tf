# 1. Configure the required Proxmox provider
terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}

# 2. Configure the provider credentials.
# We will pass these in as environment variables from Jenkins.
provider "proxmox" {
  pm_api_url         = var.pm_api_url
  pm_api_token_id    = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure    = true # Set to false if you have a valid SSL cert
}

# 3. Define the Virtual Machine resource
resource "proxmox_vm_qemu" "vm_from_jenkins" {
  # --- General Settings ---
  name        = "vm-jenkins-01"
  desc        = "Managed by Terraform and Jenkins"
  target_node = var.proxmox_node # The PVE node to build on (e.g., "pve")

  # --- Template and Boot ---
  clone = var.vm_template_name # The template you made in Part 1
  os_type = "cloud-init"

  # --- Resources ---
  cores   = 2
  sockets = 1
  memory  = 2048 # 2GB

  # --- Network ---
  network {
    model  = "virtio"
    bridge = "vmbr0" # Your primary Proxmox bridge
  }

  # --- Cloud-Init Settings ---
  # This sets the IP to DHCP.
  ipconfig0 = "ip=dhcp"

  # You can also set a static IP like this:
  # ipconfig0 = "ip=192.168.1.100/24,gw=192.168.1.1"

  # Optional: Set a user and SSH key (highly recommended)
  # sshkeys = var.ssh_public_key
  # ciuser  = "ubuntu"
}
