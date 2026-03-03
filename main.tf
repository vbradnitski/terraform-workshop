# =============================================================================
# РЕШЕНИЕ — Terraform Hackathon
# =============================================================================

provider "google" {
  project = var.project_id
  region  = "europe-west1"
  zone    = "europe-west1-b"
}

variable "project_id" {
  description = "Your GCP Project ID"
  type        = string
}

variable "team_name" {
  description = "Your team name"
  type        = string
  default     = "Dream Team"
}

resource "google_compute_network" "vpc_network" {
  name                    = "hackathon-network"
  auto_create_subnetworks = true
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80"] # TODO 2 ответ: порт 80 — стандартный HTTP
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web-server"]
}

resource "google_compute_instance" "web_server" {
  name         = "my-awesome-app"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {}
  }

  tags = ["web-server"] # TODO 3 ответ: тег совпадает с target_tags в firewall

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx

    echo '<html>
    <head><style>
      body { font-family: sans-serif; display: flex; justify-content: center;
             align-items: center; height: 100vh; margin: 0; background: #f0f4f8; }
      .card { background: white; padding: 3rem; border-radius: 1rem;
              box-shadow: 0 4px 20px rgba(0,0,0,0.1); text-align: center; }
      h1 { color: #1a73e8; } p { color: #5f6368; }
    </style></head>
    <body><div class="card">
      <h1>Hello from Terraform! 🚀</h1>
      <p>Deployed by: <strong>${var.team_name}</strong></p>
      <p>Infrastructure as Code — это просто!</p>
    </div></body></html>' > /var/www/html/index.html

    systemctl restart nginx
  EOF
}
