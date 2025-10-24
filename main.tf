resource "yandex_compute_instance_group" "this" {
  name = var.name

  folder_id          = var.folder_id
  service_account_id = var.service_account_id

  instance_template {
    name = format("%s-{instance.index}", var.name)

    service_account_id = var.service_account_id

    platform_id = var.platform_id

    resources {
      cores  = var.cores
      memory = var.memory
    }

    boot_disk {
      mode        = var.boot_disk.mode
      device_name = var.boot_disk.device_name

      initialize_params {
        size     = var.boot_disk_initialize_params.size
        type     = var.boot_disk_initialize_params.type
        image_id = var.image_id
      }
    }

    dynamic "secondary_disk" {
      for_each = var.secondary_disks

      iterator = disk
      content {
        disk_id = yandex_compute_disk.main[disk.key].id
      }
    }

    network_interface {
      network_id         = var.network_id
      subnet_ids         = var.subnet_ids
      nat                = var.enable_nat
      security_group_ids = var.security_group_ids
    }
  }

  scale_policy {
    fixed_scale {
      size = var.instance_count
    }
  }

  allocation_policy {
    zones = var.zones
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 1
  }
}
