terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.72.0"  # Укажите актуальную версию
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.1.0"   # Укажите актуальную версию
    }
  }
  required_version = ">= 1.3"
}
