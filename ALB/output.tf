output "elb_dns" {
  description = "DNS name of the load balancer"
  value       = aws_lb.web_server.dns_name
}
