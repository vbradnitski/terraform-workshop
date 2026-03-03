# Terraform Hackathon: Deploy a Website on GCP in 45 Minutes

Welcome! Over the next 45 minutes you'll deploy real cloud infrastructure on Google Cloud Platform using Terraform and see your website live on the internet.

## What We'll Build

```
Internet
    │
    ▼
[Firewall Rule]  ← allows traffic on port 80
    │
    ▼
[Compute Engine VM]  ← virtual machine running Nginx
    │  (inside a VPC Network + Subnet)
    ▼
"Hello from Team [Your Team]!"
```

**4 resources = 1 working website.**

---

## Prerequisites (local setup only)

If you're using **Google Cloud Shell** — skip this section, everything is already installed there.

If you want to work **locally on macOS**, install the following:

### Install Google Cloud CLI

```bash
brew install --cask google-cloud-sdk
```

Then authenticate:
```bash
gcloud init
gcloud auth application-default login
```

### Install Terraform

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

Verify both are installed:
```bash
gcloud version
terraform version
```

---

## Step 0: Open Google Cloud Shell

Go to: **https://shell.cloud.google.com**

> Google Cloud Shell is a terminal right in your browser. Terraform is already installed and you're already authenticated with GCP. No additional setup needed!

Verify Terraform is working:
```bash
terraform version
```

---

## Step 1: Clone the Repository

```bash
git clone https://github.com/vbradnitski/terraform-workshop.git
cd terraform-workshop
```

Open the file editor:
```bash
cloudshell edit main.tf
```

---

## Step 2: Explore the Project Structure

| File | Description |
|------|-------------|
| `main.tf` | **Your task** — complete the 5 TODOs here |
| `outputs.tf` | Ready — prints your website URL after `apply` |
| `versions.tf` | Ready — specifies Terraform and provider versions |
| `CHEATSHEET.md` | Command reference and common errors |

---

## Step 3: Complete the TODOs in main.tf

Open `main.tf` — there are 5 TODOs split across 3 stages.

### TODO 1 & 2 — Set your Project ID and team name

Find your Project ID:
```bash
gcloud config get-value project
```

Fill in both variables at the top of `main.tf`.

---

### Stage 1 — VPC Network + Subnet (TODO 3 & 4)

Write both the VPC network and a subnet inside it.
Key things to figure out:
- what `auto_create_subnetworks = false` means and why
- what IP range to use for the subnet
- how to reference one resource from another

📖 [google_compute_network docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network)
📖 [google_compute_subnetwork docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork)

---

### Stage 2 — Firewall Rule (TODO 5)

Write a firewall rule that allows HTTP traffic to reach your VM.
Key things to figure out:
- which protocol and port HTTP uses
- what `target_tags` does, and what value to pick

📖 [google_compute_firewall docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall)

---

### Stage 3 — Virtual Machine (TODO 6)

Write the VM resource. The startup script is provided in the comments — copy it in.
Key things to figure out:
- how to connect the VM to your subnet (not the VPC directly)
- how tags connect the VM to the firewall rule

📖 [google_compute_instance docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance)

---

## Step 4: Initialize Terraform

```bash
terraform init
```

Terraform will download the Google Cloud provider. You should see:
```
Terraform has been successfully initialized!
```

---

## Step 5: Review the Plan

```bash
terraform plan
```

Terraform will show what it **plans** to create (nothing is created yet!). You should see `4 to add`.

---

## Step 6: Create the Infrastructure!

```bash
terraform apply
```

Terraform will ask for confirmation — type `yes`.

Wait 1-2 minutes. When done, you'll see:

```
Apply complete! Resources: 4 added.

Outputs:

website_url = "http://xx.xx.xx.xx"
```

---

## Step 7: Open Your Website!

Copy the `website_url` from the output and open it in your browser.

> If the site doesn't load immediately — wait another 1-2 minutes. The machine just started and is installing Nginx.

You can also check the URL at any time:
```bash
terraform output website_url
```

---

## Step 8: Destroy the Infrastructure

This is an important step — it ensures you don't get charged for cloud resources after the hackathon!

```bash
terraform destroy
```

Type `yes`. Terraform will delete all 4 resources in seconds.

**This is the magic of Infrastructure as Code:** creating and destroying infrastructure is as simple as running a single command.

---

## Bonus Challenges (if you have time)

1. **Change the HTML**: Update the text in `metadata_startup_script`, then run `terraform apply` again. What happened?

2. **Add a second firewall rule**: Allow SSH traffic (port 22) so you can connect to the VM directly. Write a new `google_compute_firewall` resource.

3. **Explore the state**: Run `cat terraform.tfstate` — this is the file Terraform uses to track information about created resources.

---

## Need Help?

- Check `CHEATSHEET.md` — it covers common errors and how to fix them
- Terraform documentation: https://registry.terraform.io/providers/hashicorp/google/latest/docs
