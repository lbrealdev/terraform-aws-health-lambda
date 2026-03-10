# Modules

mod tf 'terraform/tf.just'

set dotenv-load := true

# Alias

alias t := mise-tools

# Check current AWS identity
@aws-check:
    aws sts get-caller-identity

# List mise tools installed in current directory
@mise-tools:
    mise ls --json | jq -r --arg pwd "$(pwd)" 'to_entries[] | select(.value[].source.path != null and (.value[].source.path | contains($pwd))) | .key'
