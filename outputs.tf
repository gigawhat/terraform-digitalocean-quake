output "droplet_ip" {
  value = digitalocean_droplet.this.ipv4_address
}

output "quake_url" {
  value = "http://${cloudflare_record.this.hostname}:8080"
}
