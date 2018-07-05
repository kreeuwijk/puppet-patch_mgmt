# frozen_string_literal: true

Facter.add('patch_mgmt_psmodule') do
  confine kernel: 'windows'
  setcode do
    sysroot = ENV['SystemRoot']
    powershell = "#{sysroot}\\system32\\WindowsPowerShell\\v1.0\\powershell.exe"
    # get the script path relative to facter Ruby program
    checker_script = File.join(
      File.expand_path(File.dirname(__FILE__)),
      '..',
      'patch_mgmt',
      'patch_mgmt_psmodule.ps1',
    )
    result = Facter::Util::Resolution.exec("#{powershell} -ExecutionPolicy Unrestricted -File #{checker_script}")
    if result.to_s.casecmp('true').zero?
      true
    elsif result.to_s.casecmp('false').zero?
      false
    end
  end
end
