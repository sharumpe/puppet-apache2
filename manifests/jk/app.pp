class apache2::jk::app
{
  concat { $apache2::params::jkAppsConfigPath :
    ensure  => present,
    notify  => $apache2::serviceNotify,
    require => Package[ $apache2::params::jkPackageName ],
  }


  concat::fragment { "${apache2::params::jkAppsConfigPath}-fragment-pre" :
    target  => $apache2::params::jkAppsConfigPath,
    order   => 01,
    content => "<IfModule mod_jk.c>\n",
  }

  concat::fragment { "${apache2::params::jkAppsConfigPath}-fragment-post" :
    target  => $apache2::params::jkAppsConfigPath,
    order   => 99,
    content => "</IfModule>\n",
  }
}

define apache2::jk::addapp
(
  $appName = $name
)
{
  include apache2::params

  validate_string( $appName )

  # Pick the template path we're going to use
  $mod_path = get_module_path('apache2')
  $specific = "${mod_path}/templates/${::operatingsystem}/${::operatingsystemrelease}${apache2::params::jkAppsConfigPath}-app-frag.erb"
  $default  = "${mod_path}/templates/default${apache2::params::jkAppsConfigPath}-app-frag.erb"

  # write the config file
  concat::fragment { $appName :
    target  => $apache2::params::jkAppsConfigPath,
    order   => 10,
    content => inline_template( file( $specific, $default ) ),
  }

}
