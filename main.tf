locals {
  use_snapshot = var.image_snapshot_id != null ? true : false
  image_id = (
    coalesce(
      var.image_id,
      data.yandex_compute_image.this.id
  ))
  ssh_keys = var.generate_ssh_key ? "${var.ssh_user}:${tls_private_key.this[0].public_key_openssh}" : (var.ssh_pubkey != null ? "${var.ssh_user}:${file(var.ssh_pubkey)}" : null)

}

resource "tls_private_key" "this" {
  count = var.generate_ssh_key ? 1 : 0

  algorithm = "RSA"
}

resource "yandex_compute_instance_group" "this" {
  name        = var.name
  description = var.instance_group_description
  labels      = var.labels
  variables   = var.variables

  service_account_id  = var.service_account_id
  deletion_protection = var.deletion_protection

  instance_template {
    name        = format("%s-{instance.index}", var.name)
    description = var.instance_description
    labels      = var.labels

    hostname           = format("%s-{instance.index}", var.hostname)
    service_account_id = var.service_account_id

    metadata = {
      serial-port-enable    = var.serial_port_enable ? 1 : null
      install-unified-agent = var.install_unified_agent ? 1 : 0
      ssh-keys              = local.ssh_keys
      user-data             = var.user_data
    }

    platform_id = var.platform_id
    scheduling_policy {
      preemptible = var.preemptible
    }

    # TODO
    #  placement_policy {
    #    placement_group_id = var.placement_group_id
    #
    #    # dynamic "host_affinity_rules" {
    #    #   for_each = var.placement_affinity_rules
    #    #
    #    #   content {
    #    #     key   = host_affinity_rules.value["key"]
    #    #     op    = host_affinity_rules.value["op"]
    #    #     value = host_affinity_rules.value["value"]
    #    #   }
    #    # }
    #  }

    resources {
      cores         = var.cores
      memory        = var.memory
      core_fraction = var.core_fraction
    }

    boot_disk {
      mode        = var.boot_disk.mode
      device_name = var.boot_disk.device_name

      initialize_params {
        description = ""
        size        = var.boot_disk_initialize_params.size
        type        = var.boot_disk_initialize_params.type
        image_id    = local.use_snapshot ? null : local.image_id
        snapshot_id = local.use_snapshot ? var.image_snapshot_id : null
      }
    }

    dynamic "secondary_disk" {
      for_each = var.secondary_disk != null ? [1] : []

      content {
        mode        = "READ_WRITE"
        device_name = try(var.secondary_disk.device_name, null)

        # ID of the existing disk. To set use variables.
        disk_id = try(var.secondary_disk.disk_id, null)

        name = try(var.secondary_disk.name, "secondary-disk")

        dynamic "initialize_params" {
          for_each = var.secondary_disk.initialize_params != null ? [1] : []
          content {
            description = try(var.secondary_disk.initialize_params.description, "")
            size        = try(var.secondary_disk.initialize_params.size, null)
            type        = try(var.secondary_disk.initialize_params.type, null)
            image_id    = try(var.secondary_disk.initialize_params.image_id, null)
            snapshot_id = try(var.secondary_disk.initialize_params.snapshot_id, null)
          }
        }
      }
    }

    network_interface {
      network_id         = var.network_id
      subnet_ids         = var.subnet_ids
      nat                = var.enable_nat
      security_group_ids = var.security_group_ids

      # dns_record {}
      # ipv6_dns_record{}
      # nat_dns_record {}
    }

    network_settings {
      type = var.network_acceleration_type
    }
  }

  scale_policy {
    dynamic "fixed_scale" {
      for_each = lookup(var.scale, "fixed", null) != null ? [1] : []
      content {
        size = var.scale.fixed.size
      }
    }

    dynamic "auto_scale" {
      for_each = lookup(var.scale, "auto", null) != null ? [1] : []
      content {
        initial_size           = var.scale.auto.initial_size
        measurement_duration   = var.scale.auto.measurement_duration
        cpu_utilization_target = var.scale.auto.cpu_utilization_target
        auto_scale_type        = try(var.scale.auto.auto_scale_type, "ZONAL")
        min_zone_size          = var.scale.auto.min_zone_size
        max_size               = var.scale.auto.max_size
        warmup_duration        = var.scale.auto.warmup_duration
        stabilization_duration = var.scale.auto.stabilization_duration
      }
    }
  }

  max_checking_health_duration = var.max_checking_health_duration
  dynamic "health_check" {
    for_each = var.health_check["enabled"] ? [1] : []
    content {
      interval            = var.health_check["interval"]
      timeout             = var.health_check["timeout"]
      healthy_threshold   = var.health_check["healthy_threshold"]
      unhealthy_threshold = var.health_check["unhealthy_threshold"]

      dynamic "tcp_options" {
        for_each = var.health_check.tcp_options != null ? [1] : []
        content {
          port = var.health_check.tcp_options.port
        }
      }

      dynamic "http_options" {
        for_each = var.health_check.http_options != null ? [1] : []
        content {
          port = var.health_check.http_options.port
          path = var.health_check.http_options.path
        }
      }
    }
  }

  dynamic "application_load_balancer" {
    for_each = var.enable_alb_integration ? [1] : []
    content {
      target_group_name            = try(var.target_group.name, var.name, "target-group")
      target_group_description     = try(var.target_group.description, "")
      target_group_labels          = try(var.target_group.labels, var.labels, {})
      max_opening_traffic_duration = var.max_opening_traffic_duration
    }
  }

  dynamic "load_balancer" {
    for_each = var.enable_nlb_integration ? [1] : []
    content {
      target_group_name            = try(var.target_group.name, var.name, "target-group")
      target_group_description     = try(var.target_group.description, "")
      target_group_labels          = try(var.target_group.labels, var.labels, {})
      max_opening_traffic_duration = var.max_opening_traffic_duration
    }
  }

  allocation_policy {
    zones = var.zones
  }

  deploy_policy {
    max_unavailable  = var.deploy_policy.max_unavailable
    max_expansion    = var.deploy_policy.max_expansion
    max_deleting     = var.deploy_policy.max_deleting
    max_creating     = var.deploy_policy.max_creating
    startup_duration = var.deploy_policy.startup_duration
    strategy         = var.deploy_policy.strategy
  }
}
