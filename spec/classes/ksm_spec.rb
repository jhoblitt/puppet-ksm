require 'spec_helper'

describe 'ksm', :type => :class do

  describe 'for osfamily RedHat' do
    it { should contain_class('ksm') }
  end

end
