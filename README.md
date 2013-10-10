Puppet ksm Module
=================

[![Build Status](https://travis-ci.org/jhoblitt/puppet-ksm.png)](https://travis-ci.org/jhoblitt/puppet-ksm)

#### Table of Contents

1. [Overview](#overview)
2. [Description](#description)
2. [Words of Caution](#words-of-caution)
3. [Usage](#usage)
    * [Simple](#simple)
    * [Files](#files)
    * [Advanced](#advanced)
    * [`ksm`](#ksm)
4. [Limitations](#limitations)
    * [Tested Platforms](#tested-platforms)
5. [Support](#support)
6. [See Also](#see-also)


Overview
--------

Manages Linux Kernel Samepage Merging (KSM)

Description
-----------

This is a puppet module for configuration of the `ksm` and `ksmtuned` services
that in turn manage Linux's [Kernel Samepage Merging
(KSM)](http://www.linux-kvm.org/page/KSM) functionality.  The KSM subsystem has
broad applicability but is typically used on hosts acting as hypervisor for
[KVM](http://www.linux-kvm.org/page/Main_Page) virtual machines.

The typical mode of operation is that the `ksmtuned` service starts and stops
the `ksm` service based configurable heuristics.  At present, this is the only
configuration supported by this module.


Words of Caution
----------------

Documentation on the configuration of `ksmtuned` is sparse.  There is section
in [RHEL6 Virtualization Administration
Guide](https://access.redhat.com/site/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Virtualization_Administration_Guide/chap-KSM.html)
but it doesn't provide much help and at least the description of
`pages_to_scan` is incorrect.

There is a much more useful explanation in the [RHEL6
Solutions](https://access.redhat.com/site/solutions/329963) site but it is only
accessible to customer paying for RHEL support.

__Be advised that:__

* KSM consumes both CPU time (aka electricity) and memory bandwidth. 
* Under at least Linux 2.6.32/RHEL6 KSM merged pages that have been swapped out
  are unshared when swapped back in.  I suspect I've seen this exacerbate "swap
hell" caused by not adjusting `vm.swappiness` from the default on large memory
hosts.

Usage
-----

### Simple

The defaults are probably acceptable for most use cases.

```puppet
include ksm
```

or

```puppet
class { 'ksm': }
```

### Advanced

This example:

* Disables the default 50% of memory shared page limit (`KSM_MAX_KERNEL_PAGES`)
* Changes the interval that `ksmtuned` wakes up at from 60s -> 15s 
* Changes the default 'free' memory threshold from 20% to 25%
* Changes the default number of pages scanned per KSM cycle (typically 10msec)
  from 1250 -> 256

```puppet
class { 'ksm':
  ksm_config      => {
    'KSM_MAX_KERNEL_PAGES' => 0,
  },
  ksmtuned_config => {
    'KSM_MONITOR_INTERVAL' => 15,
    'KSM_THRES_COEF'       => 25,
    'KSM_NPAGES_MAX'       => 256
  },
}
```

### Files

The `ksmtuned` debugging log is enabled at the path `/var/log/ksmtuned` with
`logrotate` support.

### `ksm`

```puppet
# defaults
class { 'ksm':
  ksm_config      => {},
  ksmtuned_config => {},
}
```

* `ksm_config`

    `Hash`

    Options to be set in `/etc/sysconfig/ksm`

    Valid Keys are:

    * `KSM_MAX_KERNEL_PAGES`

    defaults to: `{}`

* `ksmtuned_config`

    `Hash`

    Options to be set in `/etc/ksmtuned.conf`

    Valid Keys are:

    * `KSM_MONITOR_INTERVAL`
    * `KSM_SLEEP_MSEC`
    * `KSM_NPAGES_BOOST`
    * `KSM_NPAGES_DECAY`
    * `KSM_NPAGES_MIN`
    * `KSM_NPAGES_MAX`
    * `KSM_THRES_COEF`
    * `KSM_THRES_CONST`

    defaults to: `{}`


Limitations
-----------

At present, only support for `$::osfamily == 'RedHat'` has been implemented.

### Tested Platforms

* el6.x


Support
-------

Please log tickets and issues at
[github](https://github.com/jhoblitt/puppet-ksm/issues)


See Also
--------

* [Linux Kernel `vm/ksm.txt`](https://www.kernel.org/doc/Documentation/vm/ksm.txt)
* [IBM KVM docs on Kernel same-page merging (KSM)](http://pic.dhe.ibm.com/infocenter/lnxinfo/v3r0m0/index.jsp?topic=%2Fliaat%2Fliaatbpksm.htm)
* [linux-kvm.com article on KSM](http://www.linux-kvm.com/content/using-ksm-kernel-samepage-merging-kvm)
* [Wikipedia article on Kernel SamePage Merging (KSM)](https://en.wikipedia.org/wiki/Kernel_SamePage_Merging_%28KSM%29)
* [`rodjek/logrotate`](https://github.com/rodjek/puppet-logrotate)
