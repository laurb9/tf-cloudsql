module "sql" {
  source             = "../.."
  name               = "mydb"
  database_version   = "MYSQL_5_7"
  tier               = "db-f1-micro"
  availability_type  = "REGIONAL"
  read_replicas      = "1"
  management_ip_list = "${var.management_ip_list}"
}

variable "management_ip_list" {
  type = "list"

  default = [
    {
      name  = "all"
      value = "0.0.0.0/0"
    },
  ]
}
