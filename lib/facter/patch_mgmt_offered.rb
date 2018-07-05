# frozen_string_literal: true

require 'json'

Facter.add('patch_mgmt_offered_updates') do
  confine kernel: 'windows'
  confine patch_mgmt_psmodule: true
  setcode do
    sysroot = ENV['SystemRoot']
    powershell = "#{sysroot}\\system32\\WindowsPowerShell\\v1.0\\powershell.exe"
    # get the script path relative to facter Ruby program
    checker_script = File.join(
      File.expand_path(File.dirname(__FILE__)),
      '..',
      'patch_mgmt',
      'patch_mgmt_offered.ps1',
    )
    JSON.parse(Facter::Util::Resolution.exec("#{powershell} -ExecutionPolicy Unrestricted -File #{checker_script}"))
  end
end
