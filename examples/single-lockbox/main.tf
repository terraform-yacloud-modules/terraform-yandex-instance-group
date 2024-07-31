module "iam_accounts" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-iam.git//modules/iam-account?ref=v1.0.0"

  name = "iam-yandex-compute-instance-group"
  folder_roles = [
    "editor"
  ]
  cloud_roles              = []
  enable_static_access_key = false
  enable_api_key           = false
  enable_account_key       = false

}

data "yandex_client_config" "client" {}

module "network" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-vpc.git?ref=v1.0.0"

  folder_id = data.yandex_client_config.client.folder_id

  blank_name = "vpc-nat-gateway"
  labels = {
    repo = "terraform-yacloud-modules/terraform-yandex-vpc"
  }

  azs = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]

  private_subnets = [["10.4.0.0/24"]]

  create_vpc         = true
  create_nat_gateway = true
}

module "yandex_compute_instance" {
  source = "../../"

  zones = ["ru-central1-a"]

  name = "example-instance-group"

  network_id = module.network.vpc_id
  subnet_ids = [module.network.private_subnets_ids[0]]
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

  enable_alb_integration = true

  hostname           = "my-instance"
  service_account_id = module.iam_accounts.id
  ssh_user           = "ubuntu"
  generate_ssh_key   = true

  user_data = <<-EOF
        #cloud-config
        package_upgrade: true
        packages:
          - nginx
        runcmd:
          - [systemctl, start, nginx]
          - [systemctl, enable, nginx]
        EOF

  boot_disk = {
    mode        = "READ_WRITE"
    device_name = "boot"
  }

  boot_disk_initialize_params = {
    size = 30
    type = "network-ssd"
  }

  depends_on = [module.iam_accounts]
}

module "lockbox_instance_secrets" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-lockbox.git?ref=v1.0.0"

  name = "example-instance-group-secrets"
  labels = {
    repo = "terraform-yacloud-modules-terraform-yandex-lockbox"
  }

  entries = {
    "ssh-prv" : module.yandex_compute_instance.ssh_key_prv
    "ssh-pub" : module.yandex_compute_instance.ssh_key_pub
  }

  deletion_protection = false
}
