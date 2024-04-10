resource "aws_autoscaling_group" "auto" {
  name_prefix               = "auto-"
  vpc_zone_identifier       = module.vpc.private_subnets
  desired_capacity          = 0
  max_size                  = 1
  min_size                  = 0
  health_check_type         = "EC2"
  health_check_grace_period = 180

  force_delete          = true

  launch_template {
    id      = aws_launch_template.auto.id
    version = aws_launch_template.auto.latest_version
  }


  depends_on = [aws_launch_template.auto]
}

resource "aws_autoscaling_group" "test" {
  name_prefix               = "test-"
  vpc_zone_identifier       = module.vpc.private_subnets
  desired_capacity          = 0
  max_size                  = 1
  min_size                  = 0
  health_check_type         = "EC2"
  health_check_grace_period = 180

  force_delete          = true

  launch_template {
    id      = aws_launch_template.test.id
    version = aws_launch_template.test.latest_version
  }


  depends_on = [aws_launch_template.test]
}
