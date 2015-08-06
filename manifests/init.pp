class molly_guard (
  $always_query_hostname = $molly_guard::params::always_query_hostname,
  $package_ensure        = $molly_guard::params::package_ensure,
  $package_name          = $molly_guard::params::package_name,
) inherits molly_guard::params {
  validate_bool($always_query_hostname)

  anchor { "${module_name}::begin": } ->
  class { "${module_name}::install": } ->
  class { "${module_name}::config": } ->
  anchor { "${module_name}::end": }
}
