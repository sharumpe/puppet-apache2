class apache2::modules
(
  $modules = []
)
{
  include apache2::params

  # List of default modules to enable
  # defined in apache2::params::a2modDefaults
  if ( is_array( $modules ) and ( size( $modules ) > 0 ) ) {
    # clear the module list
    file_line { 'clear_module_list' :
      path    => $params::sysconfigPath,
      line    => 'APACHE_MODULES=""',
      match   => '^APACHE_MODULES=',
      notify  => $apache2::serviceNotify,
      require => Package[ $params::packageName ],
    }

    # enable the modules specified
    apache2::enablemodule { $modules :
      require => File_line[ 'clear_module_list' ],
    }
  }
}

define apache2::enablemodule
{
  # Enable the module
  exec { "enable_${name}" :
    command => "/usr/sbin/a2enmod ${name}",
    unless  => "/usr/sbin/a2enmod -q ${name}",
    notify  => $apache2::serviceNotify,
    require => Package[ $params::packageName ],
    before  => Service[ $params::serviceName ],
  }
}
