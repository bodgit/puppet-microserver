#
class microserver (
  $install_rngd     = $::microserver::params::install_rngd,
  $install_ipmi     = $::microserver::params::install_ipmi,
  $install_watchdog = $::microserver::params::install_watchdog,
  $ipmi_driver_type = $::microserver::params::ipmi_driver_type,
  $watchdog_type    = $::microserver::params::watchdog_type
) inherits ::microserver::params {

  validate_bool($install_rngd)
  validate_bool($install_ipmi)
  validate_bool($install_watchdog)
  validate_re($ipmi_driver_type, '^(builtin|module)$')
  validate_re($watchdog_type, '^(tco|ipmi)$')

  include ::microserver::config

  anchor { 'microserver::begin': }
  anchor { 'microserver::end': }

  Anchor['microserver::begin'] -> Class['::microserver::config']
    -> Anchor['microserver::end']
}
