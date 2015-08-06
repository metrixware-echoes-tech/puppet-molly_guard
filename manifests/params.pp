# == Class: molly_guard::params
#
# This is a container class with default parameters for molly_guard classes.
class molly_guard::params {
  $always_query_hostname = false
  $package_ensure        = 'present'

  case $::osfamily {
    'Debian': {
      $package_name = 'molly-guard'
    }
    default: {
      fail("Unsupported OS family: ${::osfamily}")
    }
  }
}
