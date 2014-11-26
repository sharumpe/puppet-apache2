class apache2::statusAndInfo
{
	#
	# Simply put in the default server-status and server-info files,
	# but using the new-style access control configurations
	#
	file { $params::statusConfigPath :
		ensure	=> present,
		source	=> "puppet:///modules/apache2${params::statusConfigPath}",
		require	=> Package[ $params::packageName ],
	}
	file { $params::infoConfigPath :
		ensure	=> present,
		source	=> "puppet:///modules/apache2${params::infoConfigPath}",
		require	=> Package[ $params::packageName ],
	}

	#
	# Enable the modules
	#
	apache2::enableModule{ 'status': }
	apache2::enableModule{ 'info': }
}
