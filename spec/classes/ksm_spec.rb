require 'spec_helper'

describe 'ksm', :type => :class do

  shared_examples 'ksm' do
    it do
      should contain_class('ksm')
      should contain_package('qemu-kvm')
      should contain_file('/etc/sysconfig/ksm').with({
        :ensure => 'file',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0644',
      })
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

  context 'for osfamily RedHat' do
    let(:facts) {{ :osfamily => 'RedHat' }}

    context 'no params' do
      it_behaves_like 'ksm'
      it do
        verify_contents(subject, '/etc/sysconfig/ksm', [
          '# KSM_MAX_KERNEL_PAGES=',
        ])
      end
    end

    context 'ksm_config => {}' do
      let(:params) {{ :ksm_config => {} }}
      it_behaves_like 'ksm'
      it do
        verify_contents(subject, '/etc/sysconfig/ksm', [
          '# KSM_MAX_KERNEL_PAGES=',
        ])
      end
    end

    context 'ksm_config => { KSM_MAX_KERNEL_PAGES => 0 }' do
      let(:params) {{ :ksm_config => { 'KSM_MAX_KERNEL_PAGES' => 0 } }}
      it_behaves_like 'ksm'
      it do
        verify_contents(subject, '/etc/sysconfig/ksm', [
          'KSM_MAX_KERNEL_PAGES=0',
        ])
      end
    end
  end

end
