class apache2::defaultModules
(
	$modules = []
)
{
	include apache2::params

	# List of default modules to enable
	# defined in apache2::params::a2modDefaults
	if ( is_array( $modules ) and ( size( $modules ) > 0 ) ) {
		apache2::enableModule { $modules : }
	}
}

define apache2::enableModule
{
        # Enable the module
        exec { "enable_${name}" :
                command => "/usr/sbin/a2enmod ${name}",
                unless  => "/usr/sbin/a2enmod -q ${name}",
                require => [ Package[ $params::packageName ], File[ $params::sysconfigPath ] ],
                notify	=> $apache2::serviceNotify,
        }
}
