package terraform 

import input.tfplan as tfplan
import input.tfrun as tfrun

lambda[r] {
    r := tfplan.resource_changes[_]
    r.type == "aws_lambda_function"
}

# Rule to require delete protection enabled 
deny[reason] {
    r := lambda[_]
    r.change.after.skip_destroy == false
    reason := sprintf(
        "%s: requires deletion_protection enabled",
        [r.address]
    )
}

# Rule to require xray config
deny[reason] {
    r := lambda[_]
    count(r.change.after.tracing_config) == 0
    reason := sprintf(
        "%s: requires trace config with xray",
        [r.address]
    )
}
