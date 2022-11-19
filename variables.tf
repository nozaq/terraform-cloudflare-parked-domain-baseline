variable "zone_id" {
  description = "The DNS zone ID to add the records to. Either zone_name or zone_id need to be given."
  type        = string
}

variable "ttl" {
  description = "The TTL of the DNS records."
  type        = number
  default     = 1
}

variable "aggregate_feedback_email" {
  description = "The email address to which aggregate feedback is to be sent."
  type        = string
  default     = ""
}

variable "include_subdomains" {
  description = "Configure all subdomains as well as the root domain."
  type        = bool
  default     = true
}
