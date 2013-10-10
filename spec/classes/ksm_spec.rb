require 'spec_helper'

describe 'ksm', :type => :class do

  describe 'for osfamily RedHat' do
    let(:facts) {{ :osfamily => 'RedHat' }}

    it do
      should contain_class('ksm')
      should contain_package('qemu-kvm')
      should contain_service('ksm').with({
        :enable     => 'true',
        :hasrestart => 'true',
        :hasstatus  => 'true',
      })
      should contain_service('ksmtuned').with({
        :ensure     => 'running',
        :enable     => 'true',
        :hasrestart => 'true',
        :hasstatus  => 'true',
      })
    end
  end

end
