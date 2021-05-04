
terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.26.0"
    }
    ct = {
      source  = "poseidon/ct"
      version = "0.8.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}
