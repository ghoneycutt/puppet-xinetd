class xinetd::params
{
  $hasstatus = $::operatingsystem ? {
    'Debian' => false,
    default  => true,
  }
}
