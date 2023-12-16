package terraform
import future.keywords.in

import input as tfplan

allowed_acls = ["private"]
allowed_sse_algorithms = ["aws:kms", "AES256"]

s3_buckets[r] {
    r := tfplan.resource_changes[_]
    action := r.change.actions[count(r.change.actions) - 1]
    array_contains(["create", "update"], action)
    r.type == "aws_s3_bucket"
}

array_contains(arr, elem) {
  arr[_] = elem
}

deny[reason] {
    r := s3_buckets[_]
    not r.change.after.acl 
    reason := sprintf("%s: ACL is missing from tfplan", 
	                  [r.address])
}

deny[reason] {
	r = tfplan.resource_changes[_]
    not array_contains(allowed_acls,r.change.after.acl)
	reason := sprintf("%s: S3 buckets must not be PUBLIC", 
	                    [r.address])
}

# Rule to require server-side encryption
deny[reason] {
    r := s3_buckets[_]
    not r.change.after.server_side_encryption_configuration
    reason := sprintf(
        "%s: requires server-side encryption with expected sse_algorithm to be one of %v",
        [r.address, allowed_sse_algorithms]
    )
}

# Rule to enforce specific SSE algorithms
deny[reason] {
    r := s3_buckets[_]
    sse_configuration := r.change.after.server_side_encryption_configuration[_]
    apply_sse_by_default := sse_configuration.rule[_].apply_server_side_encryption_by_default[_]
    not array_contains(allowed_sse_algorithms, apply_sse_by_default.sse_algorithm)
    reason := sprintf(
        "%s: expected sse_algorithm to be one of %v",
        [r.address, allowed_sse_algorithms]
    )
}

# Rule to require lifecycle conf
deny[reason] {
    r := s3_buckets[_]
    not r.change.after.lifecycle_rule
    reason := sprintf(
        "%s: requires lifecycle configuration",
        [r.address]
    )
}

# Rule to require versioning enabled
deny[reason] {
    r := s3_buckets[_]
    not r.change.after.versioning
    reason := sprintf(
        "%s: requires versioning",
        [r.address]
    )
}

