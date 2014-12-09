#
class microserver::params {

  if $::manufacturer != 'HP' or $::productname != 'MicroServer' {
    fail("The ${module_name} module is not supported on ${::manufacturer} ${::productname} hardware.") # lint:ignore:80chars
  }

  case $::osfamily {
    'RedHat': {
      $install_rngd     = str2bool($::microserver_tpm)
      $install_ipmi     = str2bool($::microserver_ilo)

      case $::operatingsystemmajrelease {
        6: {
          # RHEL/CentOS 6.4+ compiled the ipmi_si driver into the kernel
          if versioncmp($::operatingsystemrelease, '6.4') >= 0 {
            $ipmi_driver_type = 'builtin'
          } else {
            $ipmi_driver_type = 'module'
          }
          $install_watchdog = $install_ipmi
        }
        7: {
          $ipmi_driver_type = 'module'
          $install_watchdog = true
        }
        default: {
          fail("The ${module_name} module is not support on an ${::osfamily} ${::operatingsystemmajrelease} based system.") # lint:ignore:80chars
        }
      }

      $watchdog_type = $install_ipmi ? {
        true    => 'ipmi',
        default => 'tco',
      }
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.") # lint:ignore:80chars
    }
  }
}
