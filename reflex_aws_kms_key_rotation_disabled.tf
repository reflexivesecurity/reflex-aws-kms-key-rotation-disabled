module "reflex_aws_kms_key_rotation_disabled" {
  source           = "git::https://github.com/cloudmitigator/reflex-engine.git//modules/cwe_lambda?ref=v0.5.8"
  rule_name        = "KMSKeyRotationDisabled"
  rule_description = "A Reflex Rule for enforcing KMS Key rotation"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.kms"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "kms.amazonaws.com"
    ],
    "eventName": [
      "CreateKey",
      "DisableKeyRotation"
    ]
  }
}
PATTERN

  function_name   = "KMSKeyRotationDisabled"
  source_code_dir = "${path.module}/source"
  handler         = "reflex_aws_kms_key_rotation_disabled.lambda_handler"
  lambda_runtime  = "python3.7"
  environment_variable_map = {
    SNS_TOPIC = var.sns_topic_arn,
    MODE      = var.mode
  }
  custom_lambda_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "kms:EnableKeyRotation",
        "kms:GetKeyRotationStatus"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF

  queue_name    = "KMSKeyRotationDisabled"
  delay_seconds = 0

  target_id = "KMSKeyRotationDisabled"

  sns_topic_arn  = var.sns_topic_arn
  sqs_kms_key_id = var.reflex_kms_key_id
}
