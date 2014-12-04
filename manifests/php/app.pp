class apache2::php::app
{
	concat { $params::phpAppsConfigPath :
		ensure	=> present,
		notify  => $apache2::serviceNotify,
		require	=> Package[ $params::phpPackageName ],
	}


	concat::fragment { "$params::phpAppsConfigPath-fragment-pre" :
		target	=> $params::phpAppsConfigPath,
		order	=> 01,
		content	=> "<IfModule mod_php5.c>\n",
	}

	concat::fragment { "$params::phpAppsConfigPath-fragment-post" :
		target	=> $params::phpAppsConfigPath,
		order	=> 99,
		content	=> "</IfModule>\n",
	}
}

define apache2::php::addAppDir
(
	$appDir = $name
)
{
	include apache2::params

	validate_string( $appDir )

	# Pick the template path we're going to use
	$mod_path = get_module_path('apache2')
	$specific = "$mod_path/templates/$operatingsystem/$operatingsystemrelease$params::phpAppsConfigPath-appDir-frag.erb"
	$default  = "$mod_path/templates/default$params::phpAppsConfigPath-appDir-frag.erb"

	# write the config file
	concat::fragment { $appDir :
		target	=> $params::phpAppsConfigPath,
		order	=> 10,
		content => inline_template( file( $specific, $default ) ),
	}

}

define apache2::php::addAppLoc
(
	$appLoc = $name
)
{
	include apache2::params

	validate_string( $appLoc )

	# Pick the template path we're going to use
	$mod_path = get_module_path('apache2')
	$specific = "$mod_path/templates/$operatingsystem/$operatingsystemrelease$params::phpAppsConfigPath-appLoc-frag.erb"
	$default  = "$mod_path/templates/default$params::phpAppsConfigPath-appLoc-frag.erb"

	# write the config file
	concat::fragment { $appLoc :
		target	=> $params::phpAppsConfigPath,
		order	=> 10,
		content => inline_template( file( $specific, $default ) ),
	}

}

