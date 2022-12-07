provider "cloudflare" {
  email = "guardianes27@outlook.com"
  api_key = "0ae534a099ed0c187855f882a27f9aa3470ea"
}

resource "cloudflare_record" "record" {
  zone_id = "eeae121d93d01bb9994aa24fd98b7389"
  name = var.environment
  value = module.load_balancer.myDNS //load balancer  dns
  type = "CNAME"
  proxied = false
  ttl = 1
}