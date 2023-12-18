package terraform 

import input.tfplan as tfplan
import input.tfrun as tfrun

redshift[r] {
    r := tfplan.resource_changes[_]
    r.type == "aws_redshift_cluster"
}

# Filter to SNS Function with violations
# Warnings will be printed for all violations since the last parameter is true

# Rule to require retention period
deny[reason] {
    r := redshift[_]
    r.change.after.automated_snapshot_retention_period == 0
    reason := sprintf(
        "%s: requires retention period",
        [r.address]
    )
}

deny[reason] {
    r := redshift[_]
    r.change.after.encrypted == false
    reason := sprintf(
        "%s: requires retention encrypt",
        [r.address]
    )
}

# Rule to require skip destroy config
deny[reason] {
    r := redshift[_]
    count(r.change.after.iam_roles) == 0
    reason := sprintf(
        "%s: requires iam roles",
        [r.address]
    )
}