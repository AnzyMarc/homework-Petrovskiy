variable "yc_cloud_id" { type = string }
variable "yc_folder_id" { type = string }
variable "yc_key_file" {
  type    = string
  default = "./key.json"
}

variable "public_key_path" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
}