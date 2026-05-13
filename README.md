# repo-governance

Terraform-managed baseline governance for personal/public engineering repositories.

## What This Manages

- Repository merge hygiene defaults
- Visibility and metadata (description/topics)
- Vulnerability alerts
- Branch protection on `dev` for policy tiers

Current tier in use:

- `public_tooling`

Current managed repos:

- `pr-monitor`
- `claude-config`
- `dotconfig`

## Requirements

- Terraform `>= 1.6`
- GitHub token with repo admin permissions

Set token via environment variable (recommended):

```bash
export GITHUB_TOKEN="<token>"
```

## Setup

1. Copy example vars:

```bash
cp terraform.tfvars.example terraform.tfvars
```

2. Initialize:

```bash
make init
```

3. Import existing repositories into state:

```bash
./scripts/import-existing.sh cmichels
```

4. Validate and plan:

```bash
make plan
```

5. Apply when plan is correct:

```bash
make apply
```

## Policy Model

Policy tiers are defined in `locals.tf` and assigned per repo in `terraform.tfvars` (`repo_tiers`).

Per-repo metadata is defined in `repo_metadata`.

## Notes

- `prevent_destroy` is enabled for managed repositories.
- Secret scanning and push protection are currently enforced outside Terraform and should remain part of operational checks until brought into provider-managed resources.
