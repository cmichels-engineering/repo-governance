resource "github_repository" "managed" {
  for_each = local.repos

  name         = each.key
  description  = each.value.metadata.description
  homepage_url = try(each.value.metadata.homepage, null)
  visibility   = try(each.value.metadata.visibility, "public")

  has_issues   = each.value.policy.has_issues
  has_projects = each.value.policy.has_projects
  has_wiki     = each.value.policy.has_wiki

  allow_squash_merge = each.value.policy.allow_squash_merge
  allow_merge_commit = each.value.policy.allow_merge_commit
  allow_rebase_merge = each.value.policy.allow_rebase_merge
  allow_auto_merge   = each.value.policy.allow_auto_merge

  delete_branch_on_merge = each.value.policy.delete_branch_on_merge

  topics = each.value.metadata.topics

  lifecycle {
    prevent_destroy = true
  }
}

resource "github_repository_vulnerability_alerts" "managed" {
  for_each = local.repos

  repository = github_repository.managed[each.key].name
}

resource "github_branch_protection" "dev" {
  for_each = local.repos

  repository_id = github_repository.managed[each.key].node_id
  pattern       = each.value.policy.branch_pattern

  required_status_checks {
    strict   = each.value.policy.strict_status_checks
    contexts = each.value.policy.required_status_checks
  }

  enforce_admins = each.value.policy.enforce_admins

  required_pull_request_reviews {
    dismiss_stale_reviews           = each.value.policy.dismiss_stale_reviews
    require_code_owner_reviews      = each.value.policy.require_code_owner_reviews
    required_approving_review_count = each.value.policy.required_approving_review_count
  }

  allows_force_pushes             = each.value.policy.allow_force_pushes
  allows_deletions                = each.value.policy.allow_deletions
  require_conversation_resolution = each.value.policy.required_conversation_resolution
}

resource "github_organization_ruleset" "public_repos_baseline" {
  name        = local.org_ruleset.name
  target      = local.org_ruleset.target
  enforcement = local.org_ruleset.enforcement

  bypass_actors {
    actor_type  = "OrganizationAdmin"
    bypass_mode = "always"
  }

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }

    repository_name {
      include = var.org_ruleset_repositories
      exclude = []
    }
  }

  rules {
    deletion         = true
    non_fast_forward = true

    pull_request {
      dismiss_stale_reviews_on_push     = true
      require_code_owner_review         = true
      require_last_push_approval        = false
      required_approving_review_count   = 1
      required_review_thread_resolution = true
    }

    required_status_checks {
      strict_required_status_checks_policy = true
      required_check {
        context = "validate"
      }
    }
  }
}
