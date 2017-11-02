class apache2::php::reposelect
{
  if ( $apache2::php::phpVersion == '5.5' ) {
    # repo alias to install from
    $repoAlias = 'opensuse-13.1-devel_languages_php55'

    # turn on 55
    $enabled55 = 1
    $autorefresh55 = 1

    # turn off 56
    $enabled56 = 0
    $autorefresh56 = 0
  }
  elsif ( $apache2::php::phpVersion == '5.6' ) {
    # repo alias to install from
    $repoAlias = 'opensuse-13.1-devel_languages_php56'

    # turn on 56
    $enabled56 = 1
    $autorefresh56 = 1

    # turn off 55
    $enabled55 = 0
    $autorefresh55 = 0
  }
  else {
    # repo alias to install from
    $repoAlias = 'opensuse-13.1-update'

    # turn off 55
    $enabled55 = 0
    $autorefresh55 = 0

    # turn off 56
    $enabled56 = 0
    $autorefresh56 = 0
  }

  zypprepo { 'opensuse-13.1-devel_languages_php55' :
    baseurl     => 'http://download.opensuse.org/repositories/devel:/languages:/php:/php55/openSUSE_13.1/',
    enabled     => $enabled55,
    autorefresh => $autorefresh55,
    name        => 'opensuse-13.1-devel_languages_php_php55',
    gpgcheck    => 0,
  }
  zypprepo { 'opensuse-13.1-devel_languages_php56' :
    baseurl     => 'http://download.opensuse.org/repositories/devel:/languages:/php:/php56/openSUSE_13.1/',
    enabled     => $enabled56,
    autorefresh => $autorefresh56,
    name        => 'opensuse-13.1-devel_languages_php_php56',
    gpgcheck    => 0,
  }

  # install the package
  package { $apache2::params::phpPackageName :
    ensure  => latest,
    require => [ Zypprepo[ 'opensuse-13.1-devel_languages_php55' ], Zypprepo[ 'opensuse-13.1-devel_languages_php56' ] ],
  }

}
