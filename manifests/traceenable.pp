define apache2::traceenable
(
  $enable = false
)
{
  include apache2::params

  validate_bool( $enable )

  # Set the file contents based on the value of enable
  if ( $enable ) {
    $content = 'TraceEnable on'
  }
  else {
    $content = 'TraceEnable off'
  }

  file { $apache2::params::traceEnableConfigPath :
    ensure  => file,
    content => $content,
    notify  => $apache2::serviceNotify,
    require => Package[ $apache2::params::packageName ],
  }

}
