variable "aws_region" {
  default = "eu-west-3" # Paris
}

variable "key_name" {
  description = "Nom de la clé SSH dans AWS"
  default = "Cloud1-SSH"
}

variable "public_key_path" {
  description = "Chemin absolu vers la clé publique locale"
  type = string
}

variable "instance_count" {
	type = number
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  description = "AMI Ubuntu 20.04 LTS pour Paris (eu-west-3)"
  default = "ami-0faa5b34db2bd357f"
}