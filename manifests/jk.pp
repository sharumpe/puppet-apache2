class apache2::jk
(
  $jkLogLevel            = 'error',
  $jkWorkerHost          = 'localhost',
  $jkWorkerPort          = 8009,
  $jkWorkerRetries       = 3,
  $jkWorkerSocketTimeout = 60,
  $apps                  = []
)
{
  include apache2::params

  validate_string( $jkLogLevel )
  validate_string( $jkWorkerHost )
  validate_string( $jkWorkerPort )
  validate_string( $jkWorkerRetries )
  validate_string( $jkWorkerSocketTimeout )
  validate_array( $apps )

  # install the package
  package { $apache2::params::jkPackageName :
    ensure  => latest,
  }

  # include the module
  apache2::enablemodule{ 'jk':
    require => Package[ $apache2::params::jkPackageName ],
  }
  # Pick the template path we're going to use

  $mod_path = get_module_path('apache2')
  $specific = "${mod_path}/templates/${::operatingsystem}/${::operatingsystemrelease}${apache2::params::jkConfigPath}.erb"
  $default  = "${mod_path}/templates/default${apache2::params::jkConfigPath}.erb"

  # write the config file
  file { $apache2::params::jkConfigPath :
    ensure  => file,
    content => inline_template( file( $specific, $default ) ),
    notify  => $apache2::serviceNotify,
    require => Package[ $apache2::params::jkPackageName ],
  }

  # if any apps were specified, create them
  class { 'apache2::jk::app' : }
  if ( is_array( $apps ) and size( $apps ) > 0 ) {
    apache2::jk::addApp{ $apps : }
  }
}
