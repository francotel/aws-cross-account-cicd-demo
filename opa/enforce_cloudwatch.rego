package terraform 

import input.tfplan as tfplan
import input.tfrun as tfrun

cloudwatch[r] {
    r := tfplan.resource_changes[_]
    r.type == "aws_cloudwatch_log_group"
}

# Rule to require retention_in_days
deny[reason] {
    r := cloudwatch[_]
    r.change.after.retention_in_days >= 365
    reason := sprintf(
        "%s: requires duration log days 365",
        [r.address]
    )
}

# Rule to require encryption config
deny[reason] {
    r := cloudwatch[_]
    count(r.change.after.kms_key_id) == 0
    reason := sprintf(
        "%s: requires encryption",
        [r.address]
    )
}        
# Rule to require skip destroy config
deny[reason] {
    r := cloudwatch[_]
    count(r.change.after.skip_destroy) == 0
    reason := sprintf(
        "%s: requires skip destroy",
        [r.address]
    )
}