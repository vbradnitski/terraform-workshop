# Terraform Cheat Sheet

## Core Commands

| Command | What it does |
|---------|-------------|
| `terraform init` | Initializes the project, downloads providers |
| `terraform plan` | Shows what will change (nothing is created yet!) |
| `terraform apply` | Creates/updates infrastructure |
| `terraform destroy` | **Deletes all infrastructure** |
| `terraform output` | Shows output values |

## Useful GCP Commands

```bash
# Get your Project ID
gcloud config get-value project

# List running virtual machines
gcloud compute instances list
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

**Error: oauth2: "invalid_grant" "Bad Request"**
→ Cloud Shell session expired. Run:
```bash
gcloud auth application-default login
```
Then retry `terraform apply`.
