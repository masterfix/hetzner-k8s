
variable "hcloud_token" {
  type        = string
  description = "Your Hetzner cloud api token (create it in the web ui)"
}

variable "ssh_keys" {
  type        = map(string)
  description = "SSH public keys for user 'core' and to register on Hetzner Cloud"
}

variable "cluster_name" {
  type        = string
  default     = "cluster1"
  description = "Cluster name used as prefix for the machine names"
}

variable "datacenter" {
  type        = string
  default     = "nbg1-dc3"
  description = "The datacenter to deploy in"
}

variable "server_type" {
  type        = string
  default     = "cx11"
  description = "The server type to create"
}

variable "machines" {
  type        = list(string)
  description = "Machine names (hostnames)"
}
