locals {
  replica_settings = {
    maintenance_window = [{
      day          = 1
      hour         = 10
      update_track = "stable"
    }]

    user_labels = {
      name = "${var.name}"
      type = "replica"
    }
  }
}

resource "google_sql_database_instance" "replica" {
  count                = "${var.read_replicas}"
  name                 = "${google_sql_database_instance.master.name}-replica-${count.index}"
  project              = "${var.project}"
  region               = "${var.region}"
  database_version     = "${var.database_version}"
  master_instance_name = "${google_sql_database_instance.master.name}"

  settings = ["${merge(local.common_settings, local.replica_settings)}"]

  timeouts {
    create = "30m"
    delete = "30m"
  }
}
