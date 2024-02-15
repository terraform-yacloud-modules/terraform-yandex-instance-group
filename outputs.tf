output "instance_group_id" {
  description = "Compute instance group ID"
  value       = yandex_compute_instance_group.this.id
}

output "compute_disks" {
  description = "Secondary disk's data"
  value = (
    {
      for name, value in var.secondary_disks :
      name => merge(
        { "device_name" = value.device_name },
        yandex_compute_disk.main[name]
      )
    }
  )
}

output "ssh_key_pub" {
  description = "Public SSH key"
  sensitive   = true
  value       = var.generate_ssh_key ? tls_private_key.this[0].public_key_openssh : null
}

output "ssh_key_prv" {
  description = "Private SSH key"
  sensitive   = true
  value       = var.generate_ssh_key ? tls_private_key.this[0].private_key_pem : null
}

output "target_group_id" {
  description = "Target group ID"
  value       = var.enable_nlb_integration ? yandex_compute_instance_group.this.load_balancer[0].target_group_id : var.enable_alb_integration ?  yandex_compute_instance_group.this.application_load_balancer[0].target_group_id : null
}
