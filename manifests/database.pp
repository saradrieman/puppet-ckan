# Configures CKAN Database Server
class ckan::database (
  # Name of the collective CKAN Node (dev/prod/test)
  $ckan_node_id,

  # Database names
  $ckan_db_name          = undef,
  $datastore_db_name     = undef,

  # Username and password for the CKAN Database
  $ckan_db_user          = undef,
  $ckan_db_password,

  # Username and password for the DATASTORE Database
  $datastore_db_user     = undef,
  $datastore_db_password,

  # Root password for the database server
  $postgres_password,

  # IP Address of the CKAN App Server
  $ckan_app_ip,

  # Database encoding
  $db_encoding           = 'utf-8'

) {

  # Set some saner defaults based on the node id
  if $ckan_db_name == undef {
    $ckan_db_name_real = "ckan_${ckan_node_id}"
  } else {
    $ckan_db_name_real = $ckan_db_name
  }

  if $datastore_db_name == undef {
    $datastore_db_name_real = "datastore_${ckan_node_id}"
  } else {
    $datastore_db_name_real = $datastore_db_name
  }

  if $ckan_db_user == undef {
    $ckan_db_user_real = "ckan_${ckan_node_id}"
  } else {
    $ckan_db_user_real = $ckan_db_user
  }

  if $datastore_db_user == undef {
    $datastore_db_user_real = "datastore_${ckan_node_id}"
  } else {
    $datastore_db_user_real = $datastore_db_user
  }

  # Postgresql installation.
  class { '::postgresql::server':
    postgres_password => "${postgres_password}",
    ipv4acls          => [
      "host ${ckan_db_name_real} ${ckan_db_user_real} ${ckan_app_ip}/32 md5",
      "host ${datastore_db_name_real} ${ckan_db_user_real} ${ckan_app_ip}/32 md5",
      "host ${datastore_db_name_real} ${datastore_db_user_real} ${ckan_app_ip}/32 md5",
    ]
  }

  contain '::postgresql::server'

  # Configure ckan databases
  ::postgresql::server::db {

    # CKAN Database
    "${ckan_db_name_real}":
      user     => "${ckan_db_user_real}",
      encoding => "${db_encoding}",
      password => postgresql_password(
        "${ckan_db_user_real}",
        "${ckan_db_password}"
      );

    # Datastore Database
    "${datastore_db_name_real}":
      user     => "${datastore_db_user_real}",
      encoding => "${db_encoding}",
      password => postgresql_password(
        "${datastore_db_user_real}",
        "${datastore_db_password_real}"
      );
  }
}

# vim: set shiftwidth=2 softtabstop=2 textwidth=0 wrapmargin=0 syntax=ruby:

