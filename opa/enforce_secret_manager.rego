package terraform 

import input.tfplan as tfplan
import input.tfrun as tfrun

secret[r] {
    r := tfplan.resource_changes[_]
    r.type == "aws_secretsmanager_secret"
}

secret_rotation[r] {
    r := tfplan.resource_changes[_]
    r.type == "aws_secretsmanager_secret_rotation"
}


# Rule to require waf config
deny[reason] {
    r := secret_rotation[_]
    count(r.change.after.rotation_rules) == 0
    reason := sprintf(
        "%s: requires secret rotation",
        [r.address]
    )
}

# Rule to require acm config
deny[reason] {
    r := secret[_]
    count(r.change.after.kms_key_id) == 0
    reason := sprintf(
        "%s: requires encryption",
        [r.address]
    )
}
