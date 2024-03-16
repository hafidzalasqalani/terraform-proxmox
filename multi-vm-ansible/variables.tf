variable "proxmox_api_url" {
    type = string
}

variable "proxmox_api_token_id" {
    type = string
}

variable "proxmox_api_token_secret" {
    type = string
    sensitive = true
}

variable "ci_user" {
    type = string
}

variable "ci_password" {
    type = string
    sensitive = true
}

variable "ci_ssh_pub_key" {
    type = string
}

variable "ci_ssh_pri_key" {
    type = string
}

variable "vm_count" {
    type = number
    default = 3
}