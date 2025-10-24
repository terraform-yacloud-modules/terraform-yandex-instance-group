output "instance_group_id" {
  description = "ID of the created instance group"
  value       = yandex_compute_instance_group.vm_group.id
}

output "instance_group_name" {
  description = "Name of the created instance group"
  value       = yandex_compute_instance_group.vm_group.name
}

output "instance_count" {
  description = "Number of instances in the group"
  value       = 3  # Fixed scale size from the configuration
}

output "network_id" {
  description = "ID of the created network"
  value       = yandex_vpc_network.vm_network.id
}

output "subnet_id" {
  description = "ID of the created subnet"
  value       = yandex_vpc_subnet.vm_subnet.id
}

output "service_account_id" {
  description = "ID of the service account"
  value       = yandex_iam_service_account.vm_sa.id
}

output "instances_external_ips" {
  description = "External IP addresses of the instances"
  value       = yandex_compute_instance_group.vm_group.instances[*].network_interface[0].nat_ip_address
}