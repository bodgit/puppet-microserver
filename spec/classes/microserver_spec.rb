require 'spec_helper'

describe 'microserver' do

  context 'on unsupported distributions' do
    let(:facts) do
      {
        :osfamily => 'Unsupported'
      }
    end

    it do
      expect { subject }.to raise_error(/not supported on an Unsupported/)
    end
  end

  context 'on RedHat' do
    let(:facts) do
      {
        :osfamily => 'RedHat'
      }
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
      end
    end
  end
end
