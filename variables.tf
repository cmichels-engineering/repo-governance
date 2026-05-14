variable "github_owner" {
  description = "GitHub user or org owner name"
  type        = string
}

variable "github_token" {
  description = "GitHub token with repo admin permissions"
  type        = string
  sensitive   = true
  default     = null
}

variable "repo_tiers" {
  description = "Map of repository name to policy tier"
  type        = map(string)
}

variable "repo_metadata" {
  description = "Per-repo metadata"
  type = map(object({
    description = string
    topics      = list(string)
    homepage    = optional(string)
    visibility  = optional(string, "public")
  }))
}

variable "org_ruleset_repositories" {
  description = "Repositories included in the organization baseline ruleset"
  type        = list(string)
  default     = ["pr-monitor", "claude-config", "dotconfig", "repo-governance"]
}
