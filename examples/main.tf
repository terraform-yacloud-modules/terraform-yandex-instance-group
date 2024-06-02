module "yandex_compute_instance" {
  source = "../"

  folder_id = "xxx"

  zones = ["ru-central1-a"]

  name                       = "example-instance-group"
  instance_group_description = "Example instance group"
  instance_description       = "Example instance"

  labels = {
    environment = "dev"
  }

  network_id = "xxx"
  subnet_ids = ["xxx"]
  enable_nat = true

  variables = {
    example_variable = "example_value"
  }

  scale = {
    fixed = {
      size = 2
    }
  }

  deploy_policy = {
    max_unavailable  = 1
    max_expansion    = 1
    max_deleting     = 1
    max_creating     = 1
    startup_duration = 0
    strategy         = "proactive"
  }

  enable_nlb_integration = false

  enable_alb_integration = false

  max_checking_health_duration = 10

  health_check = {
    enabled             = true
    interval            = 15
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    tcp_options = {
      port = 8080
    }
  }

  platform_id   = "standard-v3"
  cores         = 2
  memory        = 4
  core_fraction = 100

  preemptible              = false
  placement_affinity_rules = []

  image_family      = "ubuntu-2004-lts"

  generate_ssh_key = true
  ssh_user         = "ubuntu"
  ssh_pubkey       = "~/.ssh/id_magnit.pub"
  user_data        = null

  boot_disk = {
    mode        = "READ_WRITE"
    device_name = "boot"
  }

  boot_disk_initialize_params = {
    size = 10
    type = "network-hdd"
  }

  secondary_disks = {
    disk1 = {
      enabled     = true
      description = "Secondary disk 1"
      labels = {
        type = "data"
      }
      zone        = "ru-central1-a"
      size        = 20
      block_size  = 4096
      type        = "network-ssd"
      mode        = "READ_WRITE"
      device_name = "data1"
    }
  }


}
