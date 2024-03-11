# create security group for the application load balancer
resource "aws_security_group" "alb_security_group" {
  name        = "ec2/alb security group"
  description = "enable http/https access on port 80/443"
  vpc_id      = var.vpc_id

  ingress {
    description      = "http access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "https access"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "alb security group"
  }
}

# Create security group for EC2 instances in private subnet
resource "aws_security_group" "ec2_private_sg" {
  name        = "ec2-private-sg"
  description = "Security group for EC2 instances in private subnet"
  vpc_id      = var.vpc_id

  # Allow incoming traffic only from ALB's security group
  ingress {
    from_port       = 80  # Assuming HTTP traffic from ALB
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  # Allow outgoing traffic to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags   = {
    Name = "EC2 security group"
  }
}
