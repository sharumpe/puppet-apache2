class apache2::access {
	include apache2::params

	#
	# Create the file we're storing these in
	#
	concat { $params::accessConfigPath :
		ensure	=> present,
		notify  => $apache2::serviceNotify,
		require	=> Package[ $params::jkPackageName ],
	}
}

define apache2::grantAccessToHost
(
	$location,
	$host
)
{
	include apache2::params

	validate_string( $location )
	validate_string( $host )

	concat::fragment { "${location}_${host}" :
		target	=> $params::accessConfigPath,
		order	=> 10,
		content	=> template( "apache2/default${params::accessConfigPath}-grantToHost-frag.erb" ),
	}
}

define apache2::grantAccessToIp
(
	$location,
	$ip
)
{
	include apache2::params

	validate_string( $location )
	validate_string( $ip )

	if ( is_ip_address( $ip ) ) {
		concat::fragment { "${location}_${ip}" :
			target	=> $params::accessConfigPath,
			order	=> 10,
			content	=> template( "apache2/default${params::accessConfigPath}-grantToIp-frag.erb" ),
		}
	}
}
