require 'spec_helper'

describe 'microserver' do

  let(:facts) do
    {
      :manufacturer    => 'HP',
      :productname     => 'ProLiant MicroServer',
      :microserver_ilo => false,
      :microserver_tpm => false
    }
  end

  context 'on unsupported hardware' do
    let(:facts) do
      super().merge(
        {
          :manufacturer => 'Daddies',
          :productname  => 'ProLiant MassiveServer'
        }
      )
    end

    it do
      expect { subject }.to raise_error(/not supported on Daddies ProLiant MassiveServer hardware/)
    end
  end

  context 'on unsupported distributions' do
    let(:facts) do
      super().merge(
        {
          :osfamily => 'Unsupported'
        }
      )
    end

    it do
      expect { subject }.to raise_error(/not supported on an Unsupported/)
    end
  end

  context 'on RedHat' do
    let(:facts) do
      super().merge(
        {
          :osfamily => 'RedHat'
        }
      )
    end

    context 'version 6' do
      let(:facts) do
        super().merge(
          {
            :operatingsystemmajrelease => 6,
          }
        )
      end

      context 'dot 3', :compile do
        let(:facts) do
          super().merge(
            {
              :operatingsystemrelease => '6.3',
            }
          )
        end

        it do
          should contain_class('microserver')
          should_not contain_class('rngd')
          should_not contain_class('ipmi')
          should_not contain_class('watchdog')
          should_not contain_file('/etc/modprobe.d/sp5100_tco.conf')
        end

        context 'with ILO present', :compile do
          let(:facts) do
            super().merge(
              {
                :microserver_ilo => true,
              }
            )
          end

          it do
          end
        end

        context 'with TPM present', :compile do
          let(:facts) do
            super().merge(
              {
                :microserver_tpm => true,
              }
            )
          end

          it do
            should contain_class('rngd')
          end
        end
      end

      context 'dot 4', :compile do
        let(:facts) do
          super().merge(
            {
              :operatingsystemrelease => '6.4',
            }
          )
        end

        it do
          should contain_class('microserver')
          should_not contain_class('rngd')
          should_not contain_class('ipmi')
          should_not contain_class('watchdog')
          should_not contain_file('/etc/modprobe.d/sp5100_tco.conf')
        end

        context 'with ILO present', :compile do
          let(:facts) do
            super().merge(
              {
                :microserver_ilo => true,
              }
            )
          end

          it do
          end
        end

        context 'with TPM present', :compile do
          let(:facts) do
            super().merge(
              {
                :microserver_tpm => true,
              }
            )
          end

          it do
            should contain_class('rngd')
          end
        end
      end
    end

    context 'version 7', :compile do
      let(:facts) do
        super().merge(
          {
            :operatingsystemmajrelease => 7,
          }
        )
      end

      it do
        should contain_class('microserver')
        should_not contain_class('rngd')
        should_not contain_class('ipmi')
        should contain_class('watchdog')
        should contain_file('/etc/modprobe.d/sp5100_tco.conf').with(
          'ensure' => 'absent'
        ).that_notifies('Class[watchdog]')
      end

      context 'with ILO present', :compile do
        let(:facts) do
          super().merge(
            {
              :microserver_ilo => true,
            }
          )
        end

        it do
          should contain_class('ipmi').that_notifies('Class[watchdog]')
          should contain_exec('modprobe -r sp5100_tco').that_requires('File[/etc/modprobe.d/sp5100_tco.conf]').that_notifies('Class[watchdog]')
          should contain_file('/etc/modprobe.d/ipmi.conf').with(
            'ensure'  => 'file',
            'content' => "options ipmi_si type=kcs ports=0xca2\n"
          ).that_notifies('Class[ipmi]')
          should contain_file('/etc/modprobe.d/sp5100_tco.conf').with(
            'ensure'  => 'file',
            'content' => "blacklist sp5100_tco\n"
          )
        end
      end

      context 'with TPM present', :compile do
        let(:facts) do
          super().merge(
            {
              :microserver_tpm => true,
            }
          )
        end

        it do
          should contain_class('rngd')
        end
      end
    end
  end
end
