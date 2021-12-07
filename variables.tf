variable "cloudflare_zone_name" {
  description = "Cloudflare zone name"
  type        = string
}

variable "firewall_inbound_rules" {
  description = "list of inbound firewalls to be created"
  type        = map(any)
  default = {
    http = {
      port_range       = "8080"
      protocol         = "tcp"
      source_addresses = ["0.0.0.0/0", "::/0"]
    }
  }
}

variable "firewall_outbound_rules" {
  description = "list of outbound firewalls to be created"
  type        = map(any)
  default = {
    icmp = {}
    tcp = {
      port_range = "all"
    }
    udp = {
      port_range = "all"
    }
  }
}

variable "os_image" {
  description = "Droplet base image name"
  type        = string
  default     = "ubuntu-20-04-x64"
}

variable "region" {
  description = "Droplet region"
  type        = string
  default     = "sfo3"
}

variable "size" {
  description = "Droplet size"
  type        = string
  default     = "s-1vcpu-1gb"
}

variable "tags" {
  description = "Droplet tags"
  type        = list(string)
  default     = ["quaky", "ssh"]
}

variable "ssh_add_pub_key" {
  description = "Create ssh key"
  type        = bool
  default     = false
}

variable "ssh_pub_key" {
  description = "SSH public key data"
  type        = string
  default     = null
}

variable "ssh_existing_key_ids" {
  description = "ID for existing ssh keys"
  type        = list(number)
  default     = [24072603]
}

variable "user_data" {
  description = "Droplet user data"
  type        = string
  default     = null
}
