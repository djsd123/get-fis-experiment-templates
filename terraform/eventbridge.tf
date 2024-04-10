module "test" {
  source = "terraform-aws-modules/eventbridge/aws"

#  bus_name = "test-bus"
  create_bus = false
  create_permissions = true

  permissions = {
    "340594004420 Access" = {
      action = "events:PutEvents"
    }

  }

  rules = {
    orders = {
      description = "auto scaling ec2 launch"
      event_pattern = jsonencode({
        source = ["aws.autoscaling"],
        detail_type = ["EC2 Instance Launch Successful"],
        detail = {
          AutoScalingGroupName = [aws_autoscaling_group.test.name]
        }
      })
    }
  }

  targets = {
    orders = [
      {
        name = aws_cloudwatch_log_group.test_logs.name
        arn = aws_cloudwatch_log_group.test_logs.arn
      }
    ]
  }

  tags = {
    Name = "test"
  }
}
