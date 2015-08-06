# Private class
class molly_guard::config inherits molly_guard {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }
  
  file { '/etc/molly-guard/rc':
    ensure  => file,
    owner   => 0,
    group   => 0,
    mode    => '0644',
    content => template('molly_guard/rc.erb'),
  }

}
