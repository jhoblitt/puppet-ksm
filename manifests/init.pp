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

  service { 'ksm':
    hasrestart => true,
    hasstatus  => true,
    enable     => true,
  }

  service { 'ksmtuned':
    ensure     => 'running',
    hasrestart => true,
    hasstatus  => true,
    enable     => true,
  }
}
