""" Module for KMSKeyRotationDisabled """

import json
import os

import boto3
from reflex_core import AWSRule, subscription_confirmation


class KMSKeyRotationDisabled(AWSRule):
    """ A Reflex Rule for enforcing KMS Key rotation """

    client = boto3.client("kms")

    def __init__(self, event):
        super().__init__(event)

    def extract_event_data(self, event):
        """ Extract required event data """
        if event["detail"]["eventName"] == "CreateKey":
            self.key_id = event["detail"]["responseElements"]["keyMetadata"]["keyId"]
        else:  # event["detail"]["eventName"] == "DisableKeyRotation"
            self.key_id = event["detail"]["requestParameters"]["keyId"]

    def resource_compliant(self):
        """
        Determine if the resource is compliant with your rule.

        Return True if it is compliant, and False if it is not.
        """
        response = self.client.get_key_rotation_status(KeyId=self.key_id)
        return response["KeyRotationEnabled"]

    def remediate(self):
        """
        Fix the non-compliant resource so it conforms to the rule
        """
        self.client.enable_key_rotation(KeyId=self.key_id)

    def get_remediation_message(self):
        """ Returns a message about the remediation action that occurred """
        message = f"A KMS key (Key Id: {self.key_id}) had key rotation disabled. "
        if self.should_remediate():
            message += "Rotation has been enabled."

        return message


def lambda_handler(event, _):
    """ Handles the incoming event """
    print(event)
    if subscription_confirmation.is_subscription_confirmation(event):
        subscription_confirmation.confirm_subscription(event)
        return
    rule = KMSKeyRotationDisabled(json.loads(event["Records"][0]["body"]))
    rule.run_compliance_rule()
