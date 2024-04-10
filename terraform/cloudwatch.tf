resource "aws_cloudwatch_log_group" "events_logs" {
    name              = "/aws/events/auto"
    retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "test_logs" {
    name              = "/aws/events/test"
    retention_in_days = 1
}

resource "aws_cloudwatch_log_resource_policy" "test_logs_policy" {
  policy_document = data.aws_iam_policy_document.events_logs.json
  policy_name     = "test"
}

resource "aws_cloudwatch_log_resource_policy" "events_logs_policy" {
  policy_document = data.aws_iam_policy_document.events_logs.json
  policy_name     = "auto"
}

resource "aws_cloudwatch_event_rule" "events_auto_rule" {
  name = "auto"
  description = "test auto scaling"
  state = "ENABLED"
  event_bus_name = "default"

  event_pattern = jsonencode({
    source = ["aws.autoscaling"],
    detail_type = ["EC2 Instance Launch Successful"],
    detail = {
      AutoScalingGroupName = [aws_autoscaling_group.auto.name]
    }
  })
}

resource "aws_cloudwatch_event_target" "events_auto_target" {
  target_id = "auto-logs"
  arn  = aws_cloudwatch_log_group.events_logs.arn
  rule = aws_cloudwatch_event_rule.events_auto_rule.name
  event_bus_name = "default"
}
