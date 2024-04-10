data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_ami" "amazon_linux_2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

data "aws_iam_policy_document" "events_logs" {
  statement {
    sid = "putEvents"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    principals {
      type        = "Service"
      identifiers = [
        "events.amazonaws.com",
        "delivery.logs.amazonaws.com"
      ]
    }

    resources = [
      "${aws_cloudwatch_log_group.events_logs.arn}:*"
    ]
  }
}

data "aws_iam_policy_document" "ec2_assume" {
  statement {
    sid = "AllowAssume"
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ec2_put_events" {
  statement {
    sid = "putEvents"
    effect = "Allow"

    actions = [
      "events:PutEvents"
    ]

    resources = [
      "*"
    ]

  }
}

#data "aws_iam_policy_document" "assume" {
#  statement {
#    sid = "AllowAssume"
#    effect = "Allow"
#    actions = ["sts:AssumeRole"]
#
#    principals {
#      type        = "Service"
#      identifiers = ["events.amazonaws.com"]
#    }
#  }
#}

#data "aws_iam_policy_document" "event_logs" {
#  statement {
#    sid = "createStreams"
#    effect = "Allow"
#    actions = ["logs:CreateLogStream"]
#    resources = [aws_cloudwatch_log_group.events_logs.arn]
#  }
#
#  statement {
#    sid = "AllowPutEvents"
#    effect = "Allow"
#    actions = ["logs:PutLogEvents"]
#
#    resources = ["${aws_cloudwatch_log_group.events_logs.arn}/log-stream/*"]
#  }
#}
