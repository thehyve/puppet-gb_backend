# Manage a database grant. See README.md for more details.
define postgresql::server::database_grant(
  $privilege,
  $db,
  $role,
  $psql_db          = undef,
  $psql_user        = undef,
  $connect_settings = undef,
) {
}
