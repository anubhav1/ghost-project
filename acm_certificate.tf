# resource "aws_acm_certificate" "cert" {
#   domain_name       = "*.pada.tk"
#   validation_method = "DNS"

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "time_sleep" "wait" {
#   depends_on = [aws_acm_certificate.cert]
#   create_duration = "60s"
# }
