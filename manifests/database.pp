# Configures CKAN Database Server
class ckan::database (
  # Name of the collective CKAN Node (dev/prod/test)
  $ckan_node_id,

  # Database names
  $ckan_db_name          = "ckan_${ckan_node_id}",
  $datastore_db_name     = "datastore_${ckan_node_id}",

  # Username and password for the CKAN Database
  $ckan_db_user          = "ckan_${ckan_node_id}",
  $ckan_db_password,

  # Username and password for the DATASTORE Database
  $datastore_db_user     = "datastore_${ckan_node_id}",
  $datastore_db_password,

  # Root password for the database server
  $postgres_password,

  # IP Address of the CKAN App Server
  $ckan_app_ip,

  # Database encoding
  $db_encoding           = 'utf-8'

) {
  # Postgresql installation.
  class { '::postgresql::server':
    postgres_password => "${postgres_password}",
    ipv4acls          => [
      "host ${ckan_db_name} ${ckan_db_user} ${ckan_app_ip}/32 md5",
      "host ${datastore_db_name} ${ckan_db_user} ${ckan_app_ip}/32 md5",
      "host ${datastore_db_name} ${datastore_db_user} ${ckan_app_ip}/32 md5",
    ]
  }

  # Configure ckan databases
  ::postgresql::server::db {

    # CKAN Database
    "${ckan_db_name}":
      user     => "${ckan_db_user}",
      encoding => "${db_encoding}",
      password => postgresql_password(
        "${ckan_db_user}",
        "${ckan_db_password}"
      );

    # Datastore Database
    "${datastore_db_name}":
      user     => "${datastore_db_user}",
      encoding => "${db_encoding}",
      password => postgresql_password(
        "${datastore_db_user}",
        "${datastore_db_password}"
      );
  }
}

# vim: set shiftwidth=2 softtabstop=2 textwidth=0 wrapmargin=0 syntax=ruby:

