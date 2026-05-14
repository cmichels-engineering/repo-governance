locals {
  org_ruleset = {
    name                   = "Org Public Repos Baseline"
    target                 = "branch"
    enforcement            = "active"
    required_status_checks = ["validate"]
  }

  policy_tiers = {
    public_tooling = {
      has_issues             = true
      has_projects           = false
      has_wiki               = false
      allow_squash_merge     = true
      allow_merge_commit     = false
      allow_rebase_merge     = false
      allow_auto_merge       = true
      delete_branch_on_merge = true

      branch_pattern                   = "dev"
      required_status_checks           = ["validate"]
      strict_status_checks             = true
      enforce_admins                   = true
      required_approving_review_count  = 1
      require_code_owner_reviews       = true
      dismiss_stale_reviews            = true
      required_conversation_resolution = true
      allow_force_pushes               = false
      allow_deletions                  = false
    }
  }

  repos = {
    for name, tier in var.repo_tiers : name => {
      tier     = tier
      metadata = var.repo_metadata[name]
      policy   = local.policy_tiers[tier]
    }
  }
}
