# microserver

Tested with Travis CI

[![Build Status](https://travis-ci.org/bodgit/puppet-microserver.svg?branch=master)](https://travis-ci.org/bodgit/puppet-microserver)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with microserver](#setup)
    * [What microserver affects](#what-microserver-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with microserver](#beginning-with-microserver)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module manages HP ProLiant MicroServer hardware.

## Module Description

The MicroServer hardware is a mostly fixed configuration but has some optional
extras, namely:

* Remote Management card
* Trusted Platform Module

The presence of any of these unlocks additional functionality that can be
utilised by the Operating System however they are not without their quirks
so this module encapsulates all of the configuration you need to make for
everything to work properly.

## Setup

### What microserver affects

* If the Remote Management card is present it will install and set up IPMI
* If the Trusted Platform Module is present it will install and set up rngd
* Install and set up a hardware watchdog using either the IPMI watchdog if
  IPMI is installed or the TCO watchdog present in the SB800 southbridge
  chipset

### Setup Requirements

You will need to set `pluginsync = true`.

### Beginning with microserver

```puppet
include ::microserver
```

## Usage

```puppet
class { '::microserver':
}
```

## Reference

### Classes

* microserver: Main class for installation and service management.
* microserver::config: Main class for microserver configuration/management.
* microserver::params: Different configuration data for different systems.

### Parameters

####`install_rngd`

Whether to install rngd or not. Defaults to whether the Trusted Platform
Module is present.

####`install_ipmi`

Whether to install IPMI or not. Defaults to whether the Remote Management
card is present.

####`install_watchdog`

Whether to install the watchdog or not.

####`ipmi_driver_type`

Set to either 'builtin' or 'module'. Default based on the Operating System.

####`watchdog_type`

Set to either 'tco' or 'ipmi'. Defaults to 'ipmi' if `install_ipmi` is true
else 'tco'.

### Facts

####`microserver_ilo`

Returns true or false if the Remote Management card is present

####`microserver_tpm`

Returns true or false if the Trusted Platform Module is present

## Limitations

This module has been built on and tested against Puppet 2.7 and higher.
Puppet 2.7 support is slated for removal at the next major version.

The module has been tested on:

* RedHat Enterprise Linux 6/7

Testing on other platforms has been light and cannot be guaranteed.

The supported hardware consists of the Gen7 HP ProLiant MicroServer
N36L/N40L/N54L. The Gen8 hardware is currently unsupported.

## Authors

* Matt Dainty <matt@bodgit-n-scarper.com>
