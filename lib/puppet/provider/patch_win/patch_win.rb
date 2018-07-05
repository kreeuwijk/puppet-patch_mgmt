# frozen_string_literal: true

require 'open3'
require 'puppet/resource_api/simple_provider'

# Implementation for the patch_win type using the Resource API.
class Puppet::Provider::PatchWin::PatchWin < Puppet::ResourceApi::SimpleProvider
  # confine kernel: 'windows'
  # confine patch_mgmt_psmodule: true

  commands :powershell =>
    if File.exists?("#{ENV['SYSTEMROOT']}\\sysnative\\WindowsPowershell\\v1.0\\powershell.exe")
      "#{ENV['SYSTEMROOT']}\\sysnative\\WindowsPowershell\\v1.0\\powershell.exe"
    elsif File.exists?("#{ENV['SYSTEMROOT']}\\system32\\WindowsPowershell\\v1.0\\powershell.exe")
      "#{ENV['SYSTEMROOT']}\\system32\\WindowsPowershell\\v1.0\\powershell.exe"
    else
      'powershell.exe'
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
    stdin, stdout, stderr = Open3.popen3(powershell([get_patches]))
    stdout
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
