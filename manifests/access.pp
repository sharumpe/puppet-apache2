class apache2::access {
	#
	# Create the file we're storing these in
	#
	concat { $params::accessConfigPath :
		ensure	=> present,
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

	concat::fragment { "${location}_${ip}" :
		target	=> $params::accessConfigPath,
		order	=> 10,
		content	=> template( "apache2/default${params::accessConfigPath}-grantToIp-frag.erb" ),
	}
}
