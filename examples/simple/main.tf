terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.3"
}

provider "cloudflare" {
}

data "cloudflare_zone" "this" {
  name = var.zone_name
}

module "parked_domain" {
  source = "../../"

  zone_id = data.cloudflare_zone.this.id
  ttl     = 86400 # One day
}
