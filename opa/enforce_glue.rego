package terraform 

import input.tfplan as tfplan
import input.tfrun as tfrun

glue[r] {
    r := tfplan.resource_changes[_]
    r.type == "aws_glue_job"
}

glue_catalog[r] {
    r := tfplan.resource_changes[_]
    r.type == "aws_glue_data_catalog_encryption_settings"
}


# Rule to require logging config
deny[reason] {
    r := glue[_]
    count(r.change.after.default_arguments) == 0
    reason := sprintf(
        "%s: requires logging",
        [r.address]
    )
}

# Rule to require glue version
deny[reason] {
    r := glue[_]
    r.change.after.glue_version != 4
    reason := sprintf(
        "%s: requires glue version",
        [r.address]
    )
}

# Rule to require encryption config
deny[reason] {
    r := glue_catalog[_]
    count(r.change.after.encryption_at_rest) == 0
    reason := sprintf(
        "%s: requires encryption",
        [r.address]
    )
}

# Rule to require encryption config
deny[reason] {
    r := glue_catalog[_]
    count(r.change.after.connection_password_encryption) == 0
    reason := sprintf(
        "%s: requires encryption",
        [r.address]
    )
}