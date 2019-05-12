variable "project" {
  default = ""
}

variable "region" {
  default = ""
}

variable "management_ip_list" {
  description = "List of map(name, CIDR) networks to allow access from"
  type = "list"

  default = []
}

variable "name" {
  description = "Name of CloudSQL instance to create"
}

variable "database_version" {
  description = "Database type: MYSQL_5_6, MYSQL_5_7, POSTGRES_9_6, POSTGRES_11"
}

variable "tier" {
  description = "Database tier"
  default = "db-f1-micro"
}

variable "availability_type" {
  description = "Availability type: ZONAL (no HA) or REGIONAL (HA)"
  default     = "ZONAL"
}

variable "disk_type" {
  description = "Disk type"
  default     = ""
}

variable "read_replicas" {
  description = "Number of read replicas"
  default     = "0"
}
