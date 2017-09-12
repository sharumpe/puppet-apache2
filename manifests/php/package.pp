define apache2::php::package
(
  $packageName	= $name,
  $ensure		= latest
)
{
  include apache2::params

  validate_string( $packageName )
  validate_string( $ensure )

  # if the name doesn't already start with php5-, make it so.
  if ( $packageName =~ /^php5-/ ) {
    $fixedPackageName = $packageName
  }
  else {
    $fixedPackageName = "php5-$packageName"
  }

  package { $fixedPackageName :
    ensure	=> $ensure,
    require	=> Package[ $apache2::params::phpPackageName ],
  }

}
