# frozen_string_literal: true

require 'base64'
require 'puppet/resource_api/simple_provider'

# Implementation for the patch_win type using the Resource API.
class Puppet::Provider::PatchWin::PatchWin < Puppet::ResourceApi::SimpleProvider
  # confine kernel: 'windows'
  # confine patch_mgmt_psmodule: true

  def initialize
    @powershell = if File.exist?("#{ENV['SYSTEMROOT']}\\sysnative\\WindowsPowershell\\v1.0\\powershell.exe")
                    "#{ENV['SYSTEMROOT']}\\sysnative\\WindowsPowershell\\v1.0\\powershell.exe"
                  elsif File.exist?("#{ENV['SYSTEMROOT']}\\system32\\WindowsPowershell\\v1.0\\powershell.exe")
                    "#{ENV['SYSTEMROOT']}\\system32\\WindowsPowershell\\v1.0\\powershell.exe"
                  else
                    'powershell.exe'
                  end
  end

  def powershell_cmd(pscode)
    encoded_cmd = Base64.strict_encode64(pscode.encode('utf-16le'))
    exec("#{@powershell} -encodedCommand #{encoded_cmd}")
  end

  def get(_context)
    get_patches = <<~EOS
      $PatchList = @()
      $arrUpdates = @(Get-CimInstance -ClassName Win32_QuickFixEngineering)
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
    powershell_cmd(get_patches)
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
