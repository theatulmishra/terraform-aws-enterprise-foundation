output "alb_dns_name" {
  description = "The DNS name of the Load Balancer."
  value       = module.foundation.alb_dns_name
}

output "vpc_id" {
  description = "The VPC ID."
  value       = module.foundation.vpc_id
}
