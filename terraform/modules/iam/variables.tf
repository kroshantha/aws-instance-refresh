variable "iamrole" {
  type    = string
  default = "activsg-ec2s3acess"
}

variable "iam_role_policy" {
  type    = string
  default = "activesg-s3rp"
}

variable "instance_profile" {
  type    = string
  default = "activesg-insprofile"
}