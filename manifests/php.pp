class apache2::php
(
	$phpMemoryLimit,
	$phpErrorLog	= "/var/log/apache2/php-error_log",
	$phpExposePhp	= "off",
	$phpTimezone	= "America/Los_Angeles",
	$appDirs	= [],
	$appLocs	= []
)
{
	include apache2::params

	#validate_re( $phpMemoryLimit, "^[0..9]+[MmGg]" )
	validate_string( $phpMemoryLimit )
	validate_string( $phpErrorLog )
	validate_re( $phpExposePhp, "^(on|off)" )
	validate_string( $phpTimezone )
	validate_array( $appDirs )
	validate_array( $appLocs )

	# install the package
	package { $params::phpPackageName :
		ensure	=> latest,
	}

	# include the module
	apache2::enableModule{ 'php5':
		require	=> Package[ $params::phpPackageName ],
	}

	# Pick the template path we're going to use
	$mod_path = get_module_path('apache2')
	$specific = "$mod_path/templates/$operatingsystem/$operatingsystemrelease$params::phpConfigPath.erb"
	$default  = "$mod_path/templates/default$params::phpConfigPath.erb"

	# write the config file
	file { $params::phpConfigPath :
		ensure => file,
		content => inline_template( file( $specific, $default ) ),
		notify  => $apache2::serviceNotify,
		require	=> Package[ $params::phpPackageName ],
	}

	# if any apps were specified, create them
	class { 'apache2::php::app' : }
	if ( is_array( $appDirs ) and size( $appDirs ) > 0 ) {
		apache2::php::addAppDir{ $appDirs : }
	}
	if ( is_array( $appLocs ) and size( $appLocs ) > 0 ) {
		apache2::php::addAppLoc{ $appLocs : }
	}
}
