variable "web_server_ami" {
  type    = string
  default = "ami-0ee3dd41c47751fe6"
}

variable "web_server_instance_type" {
  type    = string
  default = "t2.micro"
}


variable "region" {
  description = "The region where AWS operations will take place. Examples are us-east-1, us-west-2, etc."
  type        = string
  default     = "us-east-1"
}
