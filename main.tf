terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.85.0"
    }
  }
}

data "yandex_client_config" "client" {}

resource "yandex_compute_instance_group" "vm_group" {
  name                = "vm-group-with-secondary-disks"
  folder_id           = coalesce(var.folder_id, data.yandex_client_config.client.folder_id)
  service_account_id  = yandex_iam_service_account.vm_sa.id
  deletion_protection = false

  instance_template {
    platform_id = "standard-v3"
    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd8vmcue7aajpmeo39kk" # Ubuntu 20.04 LTS
        size     = 10
        type     = "network-hdd"
      }
    }

    # Второй диск для каждой VM
    secondary_disk {
      mode = "READ_WRITE"
      initialize_params {
        size = 20
        type = "network-hdd"
      }
    }

    network_interface {
      network_id = yandex_vpc_network.vm_network.id
      subnet_ids = [yandex_vpc_subnet.vm_subnet.id]
      nat        = true
    }

    metadata = {
      ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 1
    max_creating    = 1
    max_expansion   = 1
    max_deleting    = 1
  }
}

resource "yandex_vpc_network" "vm_network" {
  name = "vm-network"
}

resource "yandex_vpc_subnet" "vm_subnet" {
  name           = "vm-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vm_network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_iam_service_account" "vm_sa" {
  name        = "vm-service-account"
  description = "Service account for VM instances"
}

resource "yandex_resourcemanager_folder_iam_member" "vm_sa_editor" {
  folder_id = coalesce(var.folder_id, data.yandex_client_config.client.folder_id)
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.vm_sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vm_sa_compute_admin" {
  folder_id = coalesce(var.folder_id, data.yandex_client_config.client.folder_id)
  role      = "compute.admin"
  member    = "serviceAccount:${yandex_iam_service_account.vm_sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vm_sa_vpc_user" {
  folder_id = coalesce(var.folder_id, data.yandex_client_config.client.folder_id)
  role      = "vpc.user"
  member    = "serviceAccount:${yandex_iam_service_account.vm_sa.id}"
}