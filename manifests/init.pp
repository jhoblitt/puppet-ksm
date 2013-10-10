# == Class: ksm
#
# simple template
#
# === Examples
#
# include ksm
#
class ksm(
  $ksm_config      = {},
  $ksmtuned_config = {},
) inherits ksm::params {
  validate_hash($ksm_config)
  validate_hash($ksmtuned_config)

  $safe_ksmtuned_config = merge($ksmtuned_config, {
    'LOGFILE' => '/var/log/ksmtuned',
    'DEBUG'   => '1',
  })

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

  # identical rules as /etc/logrotate.d/libvirtd from libvirt-0.10.2-18
  logrotate::rule { 'ksmtuned':
    path          => '/var/log/ksmtuned',
    rotate_every  => 'weekly',
    missingok     => true,
    rotate        => 4,
    compress      => true,
    delaycompress => true,
    copytruncate  => true,
    minsize       => '100k',
  }

}
