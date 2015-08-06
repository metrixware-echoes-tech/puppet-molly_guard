# Private class
class molly_guard::install inherits molly_guard {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  package { $molly_guard::package_name:
    ensure => $molly_guard::package_ensure,
    alias  => 'molly_guard',
  }
}
