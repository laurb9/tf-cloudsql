
output instance_name {
  value = "${google_sql_database_instance.master.name}"
}

output connection_name {
  value = "${google_sql_database_instance.master.connection_name}"
}

output instance_ip {
  value = "${google_sql_database_instance.master.first_ip_address}"
}

output read_connection_names {
  value = "${google_sql_database_instance.replica.*.connection_name}"
}

output user {
  value = "${google_sql_user.root.name}"
}

output password {
  sensitive = true
  value = "${google_sql_user.root.password}"
}
