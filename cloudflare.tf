data "aws_secretsmanager_secret_version" "cloudflare_secret" {
  secret_id = "arn:aws:secretsmanager:us-east-1:153042419275:secret:cloudflare-ZlOXvE"
}

provider "cloudflare" {
  email = jsondecode(data.aws_secretsmanager_secret_version.cloudflare_secret.secret_string)["cloudflare_email"] // cloudflare email here
  api_key = jsondecode(data.aws_secretsmanager_secret_version.cloudflare_secret.secret_string)["cloudflare_key"] // api key here
}

output "username" {
  value = jsondecode(data.aws_secretsmanager_secret_version.cloudflare_secret.secret_string)["cloudflare_email"]
}

resource "cloudflare_record" "record" {
  zone_id = "eeae121d93d01bb9994aa24fd98b7389"
  name = var.environment
  value = module.load_balancer.myDNS //load balancer  dns
  type = "CNAME"
  proxied = false
  ttl = 1
}