class apache2::jk
(
	$jkLogLevel	= "error",
	$jkWorkerHost	= "localhost",
	$jkWorkerPort	= 8009
)
{
	include apache2::params

	validate_string( $jkLogLevel )
	validate_string( $jkWorkerHost )
	validate_string( $jkWorkerPort )

	# install the package

	# include the module

	# write the config file
}
