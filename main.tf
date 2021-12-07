data "cloudflare_zones" "this" {
  filter {
    name = var.cloudflare_zone_name
  }
}

locals {
  droplet_ssh_keys  = var.ssh_add_pub_key ? [digitalocean_ssh_key.this[0].fingerprint] : var.ssh_existing_key_ids
  droplet_user_data = coalesce(var.user_data, file("${path.module}/files/user-data.yaml"))
}

resource "random_pet" "this" {}

resource "digitalocean_firewall" "this" {
  name        = random_pet.this.id
  droplet_ids = [digitalocean_droplet.this.id]
  dynamic "inbound_rule" {
    for_each = var.firewall_inbound_rules
    content {
      protocol         = inbound_rule.value["protocol"]
      port_range       = inbound_rule.value["port_range"]
      source_addresses = inbound_rule.value["source_addresses"]
    }
  }

  dynamic "outbound_rule" {
    for_each = var.firewall_outbound_rules
    content {
      protocol              = outbound_rule.key
      port_range            = try(outbound_rule.value["port_range"], null)
      destination_addresses = try(outbound_rule.value["destination_addresses"], ["0.0.0.0/0", "::/0"])
    }
  }
}

resource "digitalocean_ssh_key" "this" {
  count      = var.ssh_add_pub_key ? 1 : 0
  name       = random_pet.this.id
  public_key = var.ssh_pub_key
}

resource "digitalocean_droplet" "this" {
  image     = var.os_image
  name      = random_pet.this.id
  region    = var.region
  size      = var.size
  tags      = var.tags
  ssh_keys  = local.droplet_ssh_keys
  user_data = local.droplet_user_data
}

resource "cloudflare_record" "this" {
  zone_id = lookup(data.cloudflare_zones.this.zones[0], "id")
  name    = random_pet.this.id
  value   = digitalocean_droplet.this.ipv4_address
  type    = "A"
  proxied = false
  ttl     = 60
}
