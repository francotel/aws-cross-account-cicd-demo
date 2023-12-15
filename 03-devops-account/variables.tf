variable "cross_account_id" {
  type = map(string)
  default = {
    dev  = "087657543526"
    qa   = "087657543526"
    prod = "087657543526"
  }
}

variable "devops_account_id" {
  default = "087657543526"
}

variable "env" {
}