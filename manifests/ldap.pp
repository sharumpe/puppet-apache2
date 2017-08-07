class apache2::ldap
(
  $ldapStatusAccessIp
)
{
  include apache2::params

  validate_string( $ldapStatusAccessIp )

  # Enable the module
  apache2::enablemodule{ 'ldap': }

  # Pick the template path we're going to use
  $mod_path = get_module_path('apache2')
  $specific = "${mod_path}/templates/${::operatingsystem}/${::operatingsystemrelease}${apache2::params::ldapConfigPath}.erb"
  $default  = "${mod_path}/templates/default${apache2::params::ldapConfigPath}.erb"

  # Simply put in the default ldap config file,
  # but using the new-style access control configurations
  file { $params::ldapConfigPath :
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    content => inline_template( file( $specific, $default ) ),
    notify  => $apache2::serviceNotify,
    require => Package[ $params::packageName ],
  }

  # Grant access to given IP
  if ( is_string( $ldapStatusAccessIp ) ) {
    apache2::grantaccesstoip { 'ldap-status' :
      location => '/ldap-status',
      ip       => $ldapStatusAccessIp,
    }
  }

}
