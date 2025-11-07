#Public IP address of the web server
output "web_server_public_ip" {
  description = "The public IP address of the web server"
  value       = aws_instance.web-server.public_ip
}

#check the status of httpd service
output "web_server_httpd_status" {
  description = "The status of the httpd service on the web server"
  value       = aws_instance.web-server.id
}

# Output the security group ID
output "security_group_id" {
  description = "The ID of the security group for the web server"
  value       = aws_security_group.http-web-sg.id
}

#command to connect to the instance
output "ssh_command" {
  description = "Command to connect to the web server via SSH"
  value       = "ssh -i ${path.module}/webserver-key.pem ubuntu@${aws_instance.web-server.public_ip}"
}

