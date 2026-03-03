# =============================================================================
#  Terraform Hackathon Workshop
# =============================================================================

provider "google" {
  project = var.project_id
  region  = "europe-west1"
  zone    = "europe-west1-b"
}

variable "project_id" {
    description = "Your GCP Project ID"
    type        = string
    default     = "" # TODO 1: paste your Project ID here
    # Tip: use `ec-dev` project's id from https://console.cloud.google.com/cloud-resource-manager}
}

variable "team_name" {
  description = "Your team name — will appear on the deployed website"
  type        = string
  default     = "" # TODO 2: enter your team name
}

# =============================================================================
# STAGE 1: VPC Network + Subnet
# Docs: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
#       https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
# =============================================================================

# TODO 3: Create a VPC network
# Resource type: google_compute_network
# Fields to set:
#   name                    = "team-${var.team_name}-network"
#   auto_create_subnetworks = false   # we'll create the subnet manually



# TODO 4: Create a subnet inside the VPC above
# Resource type: google_compute_subnetwork
# Fields to set:
#   name          = "team-${var.team_name}-subnet"
#   ip_cidr_range = pick any private IP range, e.g. "10.0.1.0/29 must be unique across all teams!
#   region        = "europe-west1"
#   network       = <reference to the VPC network above>



# =============================================================================
# STAGE 2: Firewall Rule
# Docs: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
# =============================================================================

# TODO 5: Create a firewall rule that allows HTTP traffic
# Resource type: google_compute_firewall
# Fields to set:
#   name          = "team-${var.team_name}-allow-http"
#   network       = <reference to the VPC network>
#   allow block:
#     protocol    = which protocol does HTTP use?
#     ports       = which port does HTTP use? (as a list of strings)
#   source_ranges = allow traffic from anywhere: ["0.0.0.0/0"]
#   target_tags   = pick a tag name — only VMs with this tag will receive traffic



# =============================================================================
# STAGE 3: Virtual Machine
# Docs: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance
# =============================================================================

# TODO 6: Create a VM that serves your website
# Resource type: google_compute_instance
# Fields to set:
#   name         = "team-${var.team_name}-server"
#   machine_type = "e2-micro"
#
#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-11"
#     }
#   }
#
#   network_interface {
#     subnetwork = <reference your subnet — not the VPC directly!>
#     access_config {}   # gives the VM a public IP
#   }
#
#   tags = [<the SAME tag you used in target_tags of the firewall>]
#
#   metadata_startup_script = <<-EOF
#     #!/bin/bash
#     apt-get update
#     apt-get install -y nginx
#     echo '<html><head><style>
#       body { font-family: sans-serif; display: flex; justify-content: center;
#              align-items: center; height: 100vh; margin: 0; background: #f0f4f8; }
#       .card { background: white; padding: 3rem; border-radius: 1rem;
#               box-shadow: 0 4px 20px rgba(0,0,0,0.1); text-align: center; }
#       h1 { color: #1a73e8; } p { color: #5f6368; }
#     </style></head>
#     <body><div class="card">
#       <h1>Hello from Terraform!</h1>
#       <p>Deployed by: <strong>${var.team_name}</strong></p>
#     </div></body></html>' > /var/www/html/index.html
#     systemctl restart nginx
#   EOF
