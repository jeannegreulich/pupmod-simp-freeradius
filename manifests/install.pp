# Class freeradius::install
#
# == Authors
#
# * Trevor Vaughan <tvaughan@onyxpoint.com>
# * Nick Markowski <nmarkowski@keywcorp.com>
#
class freeradius::install {
  assert_private()

  group { $freeradius::group :
    ensure => 'present',
    gid    => $freeradius::gid
  }

  user { $freeradius::user:
    ensure    => 'present',
    uid       => $freeradius::uid,
    gid       => $freeradius::group,
    allowdupe => false,
    shell     => '/sbin/nologin',
    home      => '/var/run/radiusd',
    require   => Group[$freeradius::group]
  }

  package { [$::freeradius::freeradius_name,
            "${::freeradius::freeradius_name}-ldap",
            "${::freeradius::freeradius_name}-utils"]:
    ensure  => $::freeradius::package_ensure,
    require => User['radiusd']
  }

}
