terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc1"
    }
  }
}

provider "proxmox" {
  # Configuration options
  pm_api_url = var.proxmox_api_url
  pm_api_token_id = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "vm" {
  count = var.vm_count
  vmid = 500 + (count.index+1)
  name = "prod-${count.index+1}"
  target_node = "pve"

  clone = "ubuntu-jam"
  full_clone = true

  os_type = "cloud-init"
  cloudinit_cdrom_storage = "local-lvm"

  ciuser = var.ci_user
  cipassword = var.ci_password
  sshkeys = file(var.ci_ssh_pub_key)

  cores = 1
  memory = 1024
  agent = 1

  bootdisk = "scsi0"
  scsihw = "virtio-scsi-pci"
  ipconfig0 = "ip=dhcp"

  disks {
    scsi {
      scsi0 {
        disk {
          size = 10
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    model = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [ 
      network
     ]
  }
}

resource "null_resource" "ansible" {
  provisioner "local-exec" {
    
  }
}

output "info" {
  value = [
    for vm in proxmox_vm_qemu.vm:{
      hostname = vm.name
      ip-addr = vm.default_ipv4_address
    }
  ]
}