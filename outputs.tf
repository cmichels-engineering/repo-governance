output "managed_repositories" {
  description = "Managed repositories by name"
  value       = keys(github_repository.managed)
}
