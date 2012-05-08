# Definition: xinetd::service
#
# sets up a xinetd service
# all parameters match up with xinetd.conf(5) man page
#
# Parameters:
#   $cps            - optional
#   $flags          - optional
#   $per_source     - optional
#   $port           - required - determines the service port
#   $server         - required - determines the program to execute for this service
#   $server_args    - optional
#   $disable        - optional - defaults to "no"
#   $socket_type    - optional - defaults to "stream"
#   $protocol       - optional - defaults to "tcp"
#   $user           - optional - defaults to "root"
#   $group          - optional - defaults to "root"
#   $groups         - optional - defaults to "yes"
#   $instances      - optional - defaults to "UNLIMITED"
#   $log_on_failure - optional
#   $only_from      - optional
#   $wait           - optional - based on $protocol will default to "yes" for udp and "no" for tcp
#   $xtype          - optional - determines the "type" of service, see xinetd.conf(5)
#   $no_access      - optional
#   $access_times   - optional
#   $log_type       - optional
#   $bind           - optional
#
# Actions:
#   setups up a xinetd service by creating a file in /etc/xinetd.d/
#
# Requires:
#   $server must be set
#   $port must be set
#
# Sample Usage:
#   # setup tftp service
#   xinetd::service {"tftp":
#       port        => "69",
#       server      => "/usr/sbin/in.tftpd",
#       server_args => "-s $base",
#       socket_type => "dgram",
#       protocol    => "udp",
#       cps         => "100 2",
#       flags       => "IPv4",
#       per_source  => "11",
#   } # xinetd::service
#
define xinetd::service (
  $port,
  $server,
  $ensure         = present,
  $service_name   = $title,
  $cps            = undef,
  $disable        = "no",
  $flags          = undef,
  $group          = "root",
  $groups         = "yes",
  $instances      = "UNLIMITED",
  $log_on_failure = undef,
  $per_source     = undef,
  $protocol       = "tcp",
  $server_args    = undef,
  $socket_type    = "stream",
  $user           = "root",
  $only_from      = undef,
  $wait           = undef,
  $xtype          = undef,
  $no_access      = undef,
  $access_times   = undef,
  $log_type       = undef,
  $bind           = undef
) {
  include xinetd
  include xinetd::params

  if $wait {
    $wait_real = $wait
  } else {
    case $protocol {
      'tcp':   { $wait_real = 'no'  }
      'udp':   { $wait_real = 'yes' }
      default: { fail('wait not set, unable to determine sane default') }
    }
  }

  file { "${xinetd::params::xinetd_confdir}/${title}":
    ensure  => $ensure,
    owner   => 'root',
    mode    => '0644',
    content => template('xinetd/service.erb'),
    notify  => Service[$xinetd::params::xinetd_service],
    require => File[$xinetd::params::xinetd_confdir],
  }

}
