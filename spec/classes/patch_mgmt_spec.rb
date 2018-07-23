# frozen_string_literal: true

require 'spec_helper'

describe 'patch_mgmt' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :powershell_version      => '4.0',
          :patch_mgmt_psmodulepath => 'C:\Program Files\WindowsPowerShell\Modules',
        })
      end

      it { is_expected.to compile }
    end
  end
end
