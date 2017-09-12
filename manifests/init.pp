File {
  owner  => root,
  group  => root,
  ignore => [ '.svn', '.git' ],
}

class apache2
(
  $loadModules          = [],
  $unloadModules        = [],
  $extraPackages        = [],
  $useDefaultModules    = true,
  $remoteIpHeader       = 'X-Forwarded-For',
  $serverSignature      = 'off',
  $serverTokens         = 'prod',
  $traceEnable          = false,
  $reloadOnChange       = false,
  $serverInfoAccessIp   = undef,
  $serverStatusAccessIp = undef
)
{
  #
  # Get our configs
  #
  include apache2::params


  validate_array( $loadModules )
  validate_array( $unloadModules )
  validate_array( $extraPackages )
  validate_bool( $useDefaultModules )
  validate_string( $remoteIpHeader )
  validate_string( $serverSignature )
  validate_string( $serverTokens )
  validate_bool( $traceEnable )
  validate_bool( $reloadOnChange )
  validate_string( $serverInfoAccessIp )
  validate_string( $serverStatusAccessIp )

  #
  # Figure out if we're doing any "ensure" stuff with the service
  #
  if ( $reloadOnChange ) {
    $serviceNotify = Service[ $apache2::params::serviceName ]
  }
  else {
    $serviceNotify = []
  }


  #
  # Package and Service
  #
  package { $apache2::params::packageName :
    ensure => latest,
  }

  service { $apache2::params::serviceName :
    ensure   => running,
    enable   => true,
    require  => Package[ $apache2::params::packageName ],
    provider => systemd,
  }


  #
  # Add whatever extra packages were asked for
  #
  if ( is_array( $extraPackages ) ) {
    ensure_resource( 'package', $extraPackages, { ensure => latest } )
  }


  #
  # Make the log dir readable
  #
  file { '/var/log/apache2' :
    ensure  => directory,
    mode    => 'a+rx',
    require => Package[ $apache2::params::packageName ],
  }


  #
  # Give the ability to add special access to locations
  #
  include apache2::access


  #
  # Set serverSignature and serverTokens
  #
  class { 'apache2::sysconfig' :
    serverSignature => $serverSignature,
    serverTokens    => $serverTokens,
  }


  #
  # Default Modules
  # See apache2::params::a2modDefaults for default module list
  # Other modules are turned on in their configuration definitions
  #
  if ( is_array( $loadModules ) ) { $a2modLoad = $loadModules }
  else { $a2modLoad = [] }

  if ( is_array( $unloadModules ) ) { $a2modUnload = $unloadModules }
  else { $a2modUnload = [] }

  if ( is_bool( $useDefaultModules ) and $useDefaultModules ) { $a2modDefaultLoad = $apache2::params::a2modDefaults }
  else { $a2modDefaultLoad = [] }

  class { 'apache2::modules':
    modules => difference( union( $a2modLoad, $a2modDefaultLoad ), $a2modUnload )
  }


  #
  # Turn TraceEnable off
  #
  apache2::traceenable { 'class_default' :
    enable  => $traceEnable,
    require => Package[ $apache2::params::packageName ],
  }


  #
  # Turn on remoteIpHeader logging
  #
  apache2::remoteip { 'class_default' :
    remoteIpHeader => $remoteIpHeader,
  }


  #
  # Defaults for server-info and server-status
  #
  class { 'apache2::statusandinfo' :
    serverInfoAccessIp   => $serverInfoAccessIp,
    serverStatusAccessIp => $serverStatusAccessIp,
  }

}
