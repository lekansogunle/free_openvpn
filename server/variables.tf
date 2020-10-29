variable "server_region" {
  description = "Region to deploy server"
  type        = string
  default     = "eu-central-1"
}

variable "server_name" {
  description = "Name of free VPN server"
  type        = string
  default     = "openvpn"
}

variable "server_username" {
  description = "Admin Username to access server"
  type        = string
  default     = "openvpn"
}

variable "server_password" {
  description = "Admin Password to access server"
  type        = string
  default     = "password"
}