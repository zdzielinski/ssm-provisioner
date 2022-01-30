resource "null_resource" "provisioner" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "${path.module}/../ssm-provisioner.sh"
    environment = {
      SCRIPT      = "${path.module}/scripts/provisioner.sh"
      USERNAME    = "ubuntu"
      INSTANCE_ID = aws_instance.ec2.id
      AWS_REGION  = var.aws_region
      # nonsensitive required, or provisioner output will be hidden
      PRIVATE_KEY = nonsensitive(tls_private_key.key.private_key_pem)
    }
  }
}