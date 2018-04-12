require 'spec_helper'

describe 'molly_guard' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_class('molly_guard') }

        it do
          is_expected.to contain_package('molly_guard').with('ensure'   => 'present',
                                                             'name'     => 'molly-guard',
                                                             'provider' => nil)
        end

        it do
          is_expected.to contain_file('/etc/molly-guard/rc').with('ensure' => 'file',
                                                                  'owner'  => 'root',
                                                                  'group'  => 'root',
                                                                  'mode'   => '0644')
        end

        molly_guard_rc_fixture = File.read(fixtures("rc.#{facts[:osfamily]}"))
        it { is_expected.to contain_file('/etc/molly-guard/rc').with_content(molly_guard_rc_fixture) }

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
      end
    end
  end

  describe 'failures' do
    let(:facts) do
      {
        osfamily:        'Debian',
        lsbdistcodename: 'squeeze',
      }
    end

    context 'when osfamily is unsupported' do
      let :facts do
        { osfamily:                  'Unsupported',
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
        osfamily:                  'Debian',
        operatingsystemrelease:    '6.0',
        operatingsystemmajrelease: '6',
        lsbdistcodename:           'squeeze',
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
