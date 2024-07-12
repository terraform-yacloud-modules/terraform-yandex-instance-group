module "iam_accounts" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-iam.git//modules/iam-account"

  name      = "iam-yandex-compute-instance-group"
  folder_id = "xxxx"
  folder_roles = [
    "editor"
  ]
  cloud_roles              = []
  enable_static_access_key = false
  enable_api_key           = false
  enable_account_key       = false

}

module "yandex_compute_instance" {
  source = "../"

  folder_id = "xxxx"

  zones = ["ru-central1-a"]

  name = "example-instance-group"

  network_id = "xxxx"
  subnet_ids = ["xxxx"]
  enable_nat = true

  scale = {
    fixed = {
      size = 1
    }
  }

  max_checking_health_duration = 10

  health_check = {
    enabled             = true
    interval            = 15
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    tcp_options = {
      port = 22
    }
  }

  platform_id   = "standard-v3"
  cores         = 2
  memory        = 4
  core_fraction = 100

  image_family = "ubuntu-2004-lts"

  hostname           = "my-instance"
  service_account_id = module.iam_accounts.id
  ssh_user           = "ubuntu"
  ssh_pubkey         = "~/.ssh/id_rsa.pub"

  boot_disk = {
    mode        = "READ_WRITE"
    device_name = "boot"
  }

  boot_disk_initialize_params = {
    size = 30
    type = "network-ssd"
  }

  depends_on = [ module.iam_accounts ]
}
