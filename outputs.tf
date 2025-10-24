output "instance_group_id" {
  description = "Compute instance group ID"
  value       = yandex_compute_instance_group.this.id
}

output "compute_disks" {
  description = "Secondary disk's data"
  value = {
    for name, value in var.secondary_disks :
    name => merge(
      { "device_name" = value.device_name },
      yandex_compute_disk.main[name]
    )
  }
}
