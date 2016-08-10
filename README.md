# molly_guard

[![Build Status](https://travis-ci.org/echoes-tech/puppet-molly_guard.svg?branch=master)]
(https://travis-ci.org/echoes-tech/puppet-molly_guard)
[![Flattr Button](https://api.flattr.com/button/flattr-badge-large.png "Flattr This!")]
(https://flattr.com/submit/auto?user_id=echoes&url=https://forge.puppetlabs.com/echoes/monit&title=Puppet%20module%20to%20manage%20Molly-Guard&description=This%20module%20installs%20and%20configures%20Molly-Guard.&lang=en_GB&category=software "Puppet module to manage Molly-Guard installation and configuration")

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with molly_guard](#setup)
    * [Beginning with molly_guard](#beginning-with-molly_guard)
4. [Usage - Configuration options and additional functionality](#usage)
    * [Always query hostanme](#always-query-hostanme)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)
8. [Contributors](#contributors)

## Overview

Puppet module to manage Molly-Guard installation and configuration.


## Module Description

This module installs and configures [Molly-Guard](http://anonscm.debian.org/cgit/collab-maint/molly-guard.git/).

## Setup

### Beginning with molly_guard

```puppet
include 'molly_guard'
```

## Usage

### Always query hostanme

```puppet
class { 'molly_guard':
  always_query_hostanme => true,
}
```

## Reference

### Classes

#### Public classes

* molly_guard: Main class, includes all other classes.

#### Private classes

* molly_guard::params: Sets parameter defaults per operating system.
* molly_guard::install: Handles the packages.
* molly_guard::config: Handles the configuration file.

#### Parameters

The following parameters are available in the `::molly_guard` class:

##### `always_query_hostanme`

Specifies whether  always ask for the hostname, even if no SSH session was detected. Valid options: 'true' or 'false'. Default value: 'false'

##### `package_ensure`

Tells Puppet whether the Molly-Guard package should be installed, and what version. Valid options: 'present', 'latest', or a specific version number. Default value: 'present'

##### `package_name`

Tells Puppet what Molly-Guard package to manage. Valid options: string. Default value: 'molly_guard'

## Limitations

Debian family OSes are officially supported. Tested and built on Debian.

## Development

[Echoes Technologies](https://echoes.fr) modules on the Puppet Forge are open projects, and community contributions are essential for keeping them great.

[Fork this module on GitHub](https://github.com/echoes-tech/puppet-molly_guard/fork)

## Contributors

The list of contributors can be found at: https://github.com/echoes-tech/puppet-molly_guard/graphs/contributors
