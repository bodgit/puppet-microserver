require 'facter/util/file_read'

# Fact to discern if the remote management card is present
Facter.add(:microserver_ilo) do

  confine :kernel => 'Linux'
  confine :manufacturer => 'HP'
  confine :productname => 'ProLiant MicroServer'

  setcode do
    found = false

    # Check for the PCI bridge and the device behind it
    Dir.glob('/sys/bus/pci/devices/0000:??:00.0').each do |parent|
      if Facter::Util::FileRead.read(File.join(parent, 'vendor')) == "0x1a03\n" and
         Facter::Util::FileRead.read(File.join(parent, 'device')) == "0x1150\n"

        Dir.glob(File.join(parent, '0000:??:00.0')).each do |child|
          if Facter::Util::FileRead.read(File.join(child, 'vendor')) == "0x1a03\n" and
             Facter::Util::FileRead.read(File.join(child, 'device')) == "0x2000\n"
            found = true
          end
        end
      end
    end

    found
  end
end
