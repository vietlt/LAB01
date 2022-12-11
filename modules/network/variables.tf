variable "public_ip" {
  type = list(any)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "cidr_block" {
  type = list(any)
  default = ["10.0.0.0/16"]
}
