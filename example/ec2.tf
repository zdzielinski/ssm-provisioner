resource "aws_instance" "ec2" {
  ami                    = data.aws_ami.ubuntu.id
  key_name               = aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.ec2.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2.name
  instance_type          = "t2.micro"
  tags = {
    Name = "${var.environment}-ec2"
  }
}