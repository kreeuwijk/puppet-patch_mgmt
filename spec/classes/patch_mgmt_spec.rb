# frozen_string_literal: true

require 'spec_helper'

describe 'patch_mgmt' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) {
        os_facts
        facts.merge({ :powershell_version => '4.0' })
      }

      it { is_expected.to compile }
    end
  end
end
