class apache2::sysconfig
(
	$serverSignature = 'off',
	$serverTokens    = 'prod'
)
{
	include apache2::params

	validate_string( $serverSignature )
	validate_string( $serverTokens )

    # Pick the template path we're going to use
    $mod_path = get_module_path('apache2')
    $specific = "$mod_path/templates/$operatingsystem/$operatingsystemrelease$params::sysconfigPath.erb"
    $default  = "$mod_path/templates/default$params::sysconfigPath.erb"

	# Replace lines in the existing file
	file_line { 'serverSignatureRule' :
		path	=> $params::sysconfigPath,
		line	=> "APACHE_SERVERSIGNATURE = \"${serverSignature}\"",
		match	=> "^APACHE_SERVERSIGNATURE\s*=",
        notify	=> $apache2::serviceNotify,
	}
	file_line { 'serverTokensRule' :
		path	=> $params::sysconfigPath,
		line	=> "APACHE_SERVERTOKENS=\"${serverTokens}\"",
		match	=> "^APACHE_SERVERTOKENS=",
        notify	=> $apache2::serviceNotify,
	}
}
