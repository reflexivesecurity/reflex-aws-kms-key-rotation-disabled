module "cwe" {
  source      = "git::https://github.com/reflexivesecurity/reflex-engine.git//modules/cwe?ref=v2.1.3"
  name        = "KmsKeyRotationDisabled"
  description = "A Reflex Rule for enforcing KMS Key rotation"

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

}
