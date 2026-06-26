config {
  module = true
  force  = false
}

plugin "aws" {
  enabled = true
  version = "0.21.2"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

# Ensure all variables have descriptions
rule "terraform_documented_variables" {
  enabled = true
}

# Ensure all outputs have descriptions
rule "terraform_documented_outputs" {
  enabled = true
}

# Ensure modules have a source pin
rule "terraform_module_pinned_source" {
  enabled = true
}

# Check for unused declarations
rule "terraform_unused_declarations" {
  enabled = true
}

# Standard naming conventions
rule "terraform_naming_convention" {
  enabled = true
}
