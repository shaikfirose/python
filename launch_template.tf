# launch_template.tf

# Launch Template for Auto Scaling Group
resource "aws_launch_template" "app_lt" {
  name_prefix   = "app-"
  image_id      = "ami-00bb6a80f01f03502"  # Replace with your preferred Amazon Linux AMI
  instance_type = "t2.micro"

  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo "<h1>Hello, World</h1>" > /var/www/html/index.html
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
  EOF
  )

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.web_sg.id]
  }
}
