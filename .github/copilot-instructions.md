# Copilot / AI agent instructions for this repository

Purpose: help an AI coding agent get productive quickly in this Terraform-based repo.

Quick repo snapshot
- Repo layout (relevant paths):
  - `envirnment/`  (contains per-environment folders; note the directory name is spelled `envirnment` in this repo)
    - `dev/` — contains `main.tf`, `variable.tf`, `terraform.tfvars` (environment-specific variable values)
    - `prod/` — (same pattern)
  - `module/` — reusable Terraform modules
    - `resource-group/` — `main.tf`, `variable.tf` (module for Azure resource groups)
    - `azurerm-aks/` — `main.tf`, `variable.tf` (module for AKS clusters)

What matters most (big picture)
- This is a small Terraform project that follows the common "modules + environment overlays" pattern:
  - Modules live under `module/*` and are referenced by environment manifests under `envirnment/*`.
  - Each environment directory provides variable values via `terraform.tfvars` and may call modules via `module` blocks in `main.tf`.
- The provider appears to be Azure (module names like `azurerm-aks` and `resource-group`). Before making provider changes, locate any provider/backend configuration (not present in checked-in files). Ask if a remote state backend (Azure Storage, Terraform Cloud) is required.

Project-specific conventions and gotchas
- Directory name typo: the environments live under `envirnment/` (missing the "o"). Do not rename this directory without confirmation from maintainers/PR — many paths and scripts may depend on the current spelling.
- Module layout: each module uses `main.tf` for resources and `variable.tf` for inputs. Expect environment `main.tf` to instantiate modules. When adding module inputs/outputs, update both `variable.tf` and any environment `terraform.tfvars` files.
- Files are mostly empty scaffolds in the current workspace snapshot. Treat any missing implementation as intentional scaffolding; ask before filling in major logic.

How to run locally (agent guidance)
- Work inside an environment folder when running Terraform commands. Example (PowerShell):

```powershell
cd .\envirnment\dev
terraform init
terraform fmt -recursive
terraform validate
terraform plan -var-file=terraform.tfvars
```

- Use `-var-file=terraform.tfvars` to pick up environment-specific values. If `terraform.tfvars` is empty/absent, confirm the expected variable values with the user.
- Do not run `terraform apply` without explicit user approval or a CI gating mechanism. If you must run it for testing, run in a throwaway Azure subscription and document exact steps.

Editing/authoring patterns for AI changes
- When adding/modifying a module:
  - Update `module/<name>/variable.tf` with new inputs and document expected types/defaults.
  - Add outputs in the module and consume them in the environment `main.tf` via `module.<name>.output_name`.
  - Run `terraform fmt -recursive` and `terraform validate` in the environment folder.
- When editing an environment `main.tf`:
  - Prefer adding module invocations rather than duplicating resources.
  - Keep variable values in `terraform.tfvars` (or environment-specific encrypted storage if configured).
- If adding new files that introduce secrets or provider backend configuration, avoid committing credentials. Prefer placeholders and ask the maintainer how they manage secrets/backends.

Examples (copy/paste safe)
- Example module invocation (place inside `envirnment/dev/main.tf`):

```terraform
module "rg" {
  source = "../../module/resource-group"
  name   = var.rg_name
  tags   = var.common_tags
}
```

- Example `terraform` workflow for PR validation (recommended to mention in PR body):
  - Run `terraform init` and `terraform validate` in the target environment.
  - Run `terraform plan -var-file=terraform.tfvars` and attach the plan output (or a redact-safe summary) to the PR.

Safety and merge rules for AI agents
- Do not push changes that perform `terraform apply` or change remote state/backends without maintainer approval.
- When changing file/folder names (for example correcting `envirnment` → `environment`), open a design PR and flag potential downstream impacts. Do not perform such renames unattended.
- Preserve any existing `.github/copilot-instructions.md` content when updating. If an existing file is present, append a short changelog section instead of overwriting.

Where to look next (key files)
- `module/resource-group/main.tf` and `module/resource-group/variable.tf` — module inputs and resources for Azure resource groups.
- `module/azurerm-aks/*` — AKS module scaffolding (cluster config belongs here).
- `envirnment/dev/terraform.tfvars` — example environment values (may be empty but follow pattern).

If something is missing or ambiguous
- Ask the repo owner whether a remote Terraform backend is used and where provider credentials are stored.
- Confirm whether the `envirnment/` spelling is deliberate.
- For implementations left intentionally empty, request desired resource shapes or example values (e.g., RG names, AKS node pools).

If you want me to expand this into a CONTRIBUTING.md section or add CI validation scripts (GitHub Actions) to run `terraform fmt/validate/plan` on PRs, say the word and I will prepare a draft PR.
