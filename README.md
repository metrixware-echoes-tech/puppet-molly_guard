# molly\_guard

[![Puppet Forge Version](http://img.shields.io/puppetforge/v/soli/molly_guard.svg)](https://forge.puppetlabs.com/soli/molly_guard)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/soli/molly_guard.svg)](https://forge.puppetlabs.com/soli/molly_guard)
[![Puppet Forge Score](http://img.shields.io/puppetforge/f/soli/molly_guard.svg)](https://forge.puppetlabs.com/soli/molly_guard)
[![Build Status](https://travis-ci.org/solution-libre/puppet-molly_guard.svg?branch=master)](https://travis-ci.org/solution-libre/puppet-molly_guard)

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
2. [Setup - The basics of getting started with molly\_guard](#setup)
    * [Beginning with molly\_guard](#beginning-with-molly_guard)
3. [Usage - Configuration options and additional functionality](#usage)
    * [Always query hostanme](#always-query-hostanme)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Contributors](#contributors)

## Module Description

This module installs and configures [Molly-Guard](http://anonscm.debian.org/cgit/collab-maint/molly-guard.git/).

## Setup

### Beginning with molly\_guard

```puppet
include ::molly_guard
```

## Usage

### Always query hostanme

```puppet
class { 'molly_guard':
  always_query_hostname => true,
}
```

## Reference

### Classes

#### Public classes

* molly\_guard: Main class, includes all other classes.

#### Private classes

* molly\_guard::params: Sets parameter defaults per operating system.
* molly\_guard::install: Handles the packages.
* molly\_guard::config: Handles the configuration file.

#### Parameters

The following parameters are available in the `::molly_guard` class:

##### `always_query_hostanme`

Specifies whether  always ask for the hostname, even if no SSH session was detected. Valid options: 'true' or 'false'. Default value: 'false'

##### `package_ensure`

Tells Puppet whether the Molly-Guard package should be installed, and what version. Valid options: 'present', 'latest', or a specific version number. Default value: 'present'

##### `package_name`

Tells Puppet what Molly-Guard package to manage. Valid options: string. Default value: 'molly\_guard'

## Limitations

Debian family OSes are officially supported. Tested and built on Debian.

## Development

[Solution Libre](https://www.solution-libre.fr)'s modules on the Puppet Forge are open projects, and community contributions are essential for keeping them great.

[Fork this module on GitHub](https://github.com/solution-libre/puppet-molly_guard/fork)

## Contributors

The list of contributors can be found at: https://github.com/solution-libre/puppet-molly_guard/graphs/contributors
