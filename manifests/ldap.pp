class apache2::ldap
{
	#
	# Simply put in the default ldap config file,
	# but using the new-style access control configurations
	#
	file { $params::ldapConfigPath :
		ensure	=> present,
		source	=> "puppet:///modules/apache2${params::statusConfigPath}",
		require	=> Package[ $params::packageName ],
	}

	#
	# Enable the module
	#
	apache2::enableModule{ 'ldap': }
}
