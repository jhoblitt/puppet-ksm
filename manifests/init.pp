# == Class: ksm
#
# simple template
#
# === Examples
#
# include ksm
#
class ksm inherits ksm::params {
  ensure_packages(any2array($ksm::params::ksm_package_name))

  Package[$ksm::params::ksm_package_name] ->
  file { '/etc/sysconfig/ksm':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/ksm.erb"),
  } ->
  service { 'ksm':
    hasrestart => true,
    hasstatus  => true,
    enable     => true,
  }

  Package[$ksm::params::ksm_package_name] ->
  file { '/etc/ksmtuned.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/ksmtuned.conf.erb"),
  } ->
  service { 'ksmtuned':
    ensure     => 'running',
    hasrestart => true,
    hasstatus  => true,
    enable     => true,
  }
}
