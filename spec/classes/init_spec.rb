require 'spec_helper'
describe 'molly_guard', type: 'class' do
  platforms = {
    'debian6' =>
      { osfamily: 'Debian',
        release: '6.0',
        majrelease: '6',
        lsbdistcodename: 'squeeze',
        packages: 'molly_guard' },
    'debian7' =>
      { osfamily: 'Debian',
        release: '7.0',
        majrelease: '7',
        lsbdistcodename: 'wheezy',
        packages: 'molly_guard' },
    'debian8' =>
      { osfamily: 'Debian',
        release: '8.0',
        majrelease: '8',
        lsbdistcodename: 'jessie',
        packages: 'molly_guard' },
    'ubuntu1004' =>
      { osfamily: 'Debian',
        release: '10.04',
        majrelease: '10',
        lsbdistcodename: 'lucid',
        packages: 'molly_guard' },
    'ubuntu1204' =>
      { osfamily: 'Debian',
        release: '12.04',
        majrelease: '12',
        lsbdistcodename: 'precise',
        packages: 'molly_guard' },
    'ubuntu1404' =>
      { osfamily: 'Debian',
        release: '14.04',
        majrelease: '14',
        lsbdistcodename: 'trusty',
        packages: 'molly_guard' },
    'ubuntu1604' =>
      { osfamily: 'Debian',
        release: '16.04',
        majrelease: '16',
        lsbdistcodename: 'xenial',
        packages: 'molly_guard' },
  }

  describe 'with default values for parameters on' do
    platforms.sort.each do |k, v|
      context k.to_s do
        let :facts do
          { lsbdistcodename: v[:lsbdistcodename],
            osfamily: v[:osfamily],
            kernelrelease: v[:release], # Solaris specific
            operatingsystemrelease: v[:release], # Linux specific
            operatingsystemmajrelease: v[:majrelease] }
        end

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_class('molly_guard') }

        if v[:packages].class == Array
          v[:packages].each do |pkg|
            it do
              is_expected.to contain_package(pkg).with('ensure' => 'present',
                                                       'provider' => nil)
            end
          end
        else
          it do
            is_expected.to contain_package(v[:packages]).with('ensure' => 'present',
                                                              'provider' => nil)
          end
        end

        it do
          is_expected.to contain_file('/etc/molly-guard/rc').with('ensure' => 'file',
                                                                  'owner'   => 'root',
                                                                  'group'   => 'root',
                                                                  'mode'    => '0644')
        end

        molly_guard_rc_fixture = File.read(fixtures("rc.#{k}"))
        it { is_expected.to contain_file('/etc/molly-guard/rc').with_content(molly_guard_rc_fixture) }
      end
    end
  end

  describe 'parameter functionality' do
    let(:facts) do
      {
        osfamily: 'Debian',
        lsbdistcodename: 'squeeze',
      }
    end

    context 'when always_query_hostname is set to valid bool <true>' do
      let(:params) { { always_query_hostname: true } }

      it { is_expected.to contain_file('/etc/molly-guard/rc').with_content(%r{^ALWAYS_QUERY_HOSTNAME=true$}) }
    end

    context 'when package_ensure is set to valid string <absent>' do
      let(:params) { { package_ensure: 'absent' } }

      it { is_expected.to contain_package('molly_guard').with_ensure('absent') }
    end

    context 'when package_name is set to valid string <molly-guard>' do
      let(:params) { { package_name: 'molly-guard' } }

      it { is_expected.to contain_package('molly_guard').with_name('molly-guard') }
    end
  end

  describe 'failures' do
    let(:facts) do
      {
        osfamily: 'Debian',
        lsbdistcodename: 'squeeze',
      }
    end

    context 'when osfamily is unsupported' do
      let :facts do
        { osfamily: 'Unsupported',
          operatingsystemmajrelease: '9' }
      end

      it 'fails' do
        expect {
          is_expected.to contain_class('molly-guard')
        }.to raise_error(Puppet::Error, %r{molly_guard supports osfamilies Debian\. Detected osfamily is <Unsupported>\.})
      end
    end
  end

  describe 'variable type and content validations' do
    # set needed custom facts and variables
    let(:facts) do
      {
        osfamily: 'Debian',
        operatingsystemrelease: '6.0',
        operatingsystemmajrelease: '6',
        lsbdistcodename: 'squeeze',
      }
    end
    let(:validation_params) do
      {
        #:param => 'value',
      }
    end

    validations = {
      'bool_stringified' => {
        name: %w[always_query_hostname],
        valid: [true, 'true', false, 'false'],
        invalid: ['invalid', 3, 2.42, %w[array], { 'ha' => 'sh' }, nil],
        message: '(is not a boolean|Unknown type of boolean)',
      },
      'string' => {
        name: %w[package_ensure package_name],
        valid: ['present'],
        invalid: [%w[array], { 'ha' => 'sh' }],
        message: 'is not a string',
      },
    }

    validations.sort.each do |type, var|
      var[:name].each do |var_name|
        var[:valid].each do |valid|
          context "with #{var_name} (#{type}) set to valid #{valid} (as #{valid.class})" do
            let(:params) { validation_params.merge(:"#{var_name}" => valid) }

            it { is_expected.to compile }
          end
        end

        var[:invalid].each do |invalid|
          context "with #{var_name} (#{type}) set to invalid #{invalid} (as #{invalid.class})" do
            let(:params) { validation_params.merge(:"#{var_name}" => invalid) }

            it 'fails' do
              expect {
                catalogue
              }.to raise_error(Puppet::Error, %r{#{var[:message]}})
            end
          end
        end
      end # var[:name].each
    end # validations.sort.each
  end # describe 'variable type and content validations'
end
