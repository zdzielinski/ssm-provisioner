resource "aws_iam_instance_profile" "ec2" {
  name = "${var.environment}-instance-profile"
  role = aws_iam_role.ec2.name
  tags = {
    Name = "${var.environment}-instance-profile"
  }
}

resource "aws_iam_role" "ec2" {
  name = "${var.environment}-iam-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : {
      "Effect" : "Allow",
      "Principal" : { "Service" : "ec2.amazonaws.com" },
      "Action" : "sts:AssumeRole"
    }
  })
  tags = {
    Name = "${var.environment}-iam-role"
  }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}