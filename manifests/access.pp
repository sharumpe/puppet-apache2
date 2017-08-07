class apache2::access {
  include apache2::params

  #
  # Create the file we're storing these in
  #
  concat { $apache2::params::accessConfigPath :
    ensure => present,
    notify => $apache2::serviceNotify,
  }
}

define apache2::grantaccesstohost
(
  $location,
  $host
)
{
  include apache2::params

  validate_string( $location )
  validate_string( $host )

  concat::fragment { "${location}_${host}" :
    target  => $apache2::params::accessConfigPath,
    order   => 10,
    content => template( "apache2/default${apache2::params::accessConfigPath}-grantToHost-frag.erb" ),
  }
}

define apache2::grantaccesstoip
(
  $location,
  $ip
)
{
  include apache2::params

  validate_string( $location )
  validate_string( $ip )

  if ( is_ip_address( $ip ) ) {
    concat::fragment { "${location}_${ip}" :
      target  => $apache2::params::accessConfigPath,
      order   => 10,
      content => template( "apache2/default${apache2::params::accessConfigPath}-grantToIp-frag.erb" ),
    }
  }
}
