# Modules

set dotenv-load := true

mod tf 'terraform/tf.just'

# Check current AWS identity
@aws-check:
    aws sts get-caller-identity
