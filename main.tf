locals {
  ip_configuration = {
    ipv4_enabled        = true
    require_ssl         = true
    authorized_networks = "${var.management_ip_list}"
  }

  common_settings = {
    disk_type        = "${var.disk_type}"
    tier             = "${var.tier}"
    ip_configuration = ["${local.ip_configuration}"]

    maintenance_window = [{
      day          = 1
      hour         = 10
      update_track = "stable"
    }]

    user_labels {
      name = "${var.name}"
      type = "master"
    }
  }

  mysql_specific_settings = {
    backup_configuration = [{
      enabled            = true
      start_time         = "09:00"
      binary_log_enabled = true
    }]
  }

  postgres_specific_settings = {
    availability_type = "${var.availability_type}"

    backup_configuration = [{
      enabled    = true
      start_time = "09:00"
    }]
  }

  all_settings = {
    mysql    = "${merge(local.common_settings, local.mysql_specific_settings)}"
    postgres = "${merge(local.common_settings, local.postgres_specific_settings)}"
  }

  is_mysql = "${var.database_version == "MYSQL_5_6" || var.database_version == "MYSQL_5_7" ? true : false}"
  settings = "${local.all_settings[local.is_mysql ? "mysql" : "postgres"]}"
}

# This does not actually work
resource "google_project_service" "serviceusage" {
  service            = "serviceusage.googleapis.com"
  disable_on_destroy = false
}

# This does not actually work
resource "google_project_service" "sqladmin" {
  service            = "sqladmin.googleapis.com"
  disable_on_destroy = false
}

resource "null_resource" "enable-apis" {
  provisioner "local-exec" {
    command = "gcloud auth activate-service-account --key-file=account.json --project=${var.project}"
  }

  provisioner "local-exec" {
    command = "gcloud services enable serviceusage.googleapis.com sqladmin.googleapis.com"
  }
}

resource "random_id" "suffix" {
  byte_length = 2
}

resource "google_sql_database_instance" "master" {
  name             = "${var.name}-${random_id.suffix.hex}"
  project          = "${var.project}"
  region           = "${var.region}"
  database_version = "${var.database_version}"
  settings         = ["${local.settings}"]

  timeouts {
    create = "20m"
    delete = "20m"
  }
}

resource "google_sql_database" "default" {
  instance = "${google_sql_database_instance.master.name}"
  name = "${var.name}"
}

resource "random_string" "root_password" {
  length = 20
  special = true
}

resource "google_sql_user" "root" {
  instance = "${google_sql_database_instance.master.name}"
  name = "root"
  password = "${random_string.root_password.result}"
}
