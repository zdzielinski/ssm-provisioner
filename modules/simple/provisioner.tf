resource "null_resource" "provisioner" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "${path.module}/../../ssm-provisioner.sh"
    environment = {
      # script to execute
      SCRIPT      = "${path.module}/scripts/provisioner.sh"
      # username to connect with
      USERNAME    = "ubuntu"
      # instance id to connect to
      INSTANCE_ID = aws_instance.ec2.id
      # aws region to use
      AWS_REGION  = var.aws_region
      # private key to use
      # nonsensitive required, or provisioner output will be hidden
      PRIVATE_KEY = nonsensitive(tls_private_key.key.private_key_pem)
      # environment variables to set when executing the script
      # multi-line string is suggested, but not required
      ENVIRONMENT = <<-EOF
      EXAMPLE_VAR_1=foo
      EXAMPLE_VAR_2=bar
      EOF
      # enable debugging
      # not recommended for production use
      DEBUG = true
    }
  }
}