package terraform 

import input.tfplan as tfplan
import input.tfrun as tfrun

sns[r] {
    r := tfplan.resource_changes[_]
    r.type == "aws_sns_topic"
}

# Filter to SNS Function with violations
# Warnings will be printed for all violations since the last parameter is true

# Rule to require encryption config
deny[reason] {
    r := sns[_]
    count(r.change.after.kms_master_key_id) == 0
    reason := sprintf(
        "%s: requires encryption",
        [r.address]
    )
}        
# Rule to require skip destroy config
deny[reason] {
    r := sns[_]
    count(r.change.after.policy) == 0
    reason := sprintf(
        "%s: requires skip destroy",
        [r.address]
    )
}