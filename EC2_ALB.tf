# Create EC2 instance for public subnet 1
resource "aws_instance" "web_server1_P18" {
  ami             = "ami-090fa75af13c156b4"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.publicsg_P18.id]
  subnet_id       = aws_subnet.public_subnet1a_P18.id

  user_data = <<-EOF
        #!/bin/bash
        yum update -y
        yum install httpd -y
        systemctl start
        systemctl enable
        echo '<h1>Hello LUIT Red Team!</h1>' > /usr/share/nginx/html/index.html
        EOF
}

# Create EC2 instance for public subnet 2
resource "aws_instance" "web_server2_P18" {
  ami             = "ami-090fa75af13c156b4"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.publicsg_P18.id]
  subnet_id       = aws_subnet.public_subnet1b_P18.id

  user_data = <<-EOF
        #!/bin/bash
        yum update -y
        yum install httpd -y
        systemctl start
        systemctl enable 
        echo '<h1>LUIT Red Team = BEST TEAM!</h1>' > /usr/share/nginx/html/index.html
        EOF
}
# Create Load balancer
resource "aws_lb" "lb_P18" {
  name               = "lb-P18"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.publicsg_P18.id] 
  subnets            = [aws_subnet.public_subnet1a_P18.id, aws_subnet.public_subnet1b_P18.id] 
  
  tags = {
    Environment = "P18"
  }
}

resource "aws_lb_target_group" "P18_target_grp" {
  name     = "project-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.TF_P18.id
}