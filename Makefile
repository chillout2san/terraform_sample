plan-dev:
	cd terraform/development && terraform plan

plan-prd:
	cd terraform/production && terraform plan

apply-dev:
	cd terraform/development && terraform apply

apply-prd:
	cd terraform/production && terraform apply

plan-destroy-dev:
	cd terraform/development && terraform plan -destroy

plan-destroy-prd:
	cd terraform/production && terraform plan -destroy

plan-destroy:
	cd terraform/development && terraform plan -destroy
	cd terraform/production && terraform plan -destroy

destroy:
	cd terraform/development && terraform destroy
	cd terraform/production && terraform destroy