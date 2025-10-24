variable "folder_id" {
  description = "Folder ID where the instance group will be created"
  type        = string
  default     = null
}

variable "zones" {
  description = "A list of availability zones"
  type        = list(string)
  default     = []
}

variable "name" {
  description = "Name which will be used for all resources"
  type        = string
}

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

variable "platform_id" {
  description = "Hardware CPU platform name"
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

variable "image_id" {
  description = "Image ID"
  type        = string
  default     = null
}

variable "service_account_id" {
  description = "ID of the service account authorized for instance"
  type        = string
  default     = null
}

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
    description = optional(string, "")
    zone        = optional(string, null)
    size        = optional(number, 10)
    block_size  = optional(number, 4096)
    type        = optional(string, "network-hdd")
    mode        = optional(string, "READ_WRITE")
    device_name = optional(string, "data")
  }))
  default = {}
}
