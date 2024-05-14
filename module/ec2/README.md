<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
# EC2 Terraform module
This module usage data source for getting `AWS Availabilty zones` within an `region`.
It will create EC2 machines in every `AZ` available in a region.

## Example
| Region    | AZ | Ec2 |
|-----------|----|-----|
| us-east-1 | 6  | 6   |

> [!NOTE]  
> Some instance type may not be available in specified region.
> To list `instance type` available in `region`
```
aws ec2 describe-instance-type-offerings \
    --region us-east-1
```

# AMI
> [!NOTE]  
> This Module usage `Ubuntu AMI` to create EC2 Linux.

## Usage
```
module "ec2" {
  source = "path/to/ec2/module"

}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.30 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.49.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.web](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zones.azs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Choose instance type | `string` | `"t2.micro"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_ids"></a> [instance\_ids](#output\_instance\_ids) | Get EC2 instance ids |
| <a name="output_instance_public_ip"></a> [instance\_public\_ip](#output\_instance\_public\_ip) | Get instance Public Ip's |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
