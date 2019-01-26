# == Class: freeradius::conf::modules
#
# Manage the 'modules' section of radiusd.conf.
#
# You can only call this *once* within a node scope. If you try to call it more
# than once, it will fail your manifest compilation due to conflicting
# resources.
#
# See /etc/raddb/radiusd.conf.sample for additional information.
#
# == Parameters
#
# [*include_eap*]
#   Include eap.conf
#
# [*include_sql*]
#   The SQL related configuration
#
# [*include_mysql_counter*]
#   Active the mysql counter module.
#   Implies $include_sql
#
# [*include_sqlippool*]
#   Manage IP addresses in an SQL table.
#   Implies $include_sql
#
# == Authors
#
# * Trevor Vaughan <tvaughan@onyxpoint.com>
#
class freeradius::conf::modules (
  Boolean   $include_eap           = true,
  Boolean   $include_sql           = false,
  Boolean   $include_mysql_counter = false,
  Boolean   $include_sqlippool     = false
) {

  include '::freeradius'

  if $facts['os']['name'] in ['RedHat', 'CentOS'] {
    if defined('$::radius_version') and ($::radius_version != 'unknown') {
      if (versioncmp($::radius_version, '3') >= 0) {
        file { '/etc/raddb/conf/modules.inc':
          ensure  => 'file',
          owner   => 'root',
          group   => 'radiusd',
          mode    => '0640',
          content => template('freeradius/3/conf/modules.erb'),
          notify  => Service['radiusd']
        }
      }
      else {
        file { '/etc/raddb/conf/modules.inc':
          ensure  => 'file',
          owner   => 'root',
          group   => 'radiusd',
          mode    => '0640',
          content => template('freeradius/2/conf/modules.erb'),
          notify  => Service['radiusd']
        }
      }
    }
    else {
      warning('FreeRADIUS does not yet appear to be installed. Please install FreeRADIUS and then continue.')
    }
  }
  else {
    warning("${facts['os']['name']} not yet supported. Current options are RedHat and CentOS")
  }
}
