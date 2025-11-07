#Generate Key pair locally & in AWS
resource "tls_private_key" "webserver" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "webserver" {
  key_name   = "webserver-key"
  public_key = tls_private_key.webserver.public_key_openssh
}

# Save the private key to a local file
resource "local_file" "private_key" {
  content              = tls_private_key.webserver.private_key_pem
  filename             = "${path.module}/webserver-key.pem"
  file_permission      = "0400"
  directory_permission = "0700"
}
# Output the key pair name
output "key_pair_name" {
  value = aws_key_pair.webserver.key_name
}



