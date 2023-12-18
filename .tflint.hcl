plugin "terraform" {
  enabled = true
  preset  = "all"
}

plugin "aws" {
  enabled = true
  version = "0.26.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

plugin "opa" {
  enabled = true
  version = "0.3.0"
  source  = "github.com/terraform-linters/tflint-ruleset-opa"
}

config {
  #Enables module inspection
  module = true
  force = false
}

// rule "aws_instance_invalid_type" { enabled = true }
// rule "aws_resource_missing_tags" {
//  enabled = true
//  tags    = ["OPEX", "Ticket"]
//  exclude = ["aws_autoscaling_group"] # (Optional) Exclude some resource types from tag checks
// }
