# == Class: molly_guard
#
class molly_guard (
  $always_query_hostname = $molly_guard::params::always_query_hostname,
  $package_ensure        = $molly_guard::params::package_ensure,
  $package_name          = $molly_guard::params::package_name,
) inherits molly_guard::params {
  # <stringified variable handling>
  if is_string($always_query_hostname) == true {
    $always_query_hostname_bool = str2bool($always_query_hostname)
  } else {
    $always_query_hostname_bool = $always_query_hostname
  }
  # </stringified variable handling>

  # <variable validations>
  validate_bool($always_query_hostname_bool)
  validate_string($package_ensure)
  validate_string($package_name)
  # </variable validations>

  anchor { "${module_name}::begin": } ->
  class { "${module_name}::install": } ->
  class { "${module_name}::config": } ->
  anchor { "${module_name}::end": }
}
