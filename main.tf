terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.27.1"
    }
  }
}

variable "do_token" {
    default = ""
}

variable "region" {
  default = ""
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_kubernetes_cluster" "k8s" {
  name   = "k8s"
  region = var.region
  version = "1.26.3-do.0"

  node_pool {
    name       = "k8s-elite"
    size       = "s-2vcpu-2gb"
    node_count = 2
  }
}

resource "local_file" "kubeconfig" {
  content  = digitalocean_kubernetes_cluster.k8s.kube_config.0.raw_config
  filename = "kubeconfig.yaml"
}