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

  private_subnets = [["10.4.0.0/24"], ["10.5.0.0/24"], ["10.6.0.0/24"]]

  create_vpc         = true
  create_nat_gateway = true
}

module "yandex_compute_instance" {
  source = "../../"

  zones = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]

  name                       = "example-instance-group"
  instance_group_description = "Example instance group with fixed scaling"
  instance_description       = "Ubuntu instance with nginx"

  labels = {
    environment = "test"
    project     = "demo"
    managed-by  = "terraform"
  }

  network_id         = module.network.vpc_id
  subnet_ids         = [module.network.private_subnets_ids[0], module.network.private_subnets_ids[1], module.network.private_subnets_ids[2]]
  enable_nat         = true
  security_group_ids = null

  network_acceleration_type = "STANDARD"

  scale = {
    fixed = {
      size = 3
    }
  }

  deploy_policy = {
    max_unavailable  = 1
    max_expansion    = 1
    max_deleting     = 1
    max_creating     = 1
    startup_duration = 60
    strategy         = "proactive"
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
  gpus          = 0

  preemptible = false

  image_family = "ubuntu-2004-lts"

  enable_alb_integration = true
  enable_nlb_integration = false

  hostname           = "my-instance"
  service_account_id = module.iam_accounts.id
  ssh_user           = "ubuntu"
  generate_ssh_key   = false
  ssh_pubkey         = "~/.ssh/id_rsa.pub"

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

  secondary_disks = {
    data-disk = {
      enabled     = true
      description = "Additional data disk"
      size        = 20
      type        = "network-hdd"
      mode        = "READ_WRITE"
      device_name = "data"
      zone        = "ru-central1-a"
    }
  }

  deletion_protection = false

  variables = {
    ENVIRONMENT = "test"
    PROJECT     = "demo"
  }

  depends_on = [module.iam_accounts]

  timeouts = {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

}
