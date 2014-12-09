# Fact to discern if the remote management card is present
Facter.add(:microserver_ilo) do

  confine :kernel => 'Linux'
  confine :manufacturer => 'HP'
  confine :productname => 'ProLiant MicroServer'

  setcode do
    sysfs_root = '/sys/bus/pci/devices/0000:01:00.0/'

    # Check for the PCI bridge and the device behind it
    if Facter::Util::FileRead.read(sysfs_root + 'vendor') == "0x1a03\n" and
       Facter::Util::FileRead.read(sysfs_root + 'device') == "0x1150\n" and
       Facter::Util::FileRead.read(sysfs_root + '0000:02:00.0/vendor') == "0x1a03\n" and
       Facter::Util::FileRead.read(sysfs_root + '0000:02:00.0/device') == "0x2000\n"
      true
    else
      false
    end
  end
end
