# autoscaling.tf

# Auto Scaling Group
resource "aws_autoscaling_group" "app_asg" {
  desired_capacity     = 2
  max_size             = 5
  min_size             = 1
  vpc_zone_identifier  = [aws_subnet.public_subnet.id]  # Add more subnets here as needed
  health_check_type    = "EC2"
  target_group_arns    = [aws_lb_target_group.app_tg.arn]
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }
}
