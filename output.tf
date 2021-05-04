
output "ipv4-addresses" {
  value = {
    for machine in hcloud_server.machines :
    "${var.cluster_name}-${machine.name}" => machine.ipv4_address
  }
}

output "ssh-commands" {
  value = {
    for machine in hcloud_server.machines :
    "${var.cluster_name}-${machine.name}" => "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null core@${machine.ipv4_address}"
  }
}
