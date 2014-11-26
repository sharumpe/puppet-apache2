define apache2::remoteip
(
	$remoteIpHeader
)
{
	include apache2::params

	validate_string( $remoteIpHeader )

	# Enable the module
	apache2::enableModule{ 'remoteip': }

        # Pick the template path we're going to use
        $mod_path = get_module_path('apache2')
        $specific = "$mod_path/templates/$operatingsystem/$operatingsystemrelease$params::remoteIpConfigPath.erb"
        $default  = "$mod_path/templates/default$params::remoteIpConfigPath.erb"

        # Set up the config file
        file { $params::remoteIpConfigPath :
                owner   => 'root',
                group   => 'root',
                content => inline_template( file( $specific, $default ) ),
                notify  => $apache2::serviceNotify,
        }

}
