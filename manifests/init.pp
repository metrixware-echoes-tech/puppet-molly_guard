# == Class: molly_guard
#
class molly_guard (
  Variant[
    Boolean,
    Enum['true', 'false']
  ] $always_query_hostname = $molly_guard::params::always_query_hostname,
  String  $package_ensure  = $molly_guard::params::package_ensure,
  String  $package_name    = $molly_guard::params::package_name,
) inherits molly_guard::params {
  # <stringified variable handling>
  $always_query_hostname_bool = $always_query_hostname ? {
    Boolean => $always_query_hostname,
    String  => str2bool($always_query_hostname),
    default => fail('$always_query_hostname parameter is not a boolean'),
  }
  # </stringified variable handling>

  anchor { "${module_name}::begin": }
  -> class { "${module_name}::install": }
  -> class { "${module_name}::config": }
  -> anchor { "${module_name}::end": }
}
