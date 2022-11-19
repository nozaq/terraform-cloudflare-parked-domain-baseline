terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 3.28"
    }
  }
  required_version = ">= 1.3"
}

# Null MX record specified in RFC 7505
# https://datatracker.ietf.org/doc/rfc7505/
resource "cloudflare_record" "mx_root" {
  zone_id  = var.zone_id
  type     = "MX"
  name     = "@"
  value    = "."
  priority = 0
  ttl      = var.ttl
}

resource "cloudflare_record" "mx_subdomains" {
  count = var.include_subdomains ? 1 : 0

  zone_id  = var.zone_id
  type     = "MX"
  name     = "*"
  value    = "."
  priority = 0
  ttl      = var.ttl
}

# Ensure all SPF validations to fail for the root domain.
resource "cloudflare_record" "spf_root" {
  zone_id = var.zone_id
  type    = "TXT"
  name    = "@"
  value   = "v=spf1 -all"
  ttl     = var.ttl
}

# Ensure all SPF validations to fail for subdomains.
resource "cloudflare_record" "spf_subdomains" {
  count = var.include_subdomains ? 1 : 0

  zone_id = var.zone_id
  type    = "TXT"
  name    = "*"
  value   = "v=spf1 -all"
  ttl     = var.ttl
}

# Advise receivers to reject emails when DMARC alignment fails.
resource "cloudflare_record" "dmarc" {
  zone_id = var.zone_id
  type    = "TXT"
  name    = "_dmarc"
  value   = var.aggregate_feedback_email != "" ? "v=DMARC1; p=reject; rua=${var.aggregate_feedback_email}" : "v=DMARC1; p=reject;"
  ttl     = var.ttl
}

