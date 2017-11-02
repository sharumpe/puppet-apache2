class apache2::php::app
{
  concat { $apache2::params::phpAppsConfigPath :
    ensure  => present,
    notify  => $apache2::serviceNotify,
    require => Package[ $apache2::params::phpPackageName ],
  }


  concat::fragment { "${apache2::params::phpAppsConfigPatha}-fragment-pre" :
    target  => $apache2::params::phpAppsConfigPath,
    order   => 01,
    content => "<IfModule mod_php5.c>\n",
  }

  concat::fragment { "${apache2::params::phpAppsConfigPath}-fragment-post" :
    target  => $apache2::params::phpAppsConfigPath,
    order   => 99,
    content => "</IfModule>\n",
  }
}

define apache2::php::addappdir
(
  $appDir = $name
)
{
  include apache2::params

  validate_string( $appDir )

  # Pick the template path we're going to use
  $mod_path = get_module_path('apache2')
  $specific = "${mod_path}/templates/${::operatingsystem}/${::operatingsystemrelease}${apache2::params::phpAppsConfigPath}-appDir-frag.erb"
  $default  = "${mod_path}/templates/default${apache2::params::phpAppsConfigPath}-appDir-frag.erb"

  # write the config file
  concat::fragment { $appDir :
    target  => $apache2::params::phpAppsConfigPath,
    order   => 10,
    content => inline_template( file( $specific, $default ) ),
  }

}

define apache2::php::addapploc
(
  $appLoc = $name
)
{
  include apache2::params

  validate_string( $appLoc )

  # Pick the template path we're going to use
  $mod_path = get_module_path('apache2')
  $specific = "${mod_path}/templates/${::operatingsystem}/${::operatingsystemrelease}${apache2::params::phpAppsConfigPath}-appLoc-frag.erb"
  $default  = "${mod_path}/templates/default${apache2::params::phpAppsConfigPath}-appLoc-frag.erb"

  # write the config file
  concat::fragment { $appLoc :
    target  => $apache2::params::phpAppsConfigPath,
    order   => 10,
    content => inline_template( file( $specific, $default ) ),
  }

}

