provider "aws" {
  region = var.region
  #profile = "terraform-user"
}

terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 3.13.2"
    }
  }

  required_version = "~> 1.0"
}