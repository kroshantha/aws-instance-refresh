variable "target_group" {
  type    = string
  default = "activesg-tg"
}
variable "load_balancer" {
  type    = string
  default = "activesg-lb"
}

variable "port" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "security_groups" {
}

variable "subnets" {
}