class apache2::sysconfig
(
  $serverSignature = 'off',
  $serverTokens    = 'prod'
)
{
  include apache2::params

  validate_string( $serverSignature )
  validate_string( $serverTokens )

  # Replace lines in the existing file
  file_line { 'serverSignatureRule' :
    path    => $apache2::params::sysconfigPath,
    line    => "APACHE_SERVERSIGNATURE = \"${serverSignature}\"",
    match   => '^APACHE_SERVERSIGNATURE\s*=',
    notify  => $apache2::serviceNotify,
    require => Package[ $apache2::params::packageName ],
  }
  file_line { 'serverTokensRule' :
    path    => $apache2::params::sysconfigPath,
    line    => "APACHE_SERVERTOKENS=\"${serverTokens}\"",
    match   => '^APACHE_SERVERTOKENS=',
    notify  => $apache2::serviceNotify,
    require => Package[ $apache2::params::packageName ],
  }
}
