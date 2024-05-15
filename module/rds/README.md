<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
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
```
module "rds" {
  source = "/path/to/module/rds"
}
```

> [!NOTE]
>This module by default creates `postgres` engine RDS database.
>Available RDS engine postgres, mysql, mariadb.  

```
locals {
  engine         = var.engine[0]            # index value
  engine_version = var.engine_version[0]    # index value
}
```

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.rds_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | Allocate Storage value | `number` | `20` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | Set the engine for rds instance | `list(string)` | <pre>[<br>  "postgres",<br>  "mysql",<br>  "mariadb"<br>]</pre> | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Choose appropriate engine version | `list(string)` | <pre>[<br>  "16.1",<br>  "8.0",<br>  "10.11"<br>]</pre> | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | RDS instance class | `string` | `"db.t3.micro"` | no |
| <a name="input_max_allocated_storage"></a> [max\_allocated\_storage](#input\_max\_allocated\_storage) | Auto scaling max allocation storage | `number` | `100` | no |
| <a name="input_password"></a> [password](#input\_password) | Master RDS password | `string` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | Master RDS username | `list(string)` | <pre>[<br>  "postgres",<br>  "mysql",<br>  "mariadb"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rds_endpoint"></a> [rds\_endpoint](#output\_rds\_endpoint) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
