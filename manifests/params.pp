# == Class: ksm::params
#
# This class should be considered private.
#
#
class ksm::params {
  case $::osfamily {
    'redhat': {
      $ksm_package_name = 'qemu-kvm'
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }

}
