#Dot-sourcing to Operational Helper and helper  files
. .\Helper\OperationalHelper.ps1
. .\Helper\helper.ps1
Function main{
#====RemoteDesktop============
Print_Seprator "RemoteDesktop"
Write-Host "Parsing Successsful Logons"
SuccessfulLogons $NoSecurity

Write-Host "Parsing UnSuccesssful Logons"
UnSuccessfulLogons $NoSecurity

Write-Host "Parsing RDP Sessions Began"
RDPBegainSession

Write-Host "Parsing RDP Connections Attempts"
RDPConnectionsAttempts

Write-Host "Parsing RDP Connections Established"
RDPConnectionEstablished

Write-Host "Parsing RDP Local Successful Logons 1"
RDPLocalSuccessfulLogon1

Write-Host "Parsing RDP Local Successful Logons 2"
RDPLocalSuccessfulLogon2

Write-Host "Parsing RDP Successful TCP Connections"
RDPSuccessfulTCPConnections

Write-Host "Parsing RDP Sessions Reconnected"
RDPReconnected $NoSecurity

Write-Host "Parsing RDP Sessions Disconnected"
RDPDisconnected $NoSecurity


#=====MapNetworkShare===============
Print_Seprator "MapNetworkShare"
Write-Host "Parsing Network Share Object Accessed"
NetworkShareAccessed $NoSecurity

Write-Host "Parsing Network Share Object Checked"
NetworkShareChecked $NoSecurity

Write-Host "Parsing Admin Logons Created"
AdminLogonCreated $NoSecurity

Write-Host "Parsing Domain Controller attempts to validate accounts' credentials"
ComputerToValidate $NoSecurity

Write-Host "Parsing Kerberos Authentications Requested"
KerberosAuthenticationRequested $NoSecurity

Write-Host "Parsing Kerberos Services Requested"
KerberosServiceRequested $NoSecurity


#=======PsExec==========
Print_Seprator "Powershell Execution"
Write-Host "Parsing Installed Services [System Log]"
SystemInstalledServices

#=====ScheduledTasks============ 
Print_Seprator "ScheduledTasks"
Write-Host "Parsing Scheduled Tasks Created [Security Log]"
ScheduledTaskCreatedSec $NoSecurity

Write-Host "Parsing Scheduled Tasks Deleted [Security Log]"
ScheduledTaskDeletedSec $NoSecurity

Write-Host "Parsing Scheduled Tasks Enabled [Security Log]"
ScheduledTaskEnabledSec $NoSecurity

Write-Host "Parsing Scheduled Tasks Disabled [Security Log]"
ScheduledTaskDisabledSec $NoSecurity

Write-Host "Parsing Scheduled Tasks Updated [Security Log]"
ScheduledTaskUpdatedSec $NoSecurity

Write-Host "Parsing Scheduled Tasks Created [Task Scheduler Log]"
ScheduledTasksCreatedTS 

Write-Host "Parsing Scheduled Tasks Deleted [Task Scheduler Log]"
ScheduledTasksDeletedTS 

Write-Host "Parsing Scheduled Tasks Executed [Task Scheduler Log]"
ScheduledTasksExecutedTS

Write-Host "Parsing Scheduled Tasks Completed [Task Scheduler Log]"
ScheduledTasksCompletedTS

Write-Host "Parsing Scheduled Tasks Updated [Task Scheduler Log]"
ScheduledTasksUpdatedTS

#======WMI ==================
Print_Seprator "WMI/WMIC"
Write-Host "Parsing WMI Operations Started"
WMIOperationStarted

Write-Host "Parsing WMI Operations Temporary Ess Started"
WMIOperationTemporaryEssStarted

Write-Host "Parsing WMI Operations To Consumer Binding"
WMIOperationESStoConsumerBinding


#=======Services========
Print_Seprator "Services"
Write-Host "Parsing Installed Services [Security Log]"
InstalledServices $NoSecurity

Write-Host "Parsing Services Crashed Unexpectedely"
ServiceCrashedUnexpect

Write-Host "Parsing Services Status"
ServicesStatus

Write-Host "Parsing Services Requested Start Stop Controls"
ServiceSentStartStopControl

Write-Host "Parsing Services Start Type Changed"
ServiceStartTypeChanged

#======PowerShellRemoting 
Print_Seprator "PowerShellRemoting"
Write-Host "Parsing PowerShell Module Logging"
PSModuleLogging

Write-Host "Parsing PowerShell Script Blocking Logging"
PSScriptBlockLogging

Write-Host "Parsing PowerShell Authneticating User"
PSAuthneticatingUser

Write-Host "Parsing PowerShell Partial Code"
PSPartialCode

Write-Host "Parsing Session Created"
SessionCreated

Write-Host "Parsing WinRM Authenticating User "
WinRMAuthneticatingUser

Write-Host "Parsing Server Remote Hosts Started"
ServerRemoteHostStarted

Write-Host "Parsing Server Remote Host Ended"
ServerRemoteHostEnded

}
main
$ResultsArray| Out-GridView
