# Yandex Cloud VM Instance group Terraform module

Terraform module which creates Yandex Cloud VM Instance group resources.

## Examples

Examples codified under
the [`examples`](https://github.com/terraform-yacloud-modules/terraform-yandex-instance-group/tree/main/examples) are intended
to give users references for how to use the module(s) as well as testing/validating changes to the source code of the
module. If contributing to the project, please be sure to make any appropriate updates to the relevant examples to allow
maintainers to test your changes and to keep the examples up to date for users. Thank you!

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tls_private_key.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [yandex_compute_instance_group.this](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance_group) | resource |
| [yandex_client_config.client](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/client_config) | data source |
| [yandex_compute_image.this](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/compute_image) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_boot_disk"></a> [boot\_disk](#input\_boot\_disk) | Basic boot disk parameters | <pre>object({<br>    mode        = optional(string)<br>    device_name = optional(string)<br>  })</pre> | `{}` | no |
| <a name="input_boot_disk_initialize_params"></a> [boot\_disk\_initialize\_params](#input\_boot\_disk\_initialize\_params) | Additional boot disk parameters | <pre>object({<br>    size = optional(number, 10)<br>    type = optional(string, "network-hdd")<br>  })</pre> | `{}` | no |
| <a name="input_core_fraction"></a> [core\_fraction](#input\_core\_fraction) | Core fraction applied to instance | `number` | `null` | no |
| <a name="input_cores"></a> [cores](#input\_cores) | Cores allocated to instance | `number` | `2` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Flag that protects the instance group from accidental deletion | `bool` | `false` | no |
| <a name="input_deploy_policy"></a> [deploy\_policy](#input\_deploy\_policy) | Instance group deploy policy | <pre>object({<br>    max_unavailable  = number<br>    max_expansion    = number<br>    max_deleting     = optional(number)<br>    max_creating     = optional(number)<br>    startup_duration = optional(string)<br>    strategy         = optional(string, "proactive")<br>  })</pre> | <pre>{<br>  "max_expansion": 1,<br>  "max_unavailable": 1<br>}</pre> | no |
| <a name="input_enable_alb_integration"></a> [enable\_alb\_integration](#input\_enable\_alb\_integration) | If true, Application load balancer integration will be created | `bool` | `false` | no |
| <a name="input_enable_nat"></a> [enable\_nat](#input\_enable\_nat) | Enable public IPv4 address | `bool` | `false` | no |
| <a name="input_enable_nlb_integration"></a> [enable\_nlb\_integration](#input\_enable\_nlb\_integration) | If true, Network load balancer integration will be created | `bool` | `false` | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | Folder ID | `string` | `null` | no |
| <a name="input_generate_ssh_key"></a> [generate\_ssh\_key](#input\_generate\_ssh\_key) | If true, SSH key will be generated for instance group | `string` | `true` | no |
| <a name="input_health_check"></a> [health\_check](#input\_health\_check) | Health check configuration | <pre>object({<br>    enabled             = optional(bool, false)<br>    interval            = optional(number, 15)<br>    timeout             = optional(number, 10)<br>    healthy_threshold   = optional(number, 3)<br>    unhealthy_threshold = optional(number, 3)<br>    tcp_options = optional(object({<br>      port = number<br>    }), null)<br>    http_options = optional(object({<br>      port = number,<br>      path = string<br>    }), null)<br>  })</pre> | <pre>{<br>  "enabled": true,<br>  "tcp_options": {<br>    "port": 8080<br>  }<br>}</pre> | no |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | Hostname of the instance. More info: https://cloud.yandex.ru/docs/compute/concepts/network#hostname | `string` | `null` | no |
| <a name="input_image_family"></a> [image\_family](#input\_image\_family) | Default image family name (lowest priority) | `string` | `"ubuntu-2004-lts"` | no |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | Image ID (medium priority) | `string` | `null` | no |
| <a name="input_image_snapshot_id"></a> [image\_snapshot\_id](#input\_image\_snapshot\_id) | Image snapshot id to initialize from.<br>Highest priority over var.image\_id<br>and var.image\_family" | `string` | `null` | no |
| <a name="input_instance_description"></a> [instance\_description](#input\_instance\_description) | Instance description | `string` | `null` | no |
| <a name="input_instance_group_description"></a> [instance\_group\_description](#input\_instance\_group\_description) | Instance group description | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | A set of labels which will be applied to all resources | `map(string)` | `{}` | no |
| <a name="input_max_checking_health_duration"></a> [max\_checking\_health\_duration](#input\_max\_checking\_health\_duration) | Timeout for waiting for the VM to become healthy | `number` | `10` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | Memory allocated to instance (in Gb) | `number` | `2` | no |
| <a name="input_name"></a> [name](#input\_name) | Name which will be used for all resources | `string` | n/a | yes |
| <a name="input_network_acceleration_type"></a> [network\_acceleration\_type](#input\_network\_acceleration\_type) | Network acceleration type | `string` | `"STANDARD"` | no |
| <a name="input_network_id"></a> [network\_id](#input\_network\_id) | Network ID | `string` | `null` | no |
| <a name="input_placement_affinity_rules"></a> [placement\_affinity\_rules](#input\_placement\_affinity\_rules) | List of host affinity rules | <pre>list(object({<br>    key   = string<br>    op    = string<br>    value = string<br>  }))</pre> | `[]` | no |
| <a name="input_placement_group_id"></a> [placement\_group\_id](#input\_placement\_group\_id) | Placement group ID | `string` | `null` | no |
| <a name="input_platform_id"></a> [platform\_id](#input\_platform\_id) | Hardware CPU platform name (Intel Ice Lake by default) | `string` | `"standard-v3"` | no |
| <a name="input_preemptible"></a> [preemptible](#input\_preemptible) | Make instance preemptible | `bool` | `false` | no |
| <a name="input_scale"></a> [scale](#input\_scale) | Instance group scaling policy | <pre>object({<br>    fixed = optional(object({<br>      size = number<br>    }), null)<br>    auto = optional(object({<br>      initial_size           = number<br>      measurement_duration   = number<br>      cpu_utilization_target = string<br>      min_zone_size          = number<br>      max_size               = number<br>      warmup_duration        = string<br>      stabilization_duration = string<br>    }), null)<br><br>  })</pre> | <pre>{<br>  "fixed": {<br>    "size": 1<br>  }<br>}</pre> | no |
| <a name="input_secondary_disks"></a> [secondary\_disks](#input\_secondary\_disks) | Additional disks with params | <pre>map(object({<br>    enabled     = optional(bool, true)<br>    auto_delete = optional(bool, false)<br>    mode        = optional(string)<br>    labels      = optional(map(string), {})<br>    type        = optional(string, "network-hdd")<br>    size        = optional(number, 10)<br>    block_size  = optional(number, 4096)<br>    device_name = optional(string, "data")<br>  }))</pre> | `{}` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security group IDs linked to instances | `list(string)` | `null` | no |
| <a name="input_serial_port_enable"></a> [serial\_port\_enable](#input\_serial\_port\_enable) | Enable serial port on instances | `bool` | `false` | no |
| <a name="input_service_account_id"></a> [service\_account\_id](#input\_service\_account\_id) | ID of the service account authorized for instance | `string` | `null` | no |
| <a name="input_ssh_pubkey"></a> [ssh\_pubkey](#input\_ssh\_pubkey) | Public RSA key path to inject | `string` | `null` | no |
| <a name="input_ssh_user"></a> [ssh\_user](#input\_ssh\_user) | Initial SSH username for instance | `string` | `"ubuntu"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | VPC Subnet IDs | `list(string)` | `[]` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | Cloud-init user-data | `string` | `null` | no |
| <a name="input_variables"></a> [variables](#input\_variables) | A set of key/value variables pairs to assign to the instance group | `map(string)` | `{}` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | A list of availability zones | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_group_id"></a> [instance\_group\_id](#output\_instance\_group\_id) | Compute instance group ID |
| <a name="output_ssh_key_prv"></a> [ssh\_key\_prv](#output\_ssh\_key\_prv) | Private SSH key |
| <a name="output_ssh_key_pub"></a> [ssh\_key\_pub](#output\_ssh\_key\_pub) | Public SSH key |
| <a name="output_target_group_id"></a> [target\_group\_id](#output\_target\_group\_id) | Target group ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache-2.0 Licensed.
See [LICENSE](https://github.com/terraform-yacloud-modules/terraform-yandex-instance-group/blob/main/LICENSE).
