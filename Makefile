AWS_PROFILE ?= default
ENTRYPOINT ?=
TERRAFORM_VERSION ?= latest
TERRAFORM_BIN = docker run -it --rm -v ~/.aws:/root/.aws:ro -v $(shell pwd):/app -e AWS_PROFILE -w /app $(ENTRYPOINT) hashicorp/terraform:${TERRAFORM_VERSION}

init:
	$(TERRAFORM_BIN) init

shell: ENTRYPOINT=--entrypoint sh
shell:
	$(TERRAFORM_BIN)

show: fmt 
	$(TERRAFORM_BIN) show

fmt:
	$(TERRAFORM_BIN) fmt

validate: fmt 
	$(TERRAFORM_BIN) validate

plan: fmt 
	$(TERRAFORM_BIN) plan

apply: fmt 
	$(TERRAFORM_BIN) apply

apply-%: fmt 
	$(TERRAFORM_BIN) apply -target=$(*)

output: fmt 
	$(TERRAFORM_BIN) output

destroy: fmt 
	$(TERRAFORM_BIN) destroy

import: 
	$(TERRAFORM_BIN) import $(resource) $(id)

console: fmt workspace
	$(TERRAFORM_BIN) console
