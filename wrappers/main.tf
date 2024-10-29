module "wrapper" {
  source = "../"

  for_each = var.items

  name                         = try(each.value.name, var.defaults.name, null)
  zones                        = try(each.value.zones, var.defaults.zones, [])
  instance_group_description   = try(each.value.instance_group_description, var.defaults.instance_group_description, null)
  instance_description         = try(each.value.instance_description, var.defaults.instance_description, null)
  labels                       = try(each.value.labels, var.defaults.labels, {})
  network_id                   = try(each.value.network_id, var.defaults.network_id, null)
  subnet_ids                   = try(each.value.subnet_ids, var.defaults.subnet_ids, [])
  enable_nat                   = try(each.value.enable_nat, var.defaults.enable_nat, false)
  security_group_ids           = try(each.value.security_group_ids, var.defaults.security_group_ids, null)
  network_acceleration_type    = try(each.value.network_acceleration_type, var.defaults.network_acceleration_type, "STANDARD")
  serial_port_enable           = try(each.value.serial_port_enable, var.defaults.serial_port_enable, false)
  variables                    = try(each.value.variables, var.defaults.variables, {})
  deletion_protection          = try(each.value.deletion_protection, var.defaults.deletion_protection, false)
  scale                        = try(each.value.scale, var.defaults.scale, { fixed = { size = 1 } })
  deploy_policy                = try(each.value.deploy_policy, var.defaults.deploy_policy, { max_unavailable = 1, max_expansion = 1 })
  enable_nlb_integration       = try(each.value.enable_nlb_integration, var.defaults.enable_nlb_integration, false)
  enable_alb_integration       = try(each.value.enable_alb_integration, var.defaults.enable_alb_integration, false)
  max_opening_traffic_duration = try(each.value.max_opening_traffic_duration, var.defaults.max_opening_traffic_duration, 300)
  max_checking_health_duration = try(each.value.max_checking_health_duration, var.defaults.max_checking_health_duration, 10)
  health_check                 = try(each.value.health_check, var.defaults.health_check, { enabled = true, tcp_options = { port = 8080 } })
  platform_id                  = try(each.value.platform_id, var.defaults.platform_id, "standard-v3")
  cores                        = try(each.value.cores, var.defaults.cores, 2)
  memory                       = try(each.value.memory, var.defaults.memory, 2)
  core_fraction                = try(each.value.core_fraction, var.defaults.core_fraction, null)
  preemptible                  = try(each.value.preemptible, var.defaults.preemptible, false)
  image_snapshot_id            = try(each.value.image_snapshot_id, var.defaults.image_snapshot_id, null)
  image_id                     = try(each.value.image_id, var.defaults.image_id, null)
  image_family                 = try(each.value.image_family, var.defaults.image_family, "ubuntu-2004-lts")
  hostname                     = try(each.value.hostname, var.defaults.hostname, null)
  service_account_id           = try(each.value.service_account_id, var.defaults.service_account_id, null)
  generate_ssh_key             = try(each.value.generate_ssh_key, var.defaults.generate_ssh_key, true)
  ssh_user                     = try(each.value.ssh_user, var.defaults.ssh_user, "ubuntu")
  ssh_pubkey                   = try(each.value.ssh_pubkey, var.defaults.ssh_pubkey, null)
  user_data                    = try(each.value.user_data, var.defaults.user_data, null)
  boot_disk                    = try(each.value.boot_disk, var.defaults.boot_disk, {})
  boot_disk_initialize_params  = try(each.value.boot_disk_initialize_params, var.defaults.boot_disk_initialize_params, { size = 10, type = "network-hdd" })
  secondary_disks              = try(each.value.secondary_disks, var.defaults.secondary_disks, {})
}
