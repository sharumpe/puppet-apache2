class apache2::params
{
  $serviceName = 'apache2'
  $packageName = 'apache2'

  $jkPackageName  = 'apache2-mod_jk'
  $phpPackageName = 'apache2-mod_php5'

  $sysconfigPath = '/etc/sysconfig/apache2'

  $configDirPath    = '/etc/apache2'
  $infoConfigPath   = "${configDirPath}/mod_info.conf"
  $ldapConfigPath   = "${configDirPath}/ldap.conf"
  $statusConfigPath = "${configDirPath}/mod_status.conf"

  $configConfdPath       = "${configDirPath}/conf.d"
  $accessConfigPath      = "${configConfdPath}/access.conf"
  $jkConfigPath          = "${configConfdPath}/jk.conf"
  $jkAppsConfigPath      = "${configConfdPath}/jkApps.conf.inc"
  $phpConfigPath         = "${configConfdPath}/php5.conf"
  $phpAppsConfigPath     = "${configConfdPath}/php5Apps.conf.inc"
  $remoteIpConfigPath    = "${configConfdPath}/remoteip.conf"
  $traceEnableConfigPath = "${configConfdPath}/trace.conf"

  # Default modules for mod.pp
  $a2modDefaults = [ 'actions','alias','auth_basic','authn_file','authz_host','authz_groupfile','authz_user','autoindex','dir','env','expires','include','log_config','mime','negotiation','setenvif','reqtimeout','authn_core','authz_core' ]

  # Default packages for php5
  $phpPackageDefaults = [ 'bz2','calendar','curl','gd','ldap','mbstring','mcrypt','mysql','openssl','pear','phar','zip' ]
}
