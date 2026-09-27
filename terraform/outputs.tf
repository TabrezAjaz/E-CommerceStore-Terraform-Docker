output "frontend_url" {
  description = "Public URL of the e-commerce frontend."
  value       = "http://${aws_instance.application.public_ip}"
}

output "public_ip" {
  description = "Public IPv4 address of the EC2 container host."
  value       = aws_instance.application.public_ip
}

output "public_dns" {
  description = "Public DNS name of the EC2 container host."
  value       = aws_instance.application.public_dns
}

output "service_health_urls" {
  description = "Backend health endpoints exposed only through the frontend gateway."
  value = {
    user     = "http://${aws_instance.application.public_ip}/user/health"
    product  = "http://${aws_instance.application.public_ip}/product/health"
    cart     = "http://${aws_instance.application.public_ip}/cart/health"
    order    = "http://${aws_instance.application.public_ip}/order/health"
    frontend = "http://${aws_instance.application.public_ip}/health"
  }
}
