# == Define database_schema::phinx_migration
#
# Ensures that a directory of migration scripts are applied to a database.
#
# === Parameters
#
# [*schema_source*]
#  Require path to a source directory containing sql migration scripts. 
#  Supports puppet and file schemas.
# [*db_username*]
#  Required username to use when connecting to database.
# [*db_password*]
#  Required password to use when connecting to database.
# [*jdbc_url*]
#  Required jdbc formatted database connection string.
# [*flyway_path*]
#  Path to the flyway executable. Defaults to "/opt/flyway-3.1".
# [*target_schemas*]
#  Schemas to apply migrations to, provided as a list of schema names.
# [*ensure*]
#  Version number to migrate up to (see the migrate option "target" in the flyway docs). Defaults to "latest"
#
define database_schema::phinx_migration (
  $schema_source,
  $db_username,
  $db_password,
  $db_host        = 'localhost',
  $db_database,
  $phinx_path     = '/opt/phinx/bin/phinx',
  $ensure         = latest
){
  $title_hash   = sha1($title)
  $staging_path = "/tmp/phinx-migration-${title_hash}"
  file { $staging_path:
    ensure  => directory,
    recurse => true,
    source  => $schema_source,
    mode    => '0700',
  }

  file { "${staging_path}/phinx.yml":
    content => template('database_schema/phinx.yml.erb'),
    mode    => 0600,
  }

  exec { "Database schema migration for ${title}":
    cwd     => $staging_path,
    command => "${phinx_path} migrate",
    require => File[$staging_path],
  }

}
