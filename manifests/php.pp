class apache2::php
(
	$phpMemoryLimit 	= undef,
	$phpErrorLog		= "/var/log/apache2/php-error_log",
	$phpExposePhp		= "off",
	$phpTimezone		= "America/Los_Angeles",
	$useDefaultPhpPackages	= true,
	$loadPhpPackages	= [],
	$unloadPhpPackages	= [],
	$appDirs		= [],
	$appLocs		= []
)
{
	include apache2::params

	#validate_re( $phpMemoryLimit, "^[0..9]+[MmGg]" )
	validate_string( $phpMemoryLimit )
	validate_string( $phpErrorLog )
	validate_re( $phpExposePhp, "^(on|off)" )
	validate_string( $phpTimezone )
	validate_bool( $useDefaultPhpPackages )
	validate_array( $loadPhpPackages )
	validate_array( $unloadPhpPackages )
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

	# Default PHP-specific packages
	# See params::phpPackageDefaults for default package list
	if ( is_array( $loadPhpPackages ) ) { $phpPackageLoad = $loadPhpPackages }
	else { $phpPackageLoad = [] }

	if ( is_array( $unloadPhpPackages ) ) { $phpPackageUnload = $unloadPhpPackages }
	else { $phpPackageUnload = [] }

	if ( is_bool( $useDefaultPhpPackages ) and $useDefaultPhpPackages ) { $phpPackageDefaultLoad = $params::phpPackageDefaults }
	else { $phpPackageDefaultLoad = [] }

	# Add whatever extra packages were asked for
	apache2::php::package { $phpPackageDefaultLoad :
		ensure	=> latest,
	}
	apache2::php::package { $phpPackageLoad :
		ensure	=> latest,
	}

	# Remove whatever packages we were asked to
	apache2::php::package { $phpPackageUnload :
		ensure	=> purged,
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
