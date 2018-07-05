# frozen_string_literal: true

require 'puppet/resource_api/simple_provider'

# Implementation for the patch_win type using the Resource API.
class Puppet::Provider::PatchWin::PatchWin < Puppet::ResourceApi::SimpleProvider
  # confine kernel: 'windows'
  # confine patch_mgmt_psmodule: true

  def initialize
    powershell = if File.exist?("#{ENV['SYSTEMROOT']}\\sysnative\\WindowsPowershell\\v1.0\\powershell.exe")
                   "#{ENV['SYSTEMROOT']}\\sysnative\\WindowsPowershell\\v1.0\\powershell.exe"
                 elsif File.exist?("#{ENV['SYSTEMROOT']}\\system32\\WindowsPowershell\\v1.0\\powershell.exe")
                   "#{ENV['SYSTEMROOT']}\\system32\\WindowsPowershell\\v1.0\\powershell.exe"
                 else
                   'powershell.exe'
                 end
    @patch_win_cmd = Puppet::ResourceApi::Command.new powershell
  end

  def get(context)
    get_patches = <<~EOS
      $PatchList = @()
      $arrUpdates = @(Get-CimInstance -ClassName Win32_QuickFixEngineering -Namespace "root\cimv2")
      $arrUpdates | ForEach-Object {
        $patch = @{
          name = $_.HotFixID
          ensure = 'present'
        }
        $PatchList += $patch
        $patch = $null
      }
      $PatchList | ConvertTo-JSON
    EOS
    result = @patch_win_cmd.run(context, get_patches)
    result
  end

  def create(context, name, should)
    context.notice("Creating '#{name}' with #{should.inspect}")
  end

  def update(context, name, should)
    context.notice("Updating '#{name}' with #{should.inspect}")
  end

  def delete(context, name)
    context.notice("Deleting '#{name}'")
  end
end
