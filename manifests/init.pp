# Class: patch_mgmt
# Provides Patch Management information and administration capabilities
#
class patch_mgmt {
  # Install the PSWindowsUpdate module for PowerShell
  $psmoduleversion = '2.0.0.4'
  $psmodulepath = versioncmp($facts['powershell_version'], '5') ? {
    -1      => "${facts['patch_mgmt_psmodulepath']}\\PSWindowsUpdate",
    default => "${facts['patch_mgmt_psmodulepath']}\\PSWindowsUpdate\\${psmoduleversion}"
  }

  $psmodulefiles = [
    'PSWUSettings.xml.tmp',
    'PSWindowsUpdate.Format.ps1xml',
    'PSWindowsUpdate.dll',
    'PSWindowsUpdate.dll-Help.xml',
    'PSWindowsUpdate.psd1',
    'PSWindowsUpdate.psm1'
  ]

  $psmodulefiles.each | $file | {
    file { "${psmodulepath}\\${file}":
      ensure => 'present',
      source => "puppet:///files/${psmoduleversion}/${file}"
    }
  }

}
