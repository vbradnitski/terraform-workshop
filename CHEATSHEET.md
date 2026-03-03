# Terraform Cheat Sheet

## Core Commands

| Command | What it does |
|---------|-------------|
| `terraform init` | Initializes the project, downloads providers |
| `terraform plan` | Shows what will change (nothing is created yet!) |
| `terraform apply` | Creates/updates infrastructure |
| `terraform apply -auto-approve` | Same, without confirmation prompt |
| `terraform destroy` | **Deletes all infrastructure** |
| `terraform output` | Shows output values |

## Useful GCP Commands

```bash
# Get your Project ID
gcloud config get-value project

# List running virtual machines
gcloud compute instances list

# SSH into your VM (if needed)
gcloud compute ssh my-awesome-app --zone=europe-west1-b
```

## Terraform Syntax (HCL)

```hcl
# Comment

# Resource: what to create
resource "resource_type" "local_name" {
  argument = "value"
}

# Reference another resource
resource "google_compute_instance" "vm" {
  network = google_compute_network.vpc_network.name
  #        ^^^^^^^^^^^^^^^^^^^^^^^^ ^^^^^^^^^^^ ^^^^
  #        resource_type            local_name  attribute
}
```

## Common Errors

**Error: Invalid provider configuration**
→ Make sure you replaced `YOUR_PROJECT_ID` with your actual project ID

**Error: oauth2: "invalid_grant" "Bad Request"**
→ Cloud Shell session expired. Run:
```bash
gcloud auth application-default login
```
Then retry `terraform apply`.

**Error: googleapi: Error 403**
→ Make sure you are using Google Cloud Shell (authentication is automatic there)

**Site not loading right after `apply`**
→ Wait 1-2 minutes — the VM is starting up and installing Nginx

**Error: Error waiting for instance to create**
→ Check that the `tags` on the VM match the `target_tags` in the firewall rule
