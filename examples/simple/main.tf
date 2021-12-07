terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.4.0"
    }
  }
}

provider "digitalocean" {}

provider "random" {}

provider "cloudflare" {}

module "simple" {
  source               = "../../"
  cloudflare_zone_name = "keife.org"
}

output "url" {
  value = module.simple.quake_url
}

output "droplet_ip" {
  value = module.simple.droplet_ip
}
