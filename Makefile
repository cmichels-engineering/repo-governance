.PHONY: init plan apply fmt validate

init:
	terraform init

fmt:
	terraform fmt -recursive

validate: fmt
	terraform validate

plan: validate
	terraform plan

apply: validate
	terraform apply
