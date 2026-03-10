# Terraform Justfile

set dotenv-path := "{{ justfile_directory() }}/.env"

# Initialize terraform (download providers, modules, and initialize backend)
@init:
    terraform init

# Create a plan and save it to a file
# Usage: just plan "-var-file=tfvars/dev.tfvars"
@plan *var:
    terraform plan -out plan -var "github_token=$GITHUB_TOKEN" {{ var }}

# Apply the saved plan
@apply:
    terraform apply plan

# Create a destroy plan and apply it
# Usage: just destroy "-var-file=tfvars/dev.tfvars"
@destroy *var:
    terraform plan -destroy -out destroy {{ var }}
    terraform apply destroy

# Format terraform files (write changes in place)
@lint:
    terraform fmt -write=true -recursive

# Validate terraform configuration
@validate:
    terraform validate

# Generate/update terraform documentation
@docs:
    terraform-docs markdown table --output-file=README.md --output-mode=replace .

# terraform recipes for manages state

# Show terraform state
@show:
    terraform show

# List terraform state resources
@list:
    terraform state list
