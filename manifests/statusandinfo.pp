class apache2::statusAndInfo
(
	$serverInfoAccessIp = undef,
	$serverStatusAccessIp = undef
)
{
	include apache2::access

	validate_string( $serverInfoAccessIp )
	validate_string( $serverStatusAccessIp )

	# Enable the modules
	apache2::enableModule{ 'status': }
	apache2::enableModule{ 'info': }

	# Simply put in the default server-status and server-info files,
	# but using the new-style access control configurations.
	# This has to happen because old-style and new-style can't be
	# combined for the same <Location>, and grantAccessToIp uses
	# the new-style access control.
	file { $params::statusConfigPath :
		ensure	=> present,
		source	=> "puppet:///modules/apache2/default${params::statusConfigPath}",
		notify  => $apache2::serviceNotify,
		require	=> Package[ $params::packageName ],
	}
	file { $params::infoConfigPath :
		ensure	=> present,
		source	=> "puppet:///modules/apache2/default${params::infoConfigPath}",
		notify  => $apache2::serviceNotify,
		require	=> Package[ $params::packageName ],
	}

	# Set up access
	if ( is_ip_address( $serverInfoAccessIp ) ) {
        	apache2::grantAccessToIp { 'server-info' :
                	location        => '/server-info',
                	ip              => $serverInfoAccessIp,
        	}
	}
	if ( is_ip_address( $serverInfoAccessIp ) ) {
        	apache2::grantAccessToIp { 'server-status' :
                	location        => '/server-status',
                	ip              => $serverStatusAccessIp,
        	}
	}
}
