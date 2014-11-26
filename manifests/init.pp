File {
	owner	=> root,
	group	=> root,
	ignore	=> [ '.svn', '.git' ],
}

class apache2
(
	$modules		= [],
	$useDefaultModules	= true,
	$remoteIpHeader		= 'X-Forwarded-For',
	$serverSignature	= 'off',
	$serverTokens		= 'prod',
	$traceEnable		= false,
	$reloadOnChange		= false
)
{
	#
	# Get our configs
	#
	include apache2::params


	#
	# Figure out if we're doing any "ensure" stuff with the service
	#
	validate_bool( $reloadOnChange )
	if ( $reloadOnChange ) {
		$serviceNotify = Service[ $params::serviceName ]
	}
	else {
		$serviceNotify = []
	}


	#
	# Package and Service
	#
	package { $params::packageName :
		ensure	=> latest,
	}

	service { $params::serviceName :
		ensure	=> running,
		enable	=> true,
		require	=> Package[ $params::packageName ],
	}


	#
	# Make the log dir readable
	#
	file { '/var/log/apache2' :
		ensure	=> directory,
		mode	=> 'a+rx',
		require	=> Package[ $params::packageName ],
	}


	#
	# Set serverSignature and serverTokens
	#
	class { 'apache2::sysconfig' :
		serverSignature	=> $serverSignature,
		serverTokens	=> $serverTokens,
	}


	#
	# Default Modules
	# See params::a2modDefaults for default module list
	# Other modules are turned on in their configuration definitions
	#
	if ( is_array( $modules ) ) { $a2modLoad = $modules }
	else { $a2modLoad = [] }

	if ( is_bool( $useDefaultModules ) and $useDefaultModules ) { $a2modDefaultLoad = $params::a2modDefaults }
	else { $a2modDefaultLoad = [] }

	class { 'apache2::defaultModules':
		modules	=> union( $a2modLoad, $a2modDefaultLoad )
	}


	#
	# Turn TraceEnable off
	#
	validate_bool( $traceEnable )
	apache2::traceenable { 'class_default' :
		enable => $traceEnable,
		require	=> Package[ $params::packageName ],
	}


	#
	# Turn on remoteIpHeader logging
	#
	validate_string( $remoteIpHeader )
	apache2::remoteip { 'class_default' :
		remoteIpHeader	=> $remoteIpHeader,
	}


	#
	# Defaults for server-info and server-status
	#
	include apache2::statusAndInfo


	#
	# Grant access to various things from TS network
	#
	include apache2::access
}
