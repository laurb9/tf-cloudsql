locals {
  failover_settings = {
    maintenance_window = [{
      day          = 1
      hour         = 10
      update_track = "stable"
    }]

    user_labels = {
      name = "${var.name}"
      type = "failover"
    }
  }
}

resource "google_sql_database_instance" "failover" {
  count                = "${var.availability_type == "REGIONAL" && local.is_mysql ? 1 : 0}"
  name                 = "${google_sql_database_instance.master.name}-failover"
  project              = "${var.project}"
  region               = "${var.region}"
  database_version     = "${var.database_version}"
  master_instance_name = "${google_sql_database_instance.master.name}"
  settings             = ["${merge(local.common_settings, local.failover_settings)}"]

  replica_configuration {
    failover_target = true
  }

  timeouts {
    create = "30m"
    delete = "30m"
  }
}
