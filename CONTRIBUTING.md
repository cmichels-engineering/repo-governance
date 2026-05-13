# Contributing

## Workflow

- Branch from `dev` using `feature/*` or `bug/*` naming.
- Keep changes scoped and policy-driven.
- Run validation locally before opening a PR.

## Local Validation

```bash
make fmt
make validate
```

## Guardrails

- Do not commit secrets, tokens, or local tfvars with credentials.
- Keep policy changes explicit and documented.
- Prefer tier-level changes over one-off repository exceptions.
