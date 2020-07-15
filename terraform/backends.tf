terraform {
  backend "gcs" {
    bucket = "gitops-terraform-status"
    prefix = "gitops-demo"
  }
}
