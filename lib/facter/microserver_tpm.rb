# Fact to discern if the TPM module is fitted
Facter.add(:microserver_tpm) do

  :confine :kernel => 'Linux'
  :confine :manufacturer => 'HP'
  :confine :productname => 'MicroServer'

  setcode do
    # Relying on the Linux kernel/distribution to have loaded the module here
    FileTest.directory?('/sys/class/misc/tpm0')
  end
end
