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

  private_subnets = [
    ["10.4.1.0/24"],  # ru-central1-a
    ["10.4.2.0/24"],  # ru-central1-b
    ["10.4.3.0/24"]   # ru-central1-d
  ]

  create_vpc         = true
  create_nat_gateway = true
}

module "yandex_compute_instance" {
  source = "../../"

  zones = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]
  instance_count = 3

  name = "example-instance-group"

  network_id = module.network.vpc_id
  subnet_ids = module.network.private_subnets_ids
  enable_nat = true

  service_account_id = module.iam_accounts.id

  image_id = "fd8vmcue7aajpmeo39kk" # Ubuntu 20.04 LTS

  depends_on = [module.iam_accounts]
}
