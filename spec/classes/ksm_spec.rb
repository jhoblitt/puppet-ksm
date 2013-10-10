require 'spec_helper'

describe 'ksm', :type => :class do

  describe 'for osfamily RedHat' do
    let(:facts) {{ :osfamily => 'RedHat' }}

    it do
      should contain_class('ksm')
      should contain_package('qemu-kvm')
    end
  end

end
