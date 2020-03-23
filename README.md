# reflex-aws-kms-key-rotation-disabled
A Reflex Rule for enforcing KMS Key rotation

## Usage
To use this rule either add it to your `reflex.yaml` configuration file:  
```
rules:
  - reflex-aws-kms-key-rotation-disabled:
      version: latest
```

or add it directly to your Terraform:  
```
...

module "reflex-aws-kms-key-rotation-disabled" {
  source           = "github.com/cloudmitigator/reflex-aws-kms-key-rotation-disabled"
}

...
```

## License
This Reflex rule is made available under the MPL 2.0 license. For more information view the [LICENSE](https://github.com/cloudmitigator/reflex-aws-kms-key-rotation-disabled/blob/master/LICENSE) 
