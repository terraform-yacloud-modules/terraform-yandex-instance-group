#
# yandex cloud coordinates
#
variable "folder_id" {
  description = "Folder ID"
  type        = string
  default     = null
}

variable "zones" {
  description = "A list of availability zones"
  type        = list(string)
  default     = []
}

#
# naming
#
variable "name" {
  description = "Name which will be used for all resources"
  type        = string
}

variable "instance_group_description" {
  description = "Instance group description"
  type        = string
  default     = null
}

variable "instance_description" {
  description = "Instance description"
  type        = string
  default     = null
}

variable "labels" {
  description = "A set of labels which will be applied to all resources"
  type        = map(string)
  default     = {}
}

#
# network
#
variable "network_id" {
  description = "Network ID"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "VPC Subnet IDs"
  type        = list(string)
  default     = []
}

variable "enable_nat" {
  description = "Enable public IPv4 address"
  type        = bool
  default     = false
}

variable "security_group_ids" {
  description = "Security group IDs linked to instances"
  type        = list(string)
  default     = null
}

variable "network_acceleration_type" {
  description = "Network acceleration type"
  type        = string
  default     = "STANDARD"
}

variable "serial_port_enable" {
  description = "Enable serial port on instances"
  type        = bool
  default     = false
}

#
# Instance group options
#
variable "variables" {
  description = "A set of key/value variables pairs to assign to the instance group"
  type        = map(string)
  default     = {}
}

variable "deletion_protection" {
  description = "Flag that protects the instance group from accidental deletion"
  type        = bool
  default     = false
}

variable "scale" {
  description = "Instance group scaling policy"
  type = object({
    fixed = optional(object({
      size = number
    }), null)
    auto = optional(object({
      initial_size           = number
      measurement_duration   = number
      cpu_utilization_target = string
      min_zone_size          = number
      max_size               = number
      warmup_duration        = string
      stabilization_duration = string
    }), null)

  })
  default = {
    fixed = {
      size = 1
    }
  }
}

variable "deploy_policy" {
  description = "Instance group deploy policy"
  type = object({
    max_unavailable  = number
    max_expansion    = number
    max_deleting     = optional(number)
    max_creating     = optional(number)
    startup_duration = optional(string)
    strategy         = optional(string, "proactive")
  })
  default = {
    max_unavailable = 1
    max_expansion   = 1
  }
}

variable "enable_nlb_integration" {
  description = "If true, Network load balancer integration will be created"
  type        = bool
  default     = false
}

variable "enable_alb_integration" {
  description = "If true, Application load balancer integration will be created"
  type        = bool
  default     = false
}

variable "max_checking_health_duration" {
  description = "Timeout for waiting for the VM to become healthy"
  type        = number
  default     = 10
}

variable "health_check" {
  description = "Health check configuration"
  type = object({
    enabled             = optional(bool, false)
    interval            = optional(number, 15)
    timeout             = optional(number, 10)
    healthy_threshold   = optional(number, 3)
    unhealthy_threshold = optional(number, 3)
    tcp_options = optional(object({
      port = number
    }), null)
    http_options = optional(object({
      port = number,
      path = string
    }), null)
  })
  default = {
    enabled = true
    tcp_options = {
      port = 8080
    }
  }
}


#
# VMs size
#
variable "platform_id" {
  description = "Hardware CPU platform name (Intel Ice Lake by default)"
  type        = string
  default     = "standard-v3"
}

variable "cores" {
  description = "Cores allocated to instance"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Memory allocated to instance (in Gb)"
  type        = number
  default     = 2
}

variable "core_fraction" {
  description = "Core fraction applied to instance"
  type        = number
  default     = null
}

#
# scheduling
#
variable "preemptible" {
  description = "Make instance preemptible"
  type        = bool
  default     = false
}

variable "placement_group_id" {
  description = "Placement group ID"
  type        = string
  default     = null
}

variable "placement_affinity_rules" {
  description = "List of host affinity rules"
  type = list(object({
    key   = string
    op    = string
    value = string
  }))
  default = []
}

#
# vm image
#
variable "image_snapshot_id" {
  description = <<-EOT
Image snapshot id to initialize from.
Highest priority over var.image_id
and var.image_family"
EOT
  type        = string
  default     = null
}

variable "image_id" {
  description = "Image ID (medium priority)"
  type        = string
  default     = null
}

variable "image_family" {
  description = "Default image family name (lowest priority)"
  type        = string
  default     = "ubuntu-2004-lts"
}

#
# vm options
#
variable "hostname" {
  description = "Hostname of the instance. More info: https://cloud.yandex.ru/docs/compute/concepts/network#hostname"
  type        = string
  default     = null
}

variable "service_account_id" {
  description = "ID of the service account authorized for instance"
  type        = string
  default     = null
}

variable "generate_ssh_key" {
  description = "If true, SSH key will be generated for instance group"
  type        = string
  default     = true
}

variable "ssh_user" {
  description = "Initial SSH username for instance"
  type        = string
  default     = "ubuntu"
}

variable "ssh_pubkey" {
  description = "Public RSA key path to inject"
  type        = string
  default     = null
}

variable "user_data" {
  description = "Cloud-init user-data"
  type        = string
  default     = null
}

#
# vm disks
#
variable "boot_disk" {
  description = "Basic boot disk parameters"
  type = object({
    mode        = optional(string)
    device_name = optional(string)
  })
  default = {}
}

variable "boot_disk_initialize_params" {
  description = "Additional boot disk parameters"
  type = object({
    size = optional(number, 10)
    type = optional(string, "network-hdd")
  })
  default = {}
}

variable "secondary_disks" {
  description = "Additional disks with params"
  type = map(object({
    enabled     = optional(bool, true)
    description =  optional(string, "")
    labels      = optional(map(string), {})
    zone        = optional(string, null)
    size        = optional(number, 10)
    block_size  = optional(number, 4096)
    type        = optional(string, "network-hdd")

    mode        = optional(string, "READ_WRITE")
    device_name = optional(string, "data")
  }))
  default = {}
}
