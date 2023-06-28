data "aws_secretsmanager_secret_version" "cloudflare_secret" {
  secret_id = "arn:aws:secretsmanager:us-east-1:438555236323:secret:cloudflare-8ACs61"
}

provider "cloudflare" {
  email = jsondecode(data.aws_secretsmanager_secret_version.cloudflare_secret.secret_string)["cloudflare_email"] // cloudflare email here
  api_key = jsondecode(data.aws_secretsmanager_secret_version.cloudflare_secret.secret_string)["cloudflare_key"] // api key here
}

# output "username" {
#   value = jsondecode(data.aws_secretsmanager_secret_version.cloudflare_secret.secret_string)["cloudflare_email"]
#   sensitive = true
# }

resource "cloudflare_record" "record" {
  zone_id = jsondecode(data.aws_secretsmanager_secret_version.cloudflare_secret.secret_string)["zone_id"] // zone id key here
  name = var.environment
  value = module.load_balancer.myDNS //load balancer  dns
  type = "CNAME"
  proxied = false
  ttl = 1
}