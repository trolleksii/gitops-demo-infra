provider "google" {
  credentials = var.credentials == null ? null : file(var.credentials)
  project     = var.project_id
  region      = var.region
}
