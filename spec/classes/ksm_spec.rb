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
      should contain_logrotate__rule('ksmtuned').with({
        :path          => '/var/log/ksmtuned',
        :rotate_every  => 'weekly',
        :missingok     => true,
        :rotate        => 4,
        :compress      => true,
        :delaycompress => true,
        :copytruncate  => true,
        :minsize       => '100k',
      })
    end
  end

  context 'for osfamily RedHat' do
    let(:facts) {{ :osfamily => 'RedHat' }}

    context 'no params' do
      it_behaves_like 'ksm'
      it do
        verify_contents(catalogue, '/etc/sysconfig/ksm', [
          '# KSM_MAX_KERNEL_PAGES=',
        ])
      end
    end

    context 'ksm_config => {}' do
      let(:params) {{ :ksm_config => {} }}

      it_behaves_like 'ksm'
      it do
        verify_contents(catalogue, '/etc/sysconfig/ksm', [
          '# KSM_MAX_KERNEL_PAGES=',
        ])
      end
    end

    context 'ksm_config => { KSM_MAX_KERNEL_PAGES => 0 }' do
      let(:params) {{ :ksm_config => { 'KSM_MAX_KERNEL_PAGES' => 0 } }}

      it_behaves_like 'ksm'
      it do
        verify_contents(catalogue, '/etc/sysconfig/ksm', [
          'KSM_MAX_KERNEL_PAGES=0',
        ])
      end
    end

    context 'ksmtuned_config => {}' do
      let(:params) {{ :ksmtuned_config => {} }}

      it_behaves_like 'ksm'
      it do
        with_options = %w{
          LOGFILE=/var/log/ksmtuned
          DEBUG=1
        }
        without_options = %w{
          KSM_MONITOR_INTERVAL
          KSM_SLEEP_MSEC
          KSM_NPAGES_BOOST
          KSM_NPAGES_DECAY
          KSM_NPAGES_MIN
          KSM_NPAGES_MAX
          KSM_THRES_COEF
          KSM_THRES_CONST
        }

        with_options.each do |opt|
          should contain_file('/etc/ksmtuned.conf').
            with_content(/^#{opt}/)
        end
        without_options.each do |opt|
          should_not contain_file('/etc/ksmtuned.conf').
            with_content(/^#{opt}/)
        end
      end
    end

    context 'ksmtuned_config => { ... }' do
      let(:params) do
        {
          :ksmtuned_config => {
            'KSM_MONITOR_INTERVAL' => '1',
            'KSM_SLEEP_MSEC'       => '2',
            'KSM_NPAGES_BOOST'     => '3',
            'KSM_NPAGES_DECAY'     => '4',
            'KSM_NPAGES_MIN'       => '5',
            'KSM_NPAGES_MAX'       => '6',
            'KSM_THRES_COEF'       => '7',
            'KSM_THRES_CONST'      => '8',
          }
        }
      end

      it_behaves_like 'ksm'
      it do
        with_options = %w{
          KSM_MONITOR_INTERVAL=1
          KSM_SLEEP_MSEC=2
          KSM_NPAGES_BOOST=3
          KSM_NPAGES_DECAY=4
          KSM_NPAGES_MIN=5
          KSM_NPAGES_MAX=6
          KSM_THRES_COEF=7
          KSM_THRES_CONST=8
          LOGFILE=/var/log/ksmtuned
          DEBUG=1
        }
        with_options.each do |opt|
          should contain_file('/etc/ksmtuned.conf').
            with_content(/^#{opt}/)
        end
      end
    end
  end

end
