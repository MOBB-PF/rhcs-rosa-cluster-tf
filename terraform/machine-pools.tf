
resource "rhcs_machine_pool" "machine_pool" {
  for_each = var.machine_pools
  # defaults
  name         = each.value.name
  machine_type = each.value.machine_type
  cluster      = rhcs_cluster_rosa_classic.rosa_sts_cluster.id
  # bools
  autoscaling_enabled = try(each.value.autoscaling_enabled, false)
  use_spot_instances  = try(each.value.use_spot_instances, false)
  # other
  max_replicas   = try(each.value.max_replicas, null)
  max_spot_price = try(each.value.max_spot_price, null)
  min_replicas   = try(each.value.min_replicas, null)
  replicas       = try(each.value.replicas, null)
  taints         = try(each.value.taints, null)
  labels         = try(each.value.labels, null)
  depends_on = [
    resource.time_sleep.wait_for_role_propagation
  ]
}
