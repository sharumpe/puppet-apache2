class apache2::jk
(
	$jkLogLevel	= "error",
	$jkWorkerHost	= "localhost",
	$jkWorkerPort	= 8009
)
{
	include apache2::params

	validate_string( $jkLogLevel )
	validate_string( $jkWorkerHost )
	validate_string( $jkWorkerPort )

	# install the package
	package { $params::jkPackageName :
		ensure	=> latest,
	}

	# include the module
	apache2::enableModule{ 'jk':
		require	=> Package[ $params::jkPackageName ],
	}

	# Pick the template path we're going to use
	$mod_path = get_module_path('apache2')
	$specific = "$mod_path/templates/$operatingsystem/$operatingsystemrelease$params::jkConfigPath.erb"
	$default  = "$mod_path/templates/default$params::jkConfigPath.erb"

	# write the config file
	file { $apache2::jkConfigPath :
		ensure => file,
		content => inline_template( file( $specific, $default ) ),
		notify  => $apache2::serviceNotify,
		require	=> Package[ $params::jkPackageName ],
	}

}
