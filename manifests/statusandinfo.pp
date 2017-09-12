class apache2::statusandinfo
(
  $serverInfoAccessIp = undef,
  $serverStatusAccessIp = undef
)
{
  include apache2::access

  validate_string( $serverInfoAccessIp )
  validate_string( $serverStatusAccessIp )

  # Enable the modules
  apache2::enablemodule{ 'status': }
  apache2::enablemodule{ 'info': }

  # Simply put in the default server-status and server-info files,
  # but using the new-style access control configurations.
  # This has to happen because old-style and new-style can't be
  # combined for the same <Location>, and grantaccesstoip uses
  # the new-style access control.
  file { $apache2::params::statusConfigPath :
    ensure  => present,
    source  => "puppet:///modules/apache2/default${apache2::params::statusConfigPath}",
    notify  => $apache2::serviceNotify,
    require => Package[ $apache2::params::packageName ],
  }
  file { $apache2::params::infoConfigPath :
    ensure  => present,
    source  => "puppet:///modules/apache2/default${apache2::params::infoConfigPath}",
    notify  => $apache2::serviceNotify,
    require => Package[ $apache2::params::packageName ],
  }

  # Set up access
  if ( is_ip_address( $serverInfoAccessIp ) ) {
    apache2::grantaccesstoip { 'server-info' :
      location => '/server-info',
      ip       => $serverInfoAccessIp,
    }
  }
  if ( is_ip_address( $serverInfoAccessIp ) ) {
    apache2::grantaccesstoip { 'server-status' :
      location => '/server-status',
      ip       => $serverStatusAccessIp,
    }
  }
}
