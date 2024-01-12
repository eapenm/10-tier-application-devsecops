resource "aws_security_group" "jenkins-sg" {
  name        = "jenkins-security-group"
  description = "Jenkins Security Group to give access to different ports required to develop the pipeline"

  # Define a single ingress rule to allow traffic on all specified ports
  # ingress = [
  #   for port in [22, 80, 443, 8080, 9000, 3000] : {
  #     description      = "Created Securty Group for Jenkins"
  #     from_port        = port
  #     to_port          = port
  #     protocol         = "tcp"
  #     cidr_blocks      = ["0.0.0.0/0"]
  #     ipv6_cidr_blocks = []
  #     prefix_list_ids  = []
  #     security_groups  = []
  #     self             = false
  #   }
  # ]

  # egress {
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  tags = {
    Name = "Jenkins-SG"
  }
}
# Inbound rule for SSH
resource "aws_security_group_rule" "ssh" {
  security_group_id = aws_security_group.jenkins-sg.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Inbound rule for PostgreSQL
resource "aws_security_group_rule" "postgresql" {
  security_group_id = aws_security_group.jenkins-sg.id
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Inbound rule for SMTP
resource "aws_security_group_rule" "smtp" {
  security_group_id = aws_security_group.jenkins-sg.id
  type              = "ingress"
  from_port         = 25
  to_port           = 25
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}
# Inbound rule for SMTP
resource "aws_security_group_rule" "smtp1" {
  security_group_id = aws_security_group.jenkins-sg.id
  type              = "ingress"
  from_port         = 465
  to_port           = 465
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Inbound rule for Custom TCP port
resource "aws_security_group_rule" "custom_tcp" {
  security_group_id = aws_security_group.jenkins-sg.id
  type              = "ingress"
  from_port         = 3000
  to_port           = 10000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}
# Inbound rule for Custom TCP port
resource "aws_security_group_rule" "custom_tcp1" {
  security_group_id = aws_security_group.jenkins-sg.id
  type              = "ingress"
  from_port         = 30000
  to_port           = 32768
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}
# Inbound rule for custum tcp
resource "aws_security_group_rule" "custom_tcp2" {
  security_group_id = aws_security_group.jenkins-sg.id
  type              = "ingress"
  from_port         = 6443
  to_port           = 6443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}
# Inbound rule for http
resource "aws_security_group_rule" "http" {
  security_group_id = aws_security_group.jenkins-sg.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}
# Inbound rule for http
resource "aws_security_group_rule" "https" {
  security_group_id = aws_security_group.jenkins-sg.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}
# resource "aws_security_group_rule" "egress_all" {
#   security_group_id = aws_security_group.jenkins-sg.id
#   type              = "egress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"]
# }

resource "aws_instance" "web" {
  ami                    = "ami-06aa3f7caf3a30282"
  instance_type          = "t2.xlarge"
  key_name               = "Robin"
  vpc_security_group_ids = [aws_security_group.jenkins-sg.id]
  user_data              = templatefile("./install_jenkins.sh", {})

  tags = {
    Name = "Jenkins Server"
  }
  root_block_device {
    volume_size = 30
  }
}
