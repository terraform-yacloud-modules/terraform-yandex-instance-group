resource "yandex_compute_disk" "main" {
  for_each = {
    for k, v in var.secondary_disks : k => v if v["enabled"]
  }

  name        = format("%s-%s", var.name, each.key)
  folder_id   = local.folder_id
  description = each.value["description"]
  labels      = merge(var.labels, each.value["labels"])

  zone       = each.value["zone"]
  size       = each.value["size"]
  block_size = each.value["block_size"]
  type       = each.value["type"]

  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]
    content {
      create = try(timeouts.value.create, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }

}
