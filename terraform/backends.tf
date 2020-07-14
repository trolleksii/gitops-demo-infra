terraform {
  backend "gcs" {
    # credentials = "credentials.json"
    bucket = "gitops-terraform-status"
    prefix = "gitops-demo"
  }
}
