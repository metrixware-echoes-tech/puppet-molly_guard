require 'spec_helper'
describe 'molly_guard', :type => 'class' do

  context "On a Debian OS with no package name specified" do
    let :facts do
      {
        :osfamily => 'Debian'
      }
    end

    it {
      should contain_package('molly-guard')
    }
  end

  context "On an unknown OS with no package name specified" do
    let :facts do
      {
        :osfamily => 'Darwin'
      }
    end

    it {
      expect { should raise_error(Puppet::Error) }
    }
  end
end
