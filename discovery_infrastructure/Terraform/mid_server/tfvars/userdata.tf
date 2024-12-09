locals {
  login_user_name     = data.vault_generic_secret.mid_server_pub_key.data["mid_server_login_user"]
  login_user_password = data.vault_generic_secret.mid_server_pub_key.data["mid_server_login_password"]
}

data "template_file" "open_sshd_exec" {
  /*template = (file(
    "${path.module}/templates/opensshd.ps1"
  ))*/
  template = <<EOF
                  <powershell>
                  Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0

                  # Install the OpenSSH Server
                  Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

                  # Start the sshd service
                  Start-Service sshd

                  # OPTIONAL but recommended:
                  Set-Service -Name sshd -StartupType 'Automatic'

                  # Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
                  if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
                      Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
                      New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
                  }
                  else {
                      Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
                  }

                  #========================Adding Local User========================================

                  $midserveruser = "${local.login_user_name}"
                  $midserverpassword = "${local.login_user_password}"
                  $secureString = ConvertTo-SecureString $midserverpassword -AsPlainText -Force

                  New-LocalUser -Name $midserveruser -Password $secureString -FullName $midserveruser -Description "mid server login user"

                  Add-LocalGroupMember -Group Administrators -Member $midserveruser
                  Add-LocalGroupMember -Group "Remote Desktop Users" -Member $midserveruser  

                  #============================Disable Admin Account=====================================

                  net user administrator /active:no 

                  #============================Disable NetBIOS============================================

                  Get-CimInstance -ClassName 'Win32_NetworkAdapterConfiguration' | Where-Object -Property 'TcpipNetbiosOptions' -ne $null | Invoke-CimMethod -MethodName 'SetTcpipNetbios' -Arguments @{ 'TcpipNetbiosOptions' = [UInt32](2) }

                  #============================Disable LLMNR===============================================

                  New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT" -Name DNSClient -Force
                  New-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" -Name EnableMultiCast -Value 0 -PropertyType DWORD -Force

                  #=============================Disable mDNS=================================================

                  set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters\" -Name EnableMDNS -Value 0 -Type DWord
                  REG ADD  "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v " EnableMDNS" /t REG_DWORD /d "0" /f
 
            </powershell>
            EOF
}
