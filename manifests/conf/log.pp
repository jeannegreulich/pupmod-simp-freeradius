# == Class: freeradius::conf::log
#
# Add a 'log' section to freeradius.
#
# You can only call this *once* within a node scope. If you try to call it more
# than once, it will fail your manifest compilation due to conflicting
# resources.
#
# See /etc/raddb/radiusd.conf.sample for additional information.
#
# == Parameters
#
# [*destination*]
# [*log_file*]
# [*syslog_facility*]
# [*stripped_names*]
# [*auth*]
# [*auth_badpass*]
# [*auth_goodpass*]
# [*msg_goodpass*]
# [*msg_badpass*]
#
# == Authors
#
# * Trevor Vaughan <tvaughan@onyxpoint.com>
#
class freeradius::conf::log (
  Freeradius::LogDest    $destination     = 'syslog',
  Stdlib::AbsolutePath   $log_file        = "${::freeradius::logdir}/radius.log",
  String                 $syslog_facility = 'local6',
  Boolean                $stripped_names  = false,
  Boolean                $auth            = true,
  Boolean                $auth_badpass    = false,
  Boolean                $auth_goodpass   = false,
  Optional[String]       $msg_goodpass    = undef,
  Optional[String]       $msg_badpass     = undef
) inherits ::freeradius::config {

  validate_freeradius_destination($destination)
  #validate_bool($stripped_names)
  #validate_bool($auth)
  #validate_bool($auth_badpass)
  #validate_bool($auth_goodpass)

  file { '/etc/raddb/conf/log.inc':
    ensure  => 'file',
    owner   => 'root',
    group   => 'radiusd',
    mode    => '0640',
    content => template('freeradius/conf/log.erb'),
    notify  => Service['radiusd']
  }
}
