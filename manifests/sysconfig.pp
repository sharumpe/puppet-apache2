class apache2::sysconfig
(
	$serverSignature = 'off',
	$serverTokens    = 'prod'
)
{
	include apache2::params

        # Pick the template path we're going to use
        $mod_path = get_module_path('apache2')
        $specific = "$mod_path/templates/$operatingsystem/$operatingsystemrelease$params::sysconfigPath.erb"
        $default  = "$mod_path/templates/default$params::sysconfigPath.erb"

	# Build the sysconfig file from the template
	file { $params::sysconfigPath :
		ensure	=> present,
                content => inline_template( file( $specific, $default ) ),
                notify	=> $apache2::serviceNotify,
	}
}
