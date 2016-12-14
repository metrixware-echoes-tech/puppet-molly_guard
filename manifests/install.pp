# Private class
class molly_guard::install inherits molly_guard {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  package { 'molly_guard':
    ensure => $molly_guard::package_ensure,
    name   => $molly_guard::package_name,
  }
}
