# Class: xinetd
#
# This module manages xinetd
#
# Sample Usage:
#   xinetd::service { 'rsync':
#     port        => '873',
#     server      => '/usr/bin/rsync',
#     server_args => '--daemon --config /etc/rsync.conf',
#  }
#
class xinetd (
  $xinetd::hasstatus = $xinetd::params::hasstatus
) inherits xinetd::params {

  package { 'xinetd': }

  file { '/etc/xinetd.conf':
    source => 'puppet:///modules/xinetd/xinetd.conf',
  }

  service { 'xinetd':
    ensure    => running,
    enable    => true,
    hasstatus => $xinetd::hasstatus,
    restart   => '/etc/init.d/xinetd reload',
    require   => [ Package['xinetd'],
                  File['/etc/xinetd.conf'] ],
  }
}
