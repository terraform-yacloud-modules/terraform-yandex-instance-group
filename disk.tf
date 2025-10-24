resource "yandex_compute_disk" "main" {
  for_each = {
    for k, v in var.secondary_disks : k => v if v["enabled"]
  }

  name       = format("%s-%s", var.name, each.key)
  zone       = each.value["zone"]
  size       = each.value["size"]
  block_size = each.value["block_size"]
  type       = each.value["type"]
}
