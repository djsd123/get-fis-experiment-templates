resource "aws_launch_template" "auto" {
  name_prefix                          = "auto-"
  image_id                             = data.aws_ami.amazon_linux_2.id
  instance_type                        = "t3.micro"
  key_name                             = "id_rsa"
  vpc_security_group_ids               = [aws_security_group.auto.id]
  update_default_version               = true
  disable_api_termination              = false
  instance_initiated_shutdown_behavior = "terminate"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_put_events.id
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "auto"
    }
  }
}

resource "aws_launch_template" "test" {
  name_prefix                          = "test-"
  image_id                             = data.aws_ami.amazon_linux_2.id
  instance_type                        = "t3.micro"
  key_name                             = "id_rsa"
  vpc_security_group_ids               = [aws_security_group.auto.id]
  update_default_version               = true
  disable_api_termination              = false
  instance_initiated_shutdown_behavior = "terminate"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_put_events.id
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "test"
    }
  }
}
