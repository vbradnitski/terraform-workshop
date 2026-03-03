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
    │  (inside a VPC Network)
    ▼
"Hello from Team [Your Team]!"
```

**3 resources = 1 working website.**

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
| `main.tf` | **Your task** — contains 4 places to fill in |
| `outputs.tf` | Ready — prints your website URL after `apply` |
| `versions.tf` | Ready — specifies Terraform and provider versions |
| `CHEATSHEET.md` | Command reference and common errors |

---

## Step 3: Complete the TODOs in main.tf

Open `main.tf` and find all `TODO` comments. There are 4:

### TODO 1 — Set Your Project ID

Find your Project ID:
```bash
gcloud config get-value project
```

Replace `YOUR_PROJECT_ID` with your actual project ID.

### TODO 2 — Set the HTTP Port

In the `google_compute_firewall` block, replace `"WHICH_PORT"` with the correct port.

<details>
<summary>Hint (click if you're stuck)</summary>
HTTP runs on port <code>80</code>
</details>

### TODO 3 — Add a Tag to the VM

The firewall rule only applies to machines that have a specific tag (`target_tags`). Check which tag is set in `google_compute_firewall` and use the same tag in `tags` for the virtual machine.

### TODO 4 — Enter Your Team Name

In `metadata_startup_script`, replace `Your Team Name` with your team's name. This name will appear on the website!

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

Terraform will show what it **plans** to create (nothing is created yet!). You should see `3 to add`.

---

## Step 6: Create the Infrastructure!

```bash
terraform apply
```

Terraform will ask for confirmation — type `yes`.

Wait 1-2 minutes. When done, you'll see:

```
Apply complete! Resources: 3 added.

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

Type `yes`. Terraform will delete all 3 resources in seconds.

**This is the magic of Infrastructure as Code:** creating and destroying infrastructure is as simple as running a single command.

---

## Bonus Challenges (if you have time)

1. **Change the HTML**: Update the text in `metadata_startup_script`, then run `terraform apply` again. What happened?

2. **Add a second tag**: Add another tag to the VM's `tags` — `["web-server", "hackathon"]` — and run `terraform plan`. How many resources will change?

3. **Explore the state**: Run `cat terraform.tfstate` — this is the file Terraform uses to track information about created resources.

---

## Need Help?

- Check `CHEATSHEET.md` — it covers common errors and how to fix them
- Terraform documentation: https://registry.terraform.io/providers/hashicorp/google/latest/docs
