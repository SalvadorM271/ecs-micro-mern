provider "cloudflare" {
  email = "guardianes27@outlook.com"
  api_key = ""
}

resource "cloudflare_record" "record" {
  zone_id = ""
  name = var.environment
  value = module.load_balancer.myDNS //load balancer  dns
  type = "CNAME"
  proxied = false
  ttl = 1
}