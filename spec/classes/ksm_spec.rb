require 'spec_helper'

describe 'ksm', :type => :class do

  describe 'for osfamily RedHat' do
    let(:facts) {{ :osfamily => 'RedHat' }}

    it do
      should contain_class('ksm')
      should contain_package('qemu-kvm')
      should contain_file('/etc/sysconfig/ksm').with({
        :ensure => 'file',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0644',
      }).with_content(/# KSM_MAX_KERNEL_PAGES=/)
      should contain_service('ksm').with({
        :enable     => 'true',
        :hasrestart => 'true',
        :hasstatus  => 'true',
      })
      should contain_file('/etc/ksmtuned.conf').with({
        :ensure => 'file',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0644',
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
