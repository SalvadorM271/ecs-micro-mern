provider "cloudflare" {
  email = "" // cloudflare email here
  api_key = "" // api key here
}

resource "cloudflare_record" "record" {
  zone_id = "eeae121d93d01bb9994aa24fd98b7389"
  name = var.environment
  value = module.load_balancer.myDNS //load balancer  dns
  type = "CNAME"
  proxied = false
  ttl = 1
}