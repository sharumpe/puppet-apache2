class apache2::jk::app
{
	concat { $params::jkAppsConfigPath :
		ensure	=> present,
		notify  => $apache2::serviceNotify,
		require	=> Package[ $params::jkPackageName ],
	}


	concat::fragment { "$params::jkAppsConfigPath-fragment-pre" :
		target	=> $params::jkAppsConfigPath,
		order	=> 01,
		content	=> "<IfModule mod_jk.c>\n",
	}

	concat::fragment { "$params::jkAppsConfigPath-fragment-post" :
		target	=> $params::jkAppsConfigPath,
		order	=> 99,
		content	=> "</IfModule>\n",
	}
}

define apache2::jk::addApp
(
	$appName = $name
)
{
	include apache2::params

	validate_string( $appName )

	# Pick the template path we're going to use
	$mod_path = get_module_path('apache2')
	$specific = "$mod_path/templates/$operatingsystem/$operatingsystemrelease$params::jkAppsConfigPath-app-frag.erb"
	$default  = "$mod_path/templates/default$params::jkAppsConfigPath-app-frag.erb"

	# write the config file
	concat::fragment { $appName :
		target	=> $params::jkAppsConfigPath,
		order	=> 10,
		content => inline_template( file( $specific, $default ) ),
	}

}
