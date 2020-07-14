resource "google_cloud_run_service" "default" {
  name     = var.app_name
  location = var.region

  template {
    spec {
      containers {
        image = "${var.image_name}:${var.image_tag}"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}


data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.default.location
  project  = google_cloud_run_service.default.project
  service  = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

output "status" {
  value = "${google_cloud_run_service.default.status}"
}
