package terraform 

import input.tfplan as tfplan
import input.tfrun as tfrun

athena[r] {
    r := tfplan.resource_changes[_]
    r.type == "aws_athena_database"
}


# Rule to require encryption config
deny[reason] {
    r := athena[_]
    count(r.change.after.encryption_configuration) == 0
    reason := sprintf(
        "%s: requires encryption",
        [r.address]
    )
}
