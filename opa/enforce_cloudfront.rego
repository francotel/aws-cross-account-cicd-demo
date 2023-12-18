package terraform 

import input.tfplan as tfplan
import input.tfrun as tfrun

cloudfront[r] {
    r := tfplan.resource_changes[_]
    r.type == "aws_cloudfront_distribution"
}


# Rule to require waf config
deny[reason] {
    r := cloudfront[_]
    count(r.change.after.web_acl_id) == 0
    reason := sprintf(
        "%s: requires waf id arn",
        [r.address]
    )
}

# Rule to require acm config
deny[reason] {
    r := cloudfront[_]
    count(r.change.after.acm_certificate_arn) == 0
    reason := sprintf(
        "%s: requires acm id arn",
        [r.address]
    )
}

# Rule to require looging config
deny[reason] {
    r := cloudfront[_]
    count(r.change.after.logging_config) == 0
    reason := sprintf(
        "%s: requires logging",
        [r.address]
    )
}