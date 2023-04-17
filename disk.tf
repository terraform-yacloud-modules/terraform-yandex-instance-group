resource "yandex_compute_disk" "main" {
  for_each = {
  for k, v in var.secondary_disks : k => v if v["enabled"]
  }

  name        = format("%s-%s", var.name, each.key)
  description = each.value["description"]
  folder_id   = local.folder_id
  labels      = merge(var.labels, each.value["labels"])

  zone       = each.value["zone"]
  size       = each.value["size"]
  block_size = each.value["block_size"]
  type       = each.value["type"]
}
