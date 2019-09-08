#Create self-sign cert

resource "tls_private_key" "ca_key" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "ca_crt" {
  key_algorithm   = "RSA"
  private_key_pem = "${tls_private_key.ca_key.private_key_pem}"

  subject {
    common_name  = "cms-kata.com"
    organization = "XPeppers"
  }

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "cert" {
  private_key      = "${tls_private_key.ca_key.private_key_pem}"
  certificate_body = "${tls_self_signed_cert.ca_crt.cert_pem}"
}