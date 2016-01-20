# == Class database_schema::phinx
#
# Ensures phinx is installed from the package repository.
# 
# === Parameters
#
# [*ensure*]
#   package version (latest, present, specific version, absent)
#
class database_schema::phinx (
  $ensure = latest,
) {

  package { 'phinx':
    ensure => $ensure
  }

  Class['database_schema::phinx'] -> Database_schema::Phinx_migration<||>
}
