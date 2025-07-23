variable "region" {
    default = "eu-north-1"
}

variable "ami" {
  #Ami's for k8s
  default = "ami-042b4708b1d05f512"
}

variable "instance_type" {
  default = "t3.medium"
}

variable "key_name" {
  description = "Ec2 Key Pair"
  type = string
}

variable "master_count" {
  default = 1
}

variable "worker_count" {
  default = 2
}