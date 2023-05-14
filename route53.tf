resource "aws_route53_record" "t4" {
  zone_id = "${var.route53_zone_id}"
  name    = "${var.route53_record_name}"
  type    = "A"
  alias {
    name                   = aws_lb.external-ghost-alb.dns_name
    zone_id                = aws_lb.external-ghost-alb.zone_id
    evaluate_target_health = true
  }
}