resource "aws_iam_policy" "ec2_put_events" {
  name = "ec2-put-events"
  policy = data.aws_iam_policy_document.ec2_put_events.json
}

resource "aws_iam_role" "event_logs" {
  name = "auto-event-logs"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
}

resource "aws_iam_role_policy_attachment" "event_logs" {
  role       = aws_iam_role.event_logs.name
  policy_arn = aws_iam_policy.ec2_put_events.arn
}

resource "aws_iam_instance_profile" "ec2_put_events" {
    name = "ec2-put-events"
    role = aws_iam_role.event_logs.name
}
