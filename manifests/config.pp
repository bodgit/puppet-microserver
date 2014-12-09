#
class microserver::config {

  if $::microserver::install_rngd {
    include ::rngd
  }

  if $::microserver::install_ipmi {
    if $::microserver::ipmi_driver == 'builtin' {
      kernel_parameter { 'ipmi_si.type':
        value  => 'kcs',
        notify => Notify['IPMI Reboot'],
      }
      kernel_parameter { 'ipmi_si.ports':
        value  => '0xca2'
        notify => Notify['IPMI Reboot'],
      }
      notify { 'IPMI Reboot':
        message => 'A reboot will be required for this to fully work',
      }
    } else {
      file { '/etc/modprobe.d/ipmi.conf':
        ensure  => file,
        owner   => 0,
        group   => 0,
        mode    => '0644',
        content => "options ipmi_si type=kcs ports=0xca2\n",
        before  => Class['::ipmi'],
      }
    }

    # Install OpenIPMI
    class { '::ipmi':
      watchdog => $::microserver::watchdog_type ? {
        'ipmi'  => true,
        default => false,
      },
    }
  }

  if $::microserver::install_watchdog {

    include ::watchdog

    if $::microserver::watchdog_type == 'ipmi' {

      # Blacklist the TCO watchdog driver
      file { '/etc/modprobe.d/sp5100_tco.conf':
        ensure  => file,
        owner   => 0,
        group   => 0,
        mode    => '0644',
        content => "blacklist sp5100_tco\n",
      }

      # Unload the module if it's currently loaded
      exec { 'modprobe -r sp5100_tco':
        path    => ['/usr/sbin', '/usr/bin'],
        onlyif  => 'lsmod | grep -q sp5100_tco',
        require => File['/etc/modprobe.d/sp5100_tco.conf'],
        notify  => Class['::watchdog']
      }

      # Ensure OpenIPMI is started before watchdog
      Class['::ipmi'] ~> Class['::watchdog']
    }
  } else {
    file { '/etc/modprobe.d/sp5100_tco.conf':
      ensure => absent,
      notify => Class['::watchdog'],
    }
  }
}
