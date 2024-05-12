<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
# EC2 Terraform module
This module usage data source for getting `AWS Availabilty zones` within an `region`.
It will create EC2 machines in every `AZ` available in a region.

## Example
|Reagion|us-east-1|
|AZ in us-east-1|6|
|Ec2 machines|6| 

## Usage
```
module "ec2" {
  source = "path/to/ec2/module"

}
```

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->