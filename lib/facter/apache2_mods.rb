Facter.add("apache2_mods") do
  confine :operatingsystem => "OpenSuSE"
  setcode do
    mods_string = `grep '^APACHE_MODULES' /etc/sysconfig/apache2 | awk -F\\" '{print $2;}'`
    mods = mods_string.split(' ')
    mods
  end
end