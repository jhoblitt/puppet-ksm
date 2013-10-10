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
}
