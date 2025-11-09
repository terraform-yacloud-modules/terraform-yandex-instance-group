terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.168.0"
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
      subnet_ids = [
        yandex_vpc_subnet.vm_subnet-a.id,
        yandex_vpc_subnet.vm_subnet-b.id, 
        yandex_vpc_subnet.vm_subnet-d.id
      ]
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
    zones = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]
  }

  deploy_policy {
    max_unavailable = 1
    max_creating    = 1
    max_expansion   = 1
    max_deleting    = 1
  }

  depends_on = [
    yandex_vpc_network.vm_network,
    yandex_vpc_subnet.vm_subnet-a,
    yandex_vpc_subnet.vm_subnet-b,
    yandex_vpc_subnet.vm_subnet-d,
    yandex_iam_service_account.vm_sa,
    yandex_resourcemanager_folder_iam_member.vm_sa_editor,
    yandex_resourcemanager_folder_iam_member.vm_sa_vpc_public_admin
  ]
}

resource "yandex_vpc_network" "vm_network" {
  name = "vm-network"
}

resource "yandex_vpc_subnet" "vm_subnet-a" {
  name           = "vm-subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vm_network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "vm_subnet-b" {
  name           = "vm-subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.vm_network.id
  v4_cidr_blocks = ["192.168.20.0/24"]
}

resource "yandex_vpc_subnet" "vm_subnet-d" {
  name           = "vm-subnet-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.vm_network.id
  v4_cidr_blocks = ["192.168.30.0/24"]
}

resource "yandex_iam_service_account" "vm_sa" {
  name        = "vm-service-account"
  description = "Service account for VM instances"
}

resource "yandex_resourcemanager_folder_iam_member" "vm_sa_editor" {
  folder_id = coalesce(var.folder_id, data.yandex_client_config.client.folder_id)
  role      = "compute.editor"
  member    = "serviceAccount:${yandex_iam_service_account.vm_sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vm_sa_vpc_public_admin" {
  folder_id = coalesce(var.folder_id, data.yandex_client_config.client.folder_id)
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.vm_sa.id}"
}

variable "folder_id" {
  description = "ID of the folder to create the cluster in"
  type        = string
  default     = null
}
