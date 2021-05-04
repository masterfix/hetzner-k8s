
resource "hcloud_ssh_key" "machine-keys" {
  for_each   = var.ssh_keys
  name       = each.key
  public_key = each.value
}

resource "hcloud_server" "machines" {
  for_each = toset(var.machines)
  name     = "${var.cluster_name}-${each.key}"
  ssh_keys = [for key in hcloud_ssh_key.machine-keys : key.id]
  # boot into rescue OS
  rescue = "linux64"
  # dummy value for the OS because Flatcar is not available
  image       = "debian-10"
  server_type = var.server_type
  datacenter  = var.datacenter
  connection {
    host    = self.ipv4_address
    timeout = "1m"
  }
  provisioner "file" {
    content     = data.ct_config.machine-ignition.rendered
    destination = "/root/ignition.json"
  }
  provisioner "remote-exec" {
    inline = [
      "set -ex",
      "curl -fsSLO --retry-delay 1 --retry 60 --retry-connrefused --retry-max-time 60 --connect-timeout 20 https://raw.githubusercontent.com/kinvolk/init/flatcar-master/bin/flatcar-install",
      "chmod +x flatcar-install",
      "./flatcar-install -s -i /root/ignition.json",
      "shutdown -r +1",
    ]
  }
  # optional:
  provisioner "remote-exec" {
    connection {
      host    = self.ipv4_address
      timeout = "3m"
      user    = "core"
    }

    inline = [
      "sudo hostnamectl set-hostname ${self.name}",
    ]
  }
}

data "ct_config" "machine-ignition" {
  content = templatefile("${path.module}/templates/machine-ignition.tmpl.yaml", {
    ssh_keys = var.ssh_keys,
  })
}
