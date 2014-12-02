class apache2::params
{
	$serviceName   		= "apache2"
	$packageName		= "apache2"

	$sysconfigPath		= "/etc/sysconfig/apache2"

	$configDirPath		= "/etc/apache2"
	$infoConfigPath		= "${configDirPath}/mod_info.conf"
	$statusConfigPath	= "${configDirPath}/mod_status.conf"

	$configConfdPath	= "${configDirPath}/conf.d"
	$accessConfigPath	= "${configConfdPath}/access.conf"
	$ldapConfigPath		= "${configConfdPath}/ldap.conf"
	$remoteIpConfigPath	= "${configConfdPath}/remoteip.conf"
	$traceEnableConfigPath	= "${configConfdPath}/trace.conf"

	# Default modules for mod.pp
	$a2modDefaults = [ 'actions','alias','auth_basic','authn_file','authz_host','authz_groupfile','authz_user','autoindex','dir','env','expires','include','log_config','mime','negotiation','setenvif','reqtimeout','authn_core','authz_core' ]
}
