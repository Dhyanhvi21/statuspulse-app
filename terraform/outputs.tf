output "server_public_ip" {
  description = "The public IP address of the StatusPulse server"
  value       = aws_instance.statuspulse_server.public_ip
}

output "server_public_dns" {
  description = "The public DNS of the StatusPulse server"
  value       = aws_instance.statuspulse_server.public_dns
}
