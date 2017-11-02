class apache2::php
(
  $phpVersion            = '5.4',
  $phpMemoryLimit        = undef,
  $phpErrorLog           = '/var/log/apache2/php-error_log',
  $phpExposePhp          = 'off',
  $phpTimezone           = 'America/Los_Angeles',
  $useDefaultPhpPackages = true,
  $loadPhpPackages       = [],
  $unloadPhpPackages     = [],
  $appDirs               = [],
  $appLocs               = [],
)
{
  include apache2::params

  #validate_re( $phpMemoryLimit, '^[0..9]+[MmGg]' )
  validate_re( $phpVersion, '^5.(4|5|6)$' )
  validate_string( $phpMemoryLimit )
  validate_string( $phpErrorLog )
  validate_re( $phpExposePhp, '^(on|off)' )
  validate_string( $phpTimezone )
  validate_bool( $useDefaultPhpPackages )
  validate_array( $loadPhpPackages )
  validate_array( $unloadPhpPackages )
  validate_array( $appDirs )
  validate_array( $appLocs )

  # If phpVersion is 5.5 or 5.6, enable the appropriate repo.
  include apache2::php::reposelect

  # include the module
  apache2::enablemodule{ 'php5':
    require  => Package[ $apache2::params::phpPackageName ],
  }

  # Default PHP-specific packages
  # See apache2::params::phpPackageDefaults for default package list
  if ( is_array( $loadPhpPackages ) ) { $phpPackageLoad = $loadPhpPackages }
  else { $phpPackageLoad = [] }

  if ( is_array( $unloadPhpPackages ) ) { $phpPackageUnload = $unloadPhpPackages }
  else { $phpPackageUnload = [] }

  if ( is_bool( $useDefaultPhpPackages ) and $useDefaultPhpPackages ) { $phpPackageDefaultLoad = $apache2::params::phpPackageDefaults }
  else { $phpPackageDefaultLoad = [] }

  # Add whatever extra packages were asked for
  apache2::php::package { $phpPackageDefaultLoad :
    ensure => latest,
  }
  apache2::php::package { $phpPackageLoad :
    ensure => latest,
  }

  # Remove whatever packages we were asked to
  apache2::php::package { $phpPackageUnload :
    ensure => purged,
  }

  # Pick the template path we're going to use
  $mod_path = get_module_path('apache2')
  $specific = "${mod_path}/templates/${::operatingsystem}/${::operatingsystemrelease}${apache2::params::phpConfigPath}.erb"
  $default  = "${mod_path}/templates/default${apache2::params::phpConfigPath}.erb"

  # write the config file
  file { $apache2::params::phpConfigPath :
    ensure  => file,
    content => inline_template( file( $specific, $default ) ),
    notify  => $apache2::serviceNotify,
    require => Package[ $apache2::params::phpPackageName ],
  }

  # if any apps were specified, create them
  class { 'apache2::php::app' : }
  if ( is_array( $appDirs ) and size( $appDirs ) > 0 ) {
    apache2::php::addappdir{ $appDirs : }
  }
  if ( is_array( $appLocs ) and size( $appLocs ) > 0 ) {
    apache2::php::addapploc{ $appLocs : }
  }

}
