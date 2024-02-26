variable "launch_template" {
  type    = string
  default = "activesg-lt"
}

variable "autoscaling_group" {
  type    = string
  default = "activesg-as"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "instance_profile" {
  type    = string
  default = "activesg-insprofile"
}

variable "vpc_security_group_ids" {
}

variable "vpc_zone_identifier" {
}

variable "target_group_arns" {
}
variable "user_data" {
}