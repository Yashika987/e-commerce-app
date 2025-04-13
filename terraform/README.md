
# 🚀 Terraform AWS EKS Infrastructure with CI/CD

This repository contains a complete infrastructure setup on **AWS** using **Terraform**, including **EKS**, **VPC**, **IAM roles (with OIDC)**, and optional **EC2 instances**. The setup supports multi-environment workflows for **Development** and **Production**, with **CI/CD integration using GitHub Actions**.

---

## 📁 Project Structure

```
terraform/
├── environments/
│   ├── Development/
│   │   ├── backend.tf
│   │   └── dev.tfvars
│   └── Production/
│       ├── backend.tf
│       └── prod.tfvars
├── vpc.tf              # VPC module config
├── eks.tf              # EKS cluster & OIDC setup
├── ec2.tf              # Optional EC2 config
├── iamrole.tf          # IAM Roles (OIDC + EKS)
├── provider.tf         # AWS provider block
├── outputs.tf          # Key outputs
├── variables.tf        # All input variables
├── install_tools.sh    # Optional bootstrap script
```

---

## 🌐 Infrastructure Components

- **VPC** (via Terraform AWS VPC module)
- **EKS Cluster** (with OIDC & IAM roles)
- **EC2** (optional)
- **IAM Roles** with GitHub OIDC provider
- **Modular & Scalable** environment-based setup
- **GitHub Actions** for secure CI/CD using OIDC

---

## 🔐 GitHub OIDC Authentication

GitHub Actions assumes an IAM Role via **OIDC provider** (no need for AWS secrets in GitHub).  
Make sure this IAM role is created in AWS:

### 📌 Trust Relationship

```json
{
  "Effect": "Allow",
  "Principal": {
    "Federated": "arn:aws:iam::<ACCOUNT_ID>:oidc-provider/token.actions.githubusercontent.com"
  },
  "Action": "sts:AssumeRoleWithWebIdentity",
  "Condition": {
    "StringEquals": {
      "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
      "token.actions.githubusercontent.com:sub": "repo:<OWNER>/<REPO>:ref:refs/heads/*"
    }
  }
}
```

---

## 🧪 Environments

| Environment | Trigger Branch         | tfvars Used         | Backend Config                     |
|-------------|------------------------|----------------------|------------------------------------|
| Development | `feature/*`, `development` | `dev.tfvars`         | `environments/Development/backend.tf` |
| Production  | `main`, `master`       | `prod.tfvars`        | `environments/Production/backend.tf` |

---

## ⚙️ CI/CD with GitHub Actions

The GitHub workflow automatically deploys or destroys infrastructure based on branch and inputs.

### ✅ Trigger Types:

- **Push** to `main`/`master` → Deploy to **Production**
- **Push** to `feature/*` or `development` → Deploy to **Development**
- **Manual Trigger** with inputs (via `workflow_dispatch`)

### 📥 Inputs via Manual Trigger:

| Input      | Type    | Description                         |
|------------|---------|-------------------------------------|
| `apply`    | boolean | Run `terraform apply` if true       |
| `destroy`  | boolean | Run `terraform destroy` if true     |
| `env`      | string  | Target environment (Development / Production) |

> ⚠️ Both `apply` and `destroy` **cannot be true** together.

---

## 📤 Outputs

After deployment, the following outputs are provided:

- EKS cluster name
- Cluster endpoint
- VPC ID and subnet IDs
- OIDC Provider ARN
- IAM role ARNs

---

## 🚀 Setup Instructions

### 1. Clone this repo

```bash
git clone https://github.com/<your-username>/<your-repo>.git
cd terraform/
```

### 2. Create and configure the OIDC IAM role in AWS

- This role will be used by GitHub Actions
- Attach policies to manage EKS, VPC, IAM, etc.

### 3. Configure `backend.tf` files for remote state (S3 + DynamoDB recommended)

Each environment (`Development` and `Production`) has its own backend config.

### 4. Add GitHub Actions workflow

The `terraform.yml` in `.github/workflows/` should handle:

- OIDC auth
- `terraform init`, `plan`, `apply`, `destroy`
- Handling `dev.tfvars` / `prod.tfvars` via `env` input

---

## 🧾 Terraform Modules Used

- [terraform-aws-modules/vpc/aws](https://github.com/terraform-aws-modules/terraform-aws-vpc)
- [terraform-aws-modules/eks/aws](https://github.com/terraform-aws-modules/terraform-aws-eks)

---

## 📌 Best Practices Followed

✅ Remote state management with locking  
✅ Separate environments with `.tfvars` files  
✅ OIDC authentication via IAM role  
✅ Secure CI/CD with manual + branch-based control  
✅ Clean modular design with reusable code

---

## 👨‍💻 Author

Built with 💻 and ☕ by Yashika Maheshwari
🔗 [LinkedIn](https://www.linkedin.com/in/yashika-maheshwari/))

---

## 📚 References

- [Terraform Docs](https://developer.hashicorp.com/terraform/docs)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [GitHub Actions OIDC](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect)
