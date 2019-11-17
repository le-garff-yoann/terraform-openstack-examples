variable "timeout" {
  type    = string
  default = "30m"
}

variable "image" {
  type    = string
  default = "debian-10-openstack-amd64"
}

variable "flavor" {
  type    = string
  default = "d1.micro"
}

variable "instances" {
  type    = list(string)
  default = [
    "web01", "web02"
  ]
}
