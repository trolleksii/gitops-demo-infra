resource "google_compute_network" "vm" {
  name                    = "${var.resource_prefix}-${var.app_name}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vm" {
  name                     = "${var.app_name}-${var.region}"
  ip_cidr_range            = var.subnet_cidr
  region                   = var.region
  private_ip_google_access = true
  network                  = google_compute_network.vm.self_link
}

resource "google_compute_instance" "vm" {
  name         = "${var.resource_prefix}-app-server"
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.vm.self_link
    access_config {}
  }

  metadata_startup_script = <<-EOT
    sudo apt-get update
    sudo apt-get install -y docker
  EOT

  service_account {
    email  = google_service_account.vm.email
    scopes = ["cloud-platform"]
  }
}

resource "google_service_account" "vm" {
  account_id   = "${var.resource_prefix}-vm"
  display_name = "vm Host Service Account"
}

resource "google_compute_firewall" "vm" {
  name    = "${var.resource_prefix}-vm-http"
  network = google_compute_network.vm.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_service_accounts = list(google_service_account.vm.email)
  source_ranges           = ["0.0.0.0/0"]
}
