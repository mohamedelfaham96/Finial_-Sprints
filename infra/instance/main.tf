resource "aws_instance" "jenkins-instance" {
  ami = var.AMI
  tags = {
    Name = "jenkins-instance"
  }
  instance_type = var.INSTANCE_TYPE
  subnet_id     = var.PRIVATE_SUBNET_ID

  # vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
  vpc_security_group_ids = [aws_security_group.ssh-allowed.id]

  # the Public SSH key
  key_name = var.KEY_PAIR

  # installation
  # user_data = var.user_data

  connection {
    user        = var.EC2_USER
    private_key = file("${var.PRIVATE_KEY_PATH}")
  }
}

resource "aws_security_group" "ssh-allowed" {
  vpc_id = var.MAIN_VPC_ID
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = var.EGRESS_CIDR
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.INGRESS_CIDER
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.INGRESS_CIDER
  }
  tags = {
    Name = "ssh-allowed"
  }
}