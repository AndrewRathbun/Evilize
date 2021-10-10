
#Event Logs Paths
$global:Securityevt_Path = ""
$global:Security_Path = ""
$global:Systemevt_Path = ""
$global:System_Path = ""
$global:RDPCORETS_Path = ""
$global:RDPCORETSevt_Path = ""
$global:WMI_Path = ""
$global:WMIevt_Path = ""
$global:PowerShellOperational_Path = ""
$global:PowerShellOperationalevt_Path = ""
$global:WinPowerShell_Path = ""
$global:WinPowerShellevt_Path = ""
$global:WinRM_Path = ""
$global:WinRMevt_Path = ""
$global:TaskScheduler_Path = ""
$global:TaskSchedulerevt_Path = ""
$global:TerminalServices_Path = ""
$global:TerminalServicesRDP_Path=""
$global:TerminalServicesRDPevt_Path=""
$global:TerminalServiceevt_Path = ""
$global:RemoteConnection_Path = ""
$global:RemoteConnectionevt_Path = ""

## Testing if the log file exist ? 
$global:Valid_Security_Path= ""
$global:Valid_System_Path= ""
$global:Valid_RDPCORETS_Path= ""
$global:Valid_WMI_Path= ""
$global:Valid_PowerShellOperational_Path=""
$global:Valid_WinPowerShell_Path= ""
$global:Valid_WinRM_Path= ""
$global:Valid_TaskScheduler_Path= ""
$global:Valid_TerminalServices_Path= ""
$global:Valid_RemoteConnection_Path= ""
$global:Valid_TerminalServicesRDP_Path=""



$global:Destination_Path=""
$global:RemoteDesktop_Path=""
$global:MapNetworkShares_Path=""
$global:PsExec_Path=""
$global:ScheduledTasks_Path=""
$global:Services_Path=""
$global:WMIOut_Path=""
$global:PowerShellRemoting_Path=""
$global:ExtraEvents_Path=""
$global:SourceEvents_Path_Path=""

#array to store results
$global:ResultsArray= @()

function print_logo {
    param (
        [Parameter(Mandatory = $false)]
        [string]
        $Method
    )
    Write-host "
     ______           _     __    _            
    / ____/ _   __   (_)   / /   (_) ____  ___ 
   / __/   | | / /  / /   / /   / / /_  / / _ \
  / /___   | |/ /  / /   / /   / /   / /_/  __/
 /_____/   |___/  /_/   /_/   /_/   /___/\___/ " -ForegroundColor Red 
    if (($Method -eq 'Logparser' ) -or ($Method -eq '')) {
        Write-Host "
    _    ____ ____ ___  ____ ____ ____ ____ ____ 
    |    |  | | __ |__] |__| |__/ [__  |___ |__/ 
    |___ |__| |__] |    |  | |  \ ___] |___ |  \ "-ForegroundColor green 
    }
    else {
        Write-Host "
    _ _ _ _ _  _ ____ _  _ ____ _  _ ___ 
    | | | | |\ | |___ |  | |___ |\ |  |  
    |_|_| | | \| |___  \/  |___ | \|  | " -ForegroundColor green
    }
}

function Print_Seprator {
    [CmdletBinding()]
    param (
        [Parameter()]
        [String]
        $Name
    )

    Write-Host ""  -ForegroundColor yellow 
    Write-Host ""  -ForegroundColor yellow 
    Write-Host "**********************************************"  -ForegroundColor yellow 
    Write-Host  "              $Name                  "  -ForegroundColor yellow 
    Write-Host  "**********************************************"  -ForegroundColor yellow 
}

function check_logs_path {
    param(
        [string] $Logs_Path
    )

    if (Test-Path -Path "$Logs_Path") {
        return $true
    }
    else{
        Write-Host "Error: Invalid Paths, Please Enter a valid path"
        return $false
    }
}

## Convert evt to evtx
function Evt2Evtx {
    param (
        [Parameter(Mandatory = $true)]
        [string]$EvtPath,
        [Parameter(Mandatory = $true)]
        [string]$EvtxPath
    )
    if (((Test-Path -Path $EvtPath) -eq $true) -and ((Test-Path -Path $EvtxPath) -eq $false)) {
        wevtutil epl $EvtPath $EvtxPath /lf:true    
    }
    else {
        return
    }   
}
function evt_conversion {
    param(
        [string] $Logs_Path
    )
    $global:Security_Path = Join-Path -Path $Logs_Path -ChildPath "Security.evtx"
    $Securityevt_Path = Join-Path -Path $Logs_Path -ChildPath "Security.evt"
    $global:System_Path = Join-Path -Path $Logs_Path -ChildPath "System.evtx"
    $Systemevt_Path = Join-Path -Path $Logs_Path -ChildPath "System.evt"
    $global:RDPCORETS_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evtx"
    $RDPCORETSevt_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evt"
    $global:WMI_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-WMI-Activity%4Operational.evtx"
    $WMIevt_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-WMI-Activity%4Operational.evt"
    $global:PowerShellOperational_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-PowerShell%4Operational.evtx"
    $PowerShellOperationalevt_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-PowerShell%4Operational.evt"
    $global:WinPowerShell_Path = Join-Path -Path $Logs_Path -ChildPath "Windows PowerShell.evtx"
    $WinPowerShellevt_Path = Join-Path -Path $Logs_Path -ChildPath "Windows PowerShell.evt"
    $global:WinRM_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-WinRM%4Operational.evtx"
    $WinRMevt_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-WinRM%4Operational.evt"
    $global:TaskScheduler_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TaskScheduler%4Operational.evtx"
    $TaskSchedulerevt_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TaskScheduler%4Operational.evt"
    $global:TerminalServices_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx"
    $TerminalServiceevt_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evt"
    $global:RemoteConnection_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational.evtx"
    $RemoteConnectionevt_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational.evt"
    $global:TerminalServicesRDP_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-RDPClient%4Operational.evtx"
    $TerminalServicesRDPevt_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-RDPClient%4Operational.evt"
    Evt2Evtx $Securityevt_Path $Security_Path
    Evt2Evtx $Systemevt_Path  $System_Path
    Evt2Evtx $RDPCORETSevt_Path $RDPCORETS_Path
    Evt2Evtx $WMIevt_Path $WMI_Path
    Evt2Evtx $WinPowerShellevt_Path $WinPowerShell_Path
    Evt2Evtx $WinRMevt_Path $WinRM_Path
    Evt2Evtx $TaskSchedulerevt_Path $TaskScheduler_Path
    Evt2Evtx $TerminalServiceevt_Path $TerminalServices_Path
    Evt2Evtx $RemoteConnectionevt_Path $RemoteConnection_Path
    Evt2Evtx $PowerShellOperationalevt_Path $PowerShellOperational_Path  
    Evt2Evtx $TerminalServicesRDPevt_Path $TerminalServicesRDP_Path
}

function check_individual_logs {
    $global:Valid_Security_Path= Test-Path -Path $Security_Path
    $global:Valid_System_Path= Test-Path -Path $System_Path
    $global:Valid_RDPCORETS_Path= Test-Path -Path $RDPCORETS_Path
    $global:Valid_WMI_Path= Test-Path -Path $WMI_Path
    $global:Valid_PowerShellOperational_Path=Test-Path -Path $PowerShellOperational_Path
    $global:Valid_WinPowerShell_Path= Test-Path -Path $WinPowerShell_Path
    $global:Valid_WinRM_Path= Test-Path -Path $WinRM_Path
    $global:Valid_TaskScheduler_Path= Test-Path -Path $TaskScheduler_Path
    $global:Valid_TerminalServices_Path= Test-Path -Path $TerminalServices_Path
    $global:Valid_RemoteConnection_Path= Test-Path -Path $RemoteConnection_Path
    $global:Valid_TerminalServicesRDP_Path= Test-Path -Path $TerminalServicesRDP_Path
}
function csv_output_directories {
    param(
        [string] $Logs_Path
    )
    ##Create Results Directory
    $Destination_Path = Join-Path -Path $Logs_Path -ChildPath "Results"
    if ((Test-Path -Path "$Destination_Path") -eq $false) {
        New-Item -Path $Destination_Path -ItemType Directory    
    }

    $global:RemoteDesktop_Path = Join-Path -Path $Destination_Path -ChildPath "RemoteDesktop"
    if ((Test-Path -Path "$RemoteDesktop_Path") -eq $false) {
        New-Item -Path $RemoteDesktop_Path -ItemType Directory    
    }

    $global:MapNetworkShares_Path = Join-Path -Path $Destination_Path -ChildPath "MapNetworkShares"
    if ((Test-Path -Path "$MapNetworkShares_Path") -eq $false) {
        New-Item -Path $MapNetworkShares_Path -ItemType Directory    
    }

    $global:PsExec_Path = Join-Path -Path $Destination_Path -ChildPath "PsExec"
    if ((Test-Path -Path "$PsExec_Path") -eq $false) {
        New-Item -Path $PsExec_Path -ItemType Directory    
    }

    $global:ScheduledTasks_Path = Join-Path -Path $Destination_Path -ChildPath "ScheduledTasks"
    if ((Test-Path -Path "$ScheduledTasks_Path") -eq $false) {
        New-Item -Path $ScheduledTasks_Path -ItemType Directory    
    }

    $global:Services_Path = Join-Path -Path $Destination_Path -ChildPath "Services"
    if ((Test-Path -Path "$Services_Path") -eq $false) {
        New-Item -Path $Services_Path -ItemType Directory    
    }

    $global:WMIOut_Path = Join-Path -Path $Destination_Path -ChildPath "WMI"
    if ((Test-Path -Path "$WMIOut_Path") -eq $false) {
        New-Item -Path $WMIOut_Path -ItemType Directory    
    }

    $global:PowerShellRemoting_Path = Join-Path -Path $Destination_Path -ChildPath "PowerShellRemoting"
    #Check if PowerShellRemoting already exist
    if ((Test-Path -Path "$PowerShellRemoting_Path") -eq $false) {
        New-Item -Path $PowerShellRemoting_Path -ItemType Directory    
    }

    $global:ExtraEvents_Path = Join-Path -Path $Destination_Path -ChildPath "ExtraEvents"
    #Check if PowerShellRemoting already exist
    if ((Test-Path -Path "$ExtraEvents_Path") -eq $false) {
        New-Item -Path $ExtraEvents_Path -ItemType Directory    
    }

}

function GetStats {
    param (
        [Parameter(Mandatory=$true)]
        [string]$FilePath
    )
    $Valid=Test-Path -Path "$FilePath"
    if($Valid -eq $true){
        (Import-Csv $FilePath).count
        <#$NumRows=LogParser.exe -i:csv -stats:OFF "Select Count (*) from '$FilePath'" | Out-String
        ($NumRows.Substring([int](29))).Trim()
        #>
} 
    else {
        Return 0
    }
}

function AllSuccessfulLogons {
    param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
        Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red
        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4624"
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "AllSuccessfulLogons.csv"
    $Query="SELECT TimeGenerated,EventID , EXTRACT_TOKEN(Strings, 5, '|') as Username, EXTRACT_TOKEN(Strings, 6, '|') as Domain, EXTRACT_TOKEN(Strings, 8, '|') as LogonType,EXTRACT_TOKEN(strings, 9, '|') AS AuthPackage, EXTRACT_TOKEN(Strings, 11, '|') AS Workstation, EXTRACT_TOKEN(Strings, 17, '|') AS ProcessName, EXTRACT_TOKEN(Strings, 18, '|') AS SourceIP INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID  And LogonType<>'5'"  
    LogParser.exe -stats:OFF -i:EVT $Query
    $AllSuccessfulLogons= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="RemoteDesktop"; Event="Successful Logons"; NumberOfOccurences=$AllSuccessfulLogons}
    $global:ResultsArray += $hash
    Write-Host "Successful Logons:" $AllSuccessfulLogons -ForegroundColor Green
}
function UnsuccessfulLogons {
    param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
        Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red
        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4625"
    $OutputFile= Join-Path -Path $ExtraEvents_Path -ChildPath "UnsuccessfulLogons.csv"
    $Query="SELECT TimeGenerated,EventID , EXTRACT_TOKEN(Strings, 5, '|') as Username, EXTRACT_TOKEN(Strings, 6, '|') as Domain, EXTRACT_TOKEN(Strings, 10, '|') as LogonType,EXTRACT_TOKEN(strings, 11, '|') AS AuthPackage, EXTRACT_TOKEN(Strings, 13, '|') AS Workstation, EXTRACT_TOKEN(Strings, 11, '|') AS ProcessName, EXTRACT_TOKEN(Strings, 18, '|') AS ProcessPath ,EXTRACT_TOKEN(Strings, 19, '|') AS SourceIP, EXTRACT_TOKEN(Strings, 20, '|') AS SourcePort INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID  And LogonType<>'5'"  
    LogParser.exe -stats:OFF -i:EVT $Query
    $UnsuccessfulLogons= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="Extra Events"; Event="UnSuccessful Logons"; NumberOfOccurences=$UnsuccessfulLogons}
    $global:ResultsArray += $hash
    Write-Host "UnSuccessful Logons:" $UnsuccessfulLogons -ForegroundColor Green
}

function AdminLogonCreated  {
    param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red

        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4672"
    $OutputFile= Join-Path -Path $MapNetworkShares_Path -ChildPath "AdminLogonCreated.csv"
    $Query="Select TimeGenerated,EventID , EXTRACT_TOKEN(Strings, 1, '|') AS Username, EXTRACT_TOKEN(Strings, 2, '|') AS Domain , EXTRACT_TOKEN(Strings, 3, '|') as LogonID, EXTRACT_TOKEN(Strings, 4, '|') as PrivilegeList INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $AdminLogonsCreated= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="MapNetworkShares"; Event="Admin Logons Created"; NumberOfOccurences=$AdminLogonsCreated}
    $global:ResultsArray+=$hash
    Write-Host "Admin Logons Created: " $AdminLogonsCreated -ForegroundColor Green  
}


function ServiceInstalledonSystem {
      param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red

        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4697"
    $OutputFile= Join-Path -Path $Services_Path -ChildPath "ServiceInstalledonSystem.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS ServiceName, EXTRACT_TOKEN(Strings, 5, '|') AS ServiceFileName, EXTRACT_TOKEN(Strings, 6, '|') AS ServiceType,  EXTRACT_TOKEN(Strings, 7, '|') AS ServiceStartType  INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $ServiceInstalledonSystem= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="Services"; Event="Installed Services [Security Log]"; NumberOfOccurences=$ServiceInstalledonSystem}
    $global:ResultsArray+=$hash
    Write-Host "Installed Services [Security Log]: " $ServiceInstalledonSystem -ForegroundColor Green  
}

function ScheduleTaskCreated {
      param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red

        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4698"
    $OutputFile= Join-Path -Path $ScheduledTasks_Path -ChildPath "ScheduleTaskCreated.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS TaskName, EXTRACT_TOKEN(Strings, 5, '|') AS TaskContent  INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $ScheduleTaskCreated= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="ScheduledTasks"; Event="Scheduled Tasks Created [Security Log]"; NumberOfOccurences=$ScheduleTaskCreated}
    $global:ResultsArray+=$hash
    Write-Host "Scheduled Tasks Created [Security Log]: " $ScheduleTaskCreated -ForegroundColor Green  
}

function ScheduleTaskDeleted {
      param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red

        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4699"
    $OutputFile= Join-Path -Path $ScheduledTasks_Path -ChildPath "ScheduleTaskDeleted.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS TaskName, EXTRACT_TOKEN(Strings, 5, '|') AS TaskContent  INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $ScheduleTaskDeleted= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="ScheduledTasks"; Event="Scheduled Tasks Deleted [Security Log]"; NumberOfOccurences=$ScheduleTaskDeleted}
    $global:ResultsArray+=$hash
    Write-Host "Scheduled Tasks Deleted [Security Log]: " $ScheduleTaskDeleted -ForegroundColor Green  
}

function ScheduleTaskEnabled {
      param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red

        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4700"
    $OutputFile= Join-Path -Path $ScheduledTasks_Path -ChildPath "ScheduleTaskEnabled.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS TaskName, EXTRACT_TOKEN(Strings, 5, '|') AS TaskContent  INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $ScheduleTaskEnabled= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="ScheduledTasks"; Event="Scheduled Tasks Enbaled [Security Log]"; NumberOfOccurences=$ScheduleTaskEnabled}
    $global:ResultsArray+=$hash
    Write-Host "Scheduled Tasks Enbaled [Security Log]: " $ScheduleTaskEnabled -ForegroundColor Green
}

function ScheduleTaskDisabled{
      param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red

        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4701"
    $OutputFile= Join-Path -Path $ScheduledTasks_Path -ChildPath "ScheduleTaskDisabled.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS TaskName, EXTRACT_TOKEN(Strings, 5, '|') AS TaskContent  INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $ScheduleTaskDisabled= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="ScheduledTasks"; Event="Scheduled Tasks Disabled [Security Log]"; NumberOfOccurences=$ScheduleTaskDisabled}
    $global:ResultsArray+=$hash
    Write-Host "Scheduled Tasks Disabled [Security Log]: " $ScheduleTaskDisabled -ForegroundColor Green
}


function ScheduleTaskUpdated{
      param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red

        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4702"
    $OutputFile= Join-Path -Path $ScheduledTasks_Path -ChildPath "ScheduleTaskUpdated.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS TaskName, EXTRACT_TOKEN(Strings, 5, '|') AS TaskContent  INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $ScheduleTaskUpdated= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="ScheduledTasks"; Event="Scheduled Tasks Updated [Security Log]"; NumberOfOccurences=$ScheduleTaskUpdated}
    $global:ResultsArray+=$hash
    Write-Host "Scheduled Tasks Updated [Security Log]: " $ScheduleTaskUpdated -ForegroundColor Green
}


function KerberosAuthRequest {
      param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red

        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4768"
    $OutputFile= Join-Path -Path $MapNetworkShares_Path -ChildPath "KerberosAuthRequest.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS AccountName, EXTRACT_TOKEN(Strings, 1, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 9, '|') AS SourceIP , EXTRACT_TOKEN(Strings, 10, '|') AS SourcePort INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $KerberosAuthRequest= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="MapNetworkShares"; Event="Kerberos Authentication Tickets Requested"; NumberOfOccurences=$KerberosAuthRequest}
    $global:ResultsArray+=$hash
    Write-Host "Kerberos Authentication Tickets Requested: " $KerberosAuthRequest -ForegroundColor Green  
}

function KerberosServiceRequest {
      param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red

        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4769"
    $OutputFile= Join-Path -Path $MapNetworkShares_Path -ChildPath "KerberosServiceRequest.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS AccountName, EXTRACT_TOKEN(Strings, 1, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 2, '|') AS ServiceName ,EXTRACT_TOKEN(Strings, 6, '|') AS SourceIP , EXTRACT_TOKEN(Strings, 7, '|') AS SourcePort INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $KerberosServiceRequest= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="MapNetworkShares"; Event="Kerberos Services Tickets Requested"; NumberOfOccurences=$KerberosServiceRequest}
    $global:ResultsArray+=$hash
    Write-Host "Kerberos Services Tickets Requested: " $KerberosServiceRequest -ForegroundColor Green  
    
}

function ComputerToValidate  {
      param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red

        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4776"
    $OutputFile= Join-Path -Path $MapNetworkShares_Path -ChildPath "ComputerToValidate.csv"
    $Query="Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID " 
    LogParser.exe -stats:OFF -i:EVT $Query
    $ComputerToValidate= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="MapNetworkShares"; Event="Computer to Validate"; NumberOfOccurences=$ComputerToValidate}
    $global:ResultsArray+=$hash
    Write-Host "Computer to validate: " $ComputerToValidate -ForegroundColor Green

}
function EventlogClearedSecurity  {
    param (
      [Parameter(Mandatory=$true)]
      [string]$security
  )
  if($security -eq $false){
              Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red

      return
  }
  if ($Valid_Security_Path -eq $false) {
      write-host "Error: Security event log is not found" -ForegroundColor Red
      return  
  }
  $EventID="1102"
  $OutputFile= Join-Path -Path $ExtraEvents_Path -ChildPath "EventlogClearedSecurity.csv"
  $Query="SELECT TimeGenerated , EXTRACT_TOKEN(Strings, 1, '|') as Username, EXTRACT_TOKEN(Strings, 2, '|') AS DomainName, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
  LogParser.exe -stats:OFF -i:EVT $Query
  $EventlogClearedSec= GetStats $OutputFile
  $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="Extra Events"; Event="Cleared Event Log"; NumberOfOccurences=$EventlogClearedSec}
  $global:ResultsArray+=$hash
  Write-Host "Cleared Event Log [Security.evtx]: " $EventlogClearedSec -ForegroundColor Green
}

function EventlogClearedSystem  {
    if ($Valid_System_Path -eq $false) {
      write-host "Error: System event log is not found" -ForegroundColor Red
      return  
    }
    $EventID="104"
    $OutputFile= Join-Path -Path $ExtraEvents_Path -ChildPath "EventlogClearedSystem.csv"
    
    $Query="SELECT TimeGenerated , EXTRACT_TOKEN(Strings, 0, '|') AS Username , EXTRACT_TOKEN(Strings, 1, '|') as Domain, EXTRACT_TOKEN(Strings, 2, '|') AS Channel INTO '$OutputFile' FROM '$System_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    
    $EventlogClearedSys= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="System.evtx";SANSCateogry="Extra Events"; Event="Cleared Event Log"; NumberOfOccurences=$EventlogClearedSys}
    $global:ResultsArray+=$hash
    Write-Host "Cleared Event Log [System.evtx]: " $EventlogClearedSys -ForegroundColor Green
}
function RDPreconnected  {
      param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red

        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4778"
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "RDPreconnected.csv"
    $Query= "SELECT TimeGenerated,EventID ,EXTRACT_TOKEN(Strings, 0, '|') AS Username, EXTRACT_TOKEN(Strings, 1, '|') AS Domain, EXTRACT_TOKEN(Strings, 4, '|') AS Workstation, EXTRACT_TOKEN(Strings, 5, '|') AS SourceIP  INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID" 
    LogParser.exe -stats:OFF -i:EVT $Query
    $RDPreconnected= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="RemoteDesktop"; Event="RDP sessions reconnected"; NumberOfOccurences=$RDPreconnected}
    $global:ResultsArray+=$hash
    Write-Host "RDP sessions reconnected: " $RDPreconnected -ForegroundColor Green

    
}

function RDPDisconnected  {
      param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red

        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4779"
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "RDPDisconnected.csv"
    $Query= "SELECT TimeGenerated,EventID ,EXTRACT_TOKEN(Strings, 0, '|') AS Username, EXTRACT_TOKEN(Strings, 1, '|') AS Domain, EXTRACT_TOKEN(Strings, 4, '|') AS Workstation, EXTRACT_TOKEN(Strings, 5, '|') AS SourceIP  INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID" 
    LogParser.exe -stats:OFF -i:EVT $Query
    $RDPDisconnected= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="RemoteDesktop"; Event="RDP sessions Disconnected"; NumberOfOccurences=$RDPDisconnected}
    $global:ResultsArray+=$hash
    Write-Host "RDP sessions Disconnected: " $RDPDisconnected  -ForegroundColor Green 
}
function NetworkShareAccessed  {
      param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red

        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="5140"
    $OutputFile= Join-Path -Path $MapNetworkShares_Path -ChildPath "NetworkShareAccessed.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS SourceIP, EXTRACT_TOKEN(Strings, 5, '|') AS SourcePort, EXTRACT_TOKEN(Strings, 6, '|') AS ShareName INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $NetworkShareAccessed= GetStats $
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="MapNetworkShares"; Event="Network Share Objects Accessed"; NumberOfOccurences=$NetworkShareAccessed}
    $global:ResultsArray+=$hash
    Write-Host "Network Share Objects Accessed: " $NetworkShareAccessed -ForegroundColor Green
}

function AuditingofSharedfiles  {
      param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red

        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="5145"
    $OutputFile= Join-Path -Path $MapNetworkShares_Path -ChildPath "AuditingofSharedfiles.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccounName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS ObjectType, EXTRACT_TOKEN(Strings, 5, '|') AS SourceIP, EXTRACT_TOKEN(Strings, 6, '|') AS SourePort, EXTRACT_TOKEN(Strings, 7, '|') AS ShareName, EXTRACT_TOKEN(Strings, 8, '|') AS SharePath, EXTRACT_TOKEN(Strings, 11, '|') as Accesses, EXTRACT_TOKEN(Strings, 12, '|') as AccessesCheckResult INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $AuditingofSharedfiles= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="MapNetworkShares"; Event="Network Share Objects Checked"; NumberOfOccurences=$AuditingofSharedfiles}
    $global:ResultsArray+=$hash
    Write-Host "Network Share Objects Checked : " $AuditingofSharedfiles -ForegroundColor Green
}



function ServiceCrashed	 {
    if ($Valid_System_Path -eq $false) {
        write-host "Error: System event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="7034"
    $OutputFile= Join-Path -Path $Services_Path -ChildPath "ServiceCrashed.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ServiceName, EXTRACT_TOKEN(Strings, 1, '|') AS Times INTO '$OutputFile' FROM '$System_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $ServiceCrashed= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="System.evtx";SANSCateogry="Services"; Event="Services Crashed unexpectedly"; NumberOfOccurences=$ServiceCrashed}
    $global:ResultsArray+=$hash    
    Write-Host "Services Crashed unexpectedly [System Log]: " $ServiceCrashed -ForegroundColor Green
}

function ServiceStartorStop {
    if ($Valid_System_Path -eq $false) {
        write-host "Error: System event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="7036"
    $OutputFile= Join-Path -Path $Services_Path -ChildPath "ServiceStartorStop.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS ServiceName INTO '$OutputFile' FROM '$System_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $ServiceStartorStop= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="System.evtx";SANSCateogry="Services"; Event="Services Stopped Or Started"; NumberOfOccurences=$ServiceStartorStop}
    $global:ResultsArray+=$hash 
    Write-Host "Services Stopped Or Started: " $ServiceStartorStop -ForegroundColor Green
 
}
function ServiceSentControl {
    if ($Valid_System_Path -eq $false) {
        write-host "Error: System event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="7035"
    $OutputFile= Join-Path -Path $Services_Path -ChildPath "ServiceSentControl.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ServiceName, EXTRACT_TOKEN(Strings, 1, '|') AS RequestSent INTO '$OutputFile' FROM '$System_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $ServiceSentControl= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="System.evtx";SANSCateogry="Services"; Event="Services Sent Stop/Start Control [System Log]"; NumberOfOccurences=$ServiceSentControl}
    $global:ResultsArray+=$hash 
    Write-Host "Services Sent Stop/Start Control [System Log]: " $ServiceSentControl -ForegroundColor Green
}

function StartTypeChanged {
    if ($Valid_System_Path -eq $false) {
        write-host "Error: System event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="7040"
    $OutputFile= Join-Path -Path $Services_Path -ChildPath "StartTypeChanged.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ServiceName, EXTRACT_TOKEN(Strings, 1, '|') AS ChangedFrom , EXTRACT_TOKEN(Strings, 2, '|') AS ChangedTo INTO '$OutputFile' FROM '$System_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $StartTypeChanged= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="System.evtx";SANSCateogry="Services"; Event="Services Start Type Changed [System Log]"; NumberOfOccurences=$StartTypeChanged}
    $global:ResultsArray+=$hash     
    Write-Host "Services Start Type Changed [System Log]: " $StartTypeChanged -ForegroundColor Green
}

function ServiceInstall {
    if ($Valid_System_Path -eq $false) {
        write-host "Error: System event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="7045"
    $OutputFile= Join-Path -Path $PsExec_Path -ChildPath "ServiceInstall.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ServiceName, EXTRACT_TOKEN(Strings, 1, '|') AS ImagePath, EXTRACT_TOKEN(Strings, 2, '|') AS ServiceType , EXTRACT_TOKEN(Strings, 3, '|') AS StartType, EXTRACT_TOKEN(Strings, 4, '|') AS AccountName INTO '$OutputFile' FROM '$System_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $ServiceInstall= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="System.evtx";SANSCateogry="PsExec"; Event="Services Installed on System [System Log]"; NumberOfOccurences=$ServiceInstall}
    $global:ResultsArray+=$hash
    Write-Host "Services Installed on System [System Log]: " $ServiceInstall -ForegroundColor Green
}


########################################## WMI ################################################
function SystemQueryWMI {
    if ($Valid_WMI_Path -eq $false) {
        write-host "Error: Microsoft-Windows-WMI-Activity%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="5857"
    $OutputFile= Join-Path -Path $WMIOut_Path -ChildPath "SystemQueryWMI.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ProviderName, EXTRACT_TOKEN(Strings, 1, '|') AS Code, EXTRACT_TOKEN(Strings, 3, '|') AS ProcessID, EXTRACT_TOKEN(Strings, 4, '|') AS ProviderPath INTO '$OutputFile' FROM '$WMI_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $SystemQueryWMI= GetStats $
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-WMIActivity%4Operational.evtx";SANSCateogry="WMI/WMIC"; Event="Services Installed on System [System Log]"; NumberOfOccurences=$SystemQueryWMI}
    $global:ResultsArray+=$hash
    Write-Host "WMI Operations Started [WMI Log]: " $SystemQueryWMI   -ForegroundColor Green
}


function TemporaryEventConsumer {
    if ($Valid_WMI_Path -eq $false) {
        write-host "Error: Microsoft-Windows-WMI-Activity%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="5860"
    $OutputFile= Join-Path -Path $WMIOut_Path -ChildPath "TemporaryEventConsumer.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS NameSpace, EXTRACT_TOKEN(Strings, 1, '|') AS Query,EXTRACT_TOKEN(Strings, 2, '|') AS User ,EXTRACT_TOKEN(Strings, 3, '|') AS ProcessID, EXTRACT_TOKEN(Strings, 4, '|') AS ClientMachine INTO '$OutputFile' FROM '$WMI_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $TemporaryEventConsumer= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-WMIActivity%4Operational.evtx";SANSCateogry="WMI/WMIC"; Event="WMI Operations ESS Started [WMI Log]"; NumberOfOccurences=$TemporaryEventConsumer}
    $global:ResultsArray+=$hash
    Write-Host "WMI Operations ESS Started [WMI Log]: " $TemporaryEventConsumer  -ForegroundColor Green 
}


function PermenantEventConsumer{
    if ($Valid_WMI_Path -eq $false) {
        write-host "Error: Microsoft-Windows-WMI-Activity%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="5861"
    $OutputFile= Join-Path -Path $WMIOut_Path -ChildPath "PermenantEventConsumer.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS NameSpace, EXTRACT_TOKEN(Strings, 1, '|') AS ESS,EXTRACT_TOKEN(Strings, 2, '|') AS Consumer ,EXTRACT_TOKEN(Strings, 3, '|') AS PossibleCause INTO '$OutputFile' FROM '$WMI_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $PermenantEventConsumer= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-WMIActivity%4Operational.evtx";SANSCateogry="WMI/WMIC"; Event="WMI Operations ESS to Consumer Binding [WMI Log]"; NumberOfOccurences=$PermenantEventConsumer}
    $global:ResultsArray+=$hash
    Write-Host "WMI Operations ESS to Consumer Binding [WMI Log]: " $PermenantEventConsumer  -ForegroundColor Green  
}


#===============Microsoft-Windows-PowerShell%4Operational.evtx=========
function ScriptBlockLogging {
    if ($Valid_PowerShellOperational_Path -eq $false) {
        write-host "Error: Microsoft-Windows-PowerShell%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4103"
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "ScriptBlockLogging.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ContextINFO, EXTRACT_TOKEN(Strings, 2, '|') AS Payload INTO '$OutputFile' FROM '$PowerShellOperational_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $ScriptBlockLogging= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-PowerShell%4Operational.evtx";SANSCateogry="PowerShellRemoting"; Event="PS Modules Logged"; NumberOfOccurences=$ScriptBlockLogging}
    $global:ResultsArray+=$hash
    Write-Host "PS Script block Logged : " $ScriptBlockLogging -ForegroundColor Green

}

function ScriptBlockAuditing  {
    if ($Valid_PowerShellOperational_Path -eq $false) {
        write-host "Error: Microsoft-Windows-PowerShell%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4104"
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "ScriptBlockAuditing.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS MessageNumber, EXTRACT_TOKEN(Strings, 1, '|') AS TotalMessages, EXTRACT_TOKEN(Strings, 2, '|') AS ScriptBlockText , EXTRACT_TOKEN(Strings, 3, '|') AS ScriptBlockID , EXTRACT_TOKEN(Strings,4 , '|') AS ScriptPath INTO '$OutputFile' FROM '$PowerShellOperational_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $ScriptBlockAuditing= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-PowerShell%4Operational.evtx";SANSCateogry="PowerShellRemoting"; Event="PS Script Blocks Logged"; NumberOfOccurences=$ScriptBlockAuditing}
    $global:ResultsArray+=$hash
    Write-Host "PS Script Blocks Auditing : " $ScriptBlockAuditing -ForegroundColor Green  
}    

function LateralMovementDetection  {
    if ($Valid_PowerShellOperational_Path -eq $false) {
        write-host "Error: Microsoft-Windows-PowerShell%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="53504"
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "LateralMovementDetection.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS Process, EXTRACT_TOKEN(Strings, 1, '|') AS AppDomain INTO '$OutputFile' FROM '$PowerShellOperational_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $LateralMovementDetection= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-PowerShell%4Operational.evtx";SANSCateogry="PowerShellRemoting"; Event="PS Authenticating User"; NumberOfOccurences=$LateralMovementDetection}
    $global:ResultsArray+=$hash
    Write-Host "PS Authenticating User : " $LateralMovementDetection -ForegroundColor Green  
}
#=====================WinRM log=======================
function SessionCreated {
    if ($Valid_WinRM_Path -eq $false) {
        write-host "Error: Microsoft-Windows-WinRM%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="91"
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "SessionCreated.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ResourceUrl INTO '$OutputFile' FROM '$WinRM_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $SessionCreated= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-WinRM%4Operational.evtx";SANSCateogry="PowerShellRemoting"; Event="Session Created [WinRM log]"; NumberOfOccurences=$SessionCreated}
    $global:ResultsArray+=$hash
    Write-Host "Sessions Created [WinRM log] : " $SessionCreated -ForegroundColor Green  
}  

function AuthRecorded {
    if ($Valid_WinRM_Path -eq $false) {
        write-host "Error: Microsoft-Windows-WinRM%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="168"
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "AuthRecorded.csv"
    $Query= "Select TimeGenerated,EventID, Message INTO '$OutputFile' FROM '$WinRM_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $AuthRecorded= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-WinRM%4Operational.evtx";SANSCateogry="PowerShellRemoting"; Event="WinRM Authenticating User [WinRM log]"; NumberOfOccurences=$AuthRecorded}
    $global:ResultsArray+=$hash
    Write-Host "WinRM Authenticating User [WinRM log] : " $AuthRecorded -ForegroundColor Green

}

#####======= Windows PowerShell.evtx======
function StartPSRemoteSession {
    if ($Valid_WinPowerShell_Path -eq $false) {
        write-host "Error: Windows PowerShell event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="400"
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "StartPSRemoteSession.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_Suffix(Message, 0, 'HostApplication=') AS HostApplication INTO '$OutputFile' FROM '$WinPowerShell_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $StartPSRemoteSession= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Windows PowerShell.evtx";SANSCateogry="PowerShellRemoting"; Event="Server Remote Hosts Started"; NumberOfOccurences=$StartPSRemoteSession}
    $global:ResultsArray+=$hash
    Write-Host "Server Remote Hosts Started : " $StartPSRemoteSession -ForegroundColor Green

    
}
function EndPSRemoteSession {
    if ($Valid_WinPowerShell_Path -eq $false) {
        write-host "Error: Windows PowerShell event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="403"
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "EndPSRemoteSession.csv"
    $Query= "Select TimeGenerated,EventID,  EXTRACT_Suffix(Message, 0, 'HostApplication=') AS HostApplication INTO '$OutputFile' FROM '$WinPowerShell_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $EndPSRemoteSession= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Windows PowerShell.evtx";SANSCateogry="PowerShellRemoting"; Event="Server Remote Hosts Ended"; NumberOfOccurences=$EndPSRemoteSession}
    $global:ResultsArray+=$hash
    Write-Host "Server Remote Hosts Ended : " $EndPSRemoteSession -ForegroundColor Green
}

function PipelineExecution {
    if ($Valid_WinPowerShell_Path -eq $false) {
        write-host "Error: Windows PowerShell event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="800"
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "PipelineExecution.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_Suffix(Message, 0, 'HostApplication=') AS HostApplication  INTO '$OutputFile' FROM '$WinPowerShell_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $PipelineExecution= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Windows PowerShell.evtx";SANSCateogry="PowerShellRemoting"; Event="Partial Scripts Code"; NumberOfOccurences=$PipelineExecution}
    $global:ResultsArray+=$hash
    Write-Host "Partial Scripts Code : " $PipelineExecution   -ForegroundColor Green
}

#==============Task Scheduler=============

function CreatingTaskSchedulerTask {
    if ($Valid_TaskScheduler_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TaskScheduler%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="106"
    $OutputFile= Join-Path -Path $ScheduledTasks_Path -ChildPath "CreatingTaskSchedulerTask.csv"
    $Query= "Select TimeGenerated,EventID , extract_token(strings, 0, '|') as TaskName, extract_token(strings, 1, '|') as User INTO '$OutputFile' FROM '$TaskScheduler_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $CreatingTaskSchedulerTask= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-TaskScheduler%4Operational.evtx";SANSCateogry="ScheduledTasks"; Event="Scheduled Tasks Created [Task Scheduler Log]"; NumberOfOccurences=$CreatingTaskSchedulerTask}
    $global:ResultsArray+=$hash
    Write-Host "Scheduled Tasks Created [Task Scheduler Log] : " $CreatingTaskSchedulerTask  -ForegroundColor Green
 
}

function UpdatingTaskSchedulerTask {
    if ($Valid_TaskScheduler_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TaskScheduler%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="140"
    $OutputFile= Join-Path -Path $ScheduledTasks_Path -ChildPath "UpdatingTaskSchedulerTask.csv"
    $Query= "Select TimeGenerated,EventID , extract_token(strings, 0, '|') as TaskName, extract_token(strings, 1, '|') as User INTO '$OutputFile' FROM '$TaskScheduler_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $UpdatingTaskSchedulerTask= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-TaskScheduler%4Operational.evtx";SANSCateogry="ScheduledTasks"; Event="Scheduled Tasks Updated [Task Scheduler Log]"; NumberOfOccurences=$UpdatingTaskSchedulerTask}
    $global:ResultsArray+=$hash
    Write-Host "Scheduled Tasks Updated [Task Scheduler Log]: " $UpdatingTaskSchedulerTask  -ForegroundColor Green
 
}

function DeletingTaskSchedulerTask {
    if ($Valid_TaskScheduler_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TaskScheduler%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="141"
    $OutputFile= Join-Path -Path $ScheduledTasks_Path -ChildPath "DeletingTaskSchedulerTask.csv"
    $Query= "Select TimeGenerated,EventID , extract_token(strings, 0, '|') as TaskName, extract_token(strings, 1, '|') as User INTO '$OutputFile' FROM '$TaskScheduler_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $DeletingTaskSchedulerTask= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-TaskScheduler%4Operational.evtx";SANSCateogry="ScheduledTasks"; Event="Scheduled Tasks Deleted [Task Scheduler Log]"; NumberOfOccurences=$DeletingTaskSchedulerTask}
    $global:ResultsArray+=$hash
    Write-Host "Scheduled Tasks Deleted [Task Scheduler Log] : " $DeletingTaskSchedulerTask  -ForegroundColor Green
 
}

function ExecutingTaskSchedulerTask {
    if ($Valid_TaskScheduler_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TaskScheduler%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="200"
    $OutputFile= Join-Path -Path $ScheduledTasks_Path -ChildPath "ExecutingTaskSchedulerTask.csv"
    $Query= "Select TimeGenerated,EventID, extract_token(strings,0, '|') as TaskName, extract_token(strings, 1, '|') as TaskAction, extract_token(strings, 2, '|') as Instance  INTO '$OutputFile' FROM '$TaskScheduler_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $ExecutingTaskSchedulerTask= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-TaskScheduler%4Operational.evtx";SANSCateogry="ScheduledTasks"; Event="Scheduled Tasks Executed [Task Scheduler Log]"; NumberOfOccurences=$ExecutingTaskSchedulerTask}
    $global:ResultsArray+=$hash
    Write-Host "Scheduled Tasks Executed [Task Scheduler Log]: " $ExecutingTaskSchedulerTask  -ForegroundColor Green
}


function CompletingTaskSchedulerTask {
    if ($Valid_TaskScheduler_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TaskScheduler%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="201"
    $OutputFile= Join-Path -Path $ScheduledTasks_Path -ChildPath "CompletingTaskSchedulerTask.csv"
    $Query= "Select TimeGenerated,EventID, extract_token(strings,0, '|') as TaskName, extract_token(strings, 1, '|') as TaskAction, extract_token(strings, 2, '|') as Instance  INTO '$OutputFile' FROM '$TaskScheduler_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $CompletingTaskSchedulerTask= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-TaskScheduler%4Operational.evtx";SANSCateogry="ScheduledTasks"; Event="Scheduled Tasks Completed [Task Scheduler Log]"; NumberOfOccurences=$CompletingTaskSchedulerTask}
    $global:ResultsArray+=$hash
    Write-Host "Scheduled Tasks Completed [Task Scheduler Log] : " $CompletingTaskSchedulerTask  -ForegroundColor Green
}

##============= Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx============
function RDPSessionLogonSucceeded {
    if ($Valid_TerminalServices_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="21"
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "RDPSessionLogonSucceeded.csv"
    $Query= "Select TimeGenerated,EventID , extract_token(strings, 0, '|') as User, extract_token(strings, 1, '|') as SessionID ,extract_token(strings,2, '|') as SourceIP   INTO '$OutputFile' FROM '$TerminalServices_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $RDPSessionLogonSucceeded= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx";SANSCateogry="RemoteDesktop"; Event="RDP Successful Logons Sessions [EventID=21]"; NumberOfOccurences=$RDPSessionLogonSucceeded}
    $global:ResultsArray+=$hash
    Write-Host "RDP Successful Logons Sessions [EventID=21] : " $RDPSessionLogonSucceeded -ForegroundColor Green
}

function RDPShellStartNotificationReceived {
    if ($Valid_TerminalServices_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="22"
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "RDPShellStartNotificationReceived.csv"
    $Query= "Select TimeGenerated,EventID , extract_token(strings, 0, '|') as User, extract_token(strings, 1, '|') as SessionID ,extract_token(strings,2, '|') as SourceIP   INTO '$OutputFile' FROM '$TerminalServices_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $RDPShellStartNotificationReceived= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx";SANSCateogry="RemoteDesktop"; Event="RDP Successful Logons Sessions [EventID=22]"; NumberOfOccurences=$RDPShellStartNotificationReceived}
    $global:ResultsArray+=$hash
    Write-Host "RDP Successful Logons Sessions  [EventID=22]: " $RDPShellStartNotificationReceived -ForegroundColor Green
}

function RDPShellSessionReconnectedSucceeded {
    if ($Valid_TerminalServices_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="25"
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "RDPShellSessionReconnectedSucceeded.csv"
    $Query= "Select TimeGenerated,EventID , extract_token(strings, 0, '|') as User, extract_token(strings, 1, '|') as SessionID ,extract_token(strings,2, '|') as SourceIP   INTO '$OutputFile' FROM '$TerminalServices_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $RDPShellSessionReconnectedSucceeded= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx";SANSCateogry="RemoteDesktop"; Event=" RDP Local Successful Reconnections"; NumberOfOccurences=$RDPShellSessionReconnectedSucceeded}
    $global:ResultsArray+=$hash
    Write-Host "RDP Successful Shell Sessions Reconnected : " $RDPShellSessionReconnectedSucceeded -ForegroundColor Green
}
function RDPbeginSession { 
    if ($Valid_TerminalServices_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="41"
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "RDPBeginSession.csv"
    $Query= "Select TimeGenerated,EventID , extract_token(strings, 0, '|') as User, extract_token(strings, 1, '|') as SessionID INTO '$OutputFile' FROM '$TerminalServices_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $RDPBeginSession= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx";SANSCateogry="RemoteDesktop"; Event=" RDP Sessios Begain"; NumberOfOccurences=$RDPBeginSession}
    $global:ResultsArray+=$hash
    Write-Host "RDP Sessions Begain : " $RDPBeginSession -ForegroundColor Green
}

#=========================Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational.evtx=======================
function UserAuthSucceeded {
    if ($Valid_RemoteConnection_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="1149"
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "UserAuthSucceeded.csv"
    $Query= "Select TimeGenerated,EventID  ,extract_token(strings, 0, '|') as User, extract_token(strings, 1, '|') as Domain ,extract_token(strings,2, '|') as SourceIP   INTO '$OutputFile' FROM '$RemoteConnection_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $UserAuthSucceeded= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational.evtx";SANSCateogry="RemoteDesktop"; Event="RDP User authentication succeeded"; NumberOfOccurences=$UserAuthSucceeded}
    $global:ResultsArray+=$hash
    Write-Host "RDP User authentication succeeded : " $UserAuthSucceeded -ForegroundColor Green  
    
}


#============Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evtx=============

function RDPConnectionsAttempts {
    if ($Valid_RDPCORETS_Path -eq $false) {
        write-host "Error: Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="131"
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "RDPConnectionsAttempts.csv"
    $Query= "Select TimeGenerated,EventID  ,extract_token(strings, 0, '|') as ConnectionType, extract_token(strings, 1, '|') as CLientIP INTO '$OutputFile' FROM '$RDPCORETS_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $RDPConnectionsAttempts= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evtx";SANSCateogry="RemoteDesktop"; Event="RDP Connections Attempts"; NumberOfOccurences=$RDPConnectionsAttempts}
    $global:ResultsArray+=$hash
    Write-Host "RDP Connections Attempts : " $RDPConnectionsAttempts -ForegroundColor Green
}

function RDPSuccessfulConnections {
    if ($Valid_RDPCORETS_Path -eq $false) {
        write-host "Error: Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="98"
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "RDPSuccessfulTCPConnections.csv"
    $Query= "Select TimeGenerated,EventID  INTO '$OutputFile' FROM '$RDPCORETS_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $RDPSuccessfulTCPConnections= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evtx";SANSCateogry="RemoteDesktop"; Event="RDP Successful TCP Connections"; NumberOfOccurences=$RDPSuccessfulTCPConnections}
    $global:ResultsArray+=$hash
    Write-Host "RDP Successful TCP Connections: " $RDPSuccessfulTCPConnections -ForegroundColor Green
}
##==========================Source Event IDs============
##Security.evtx
function ExplicitCreds {
    param (
        [Parameter(Mandatory=$true)]
        [string]$security,
        [Parameter(Mandatory=$true)]
        [string]$Source_Events
    )
    if ($Source_Events -eq $true) {
        if($security -eq $false){
                 Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red
                return
        }
    }
    else {return}
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4648"
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "ExplicitCreds.csv"
    $Query= "SELECT TimeGenerated,EventID, extract_token(Strings, 1, '|') as SubjectUserName, extract_token(Strings, 2, '|') as SubjectDomain, extract_token(Strings, 5, '|') as TargetUsername, extract_token(Strings, 6, '|') as TargetDomain, extract_token(Strings, 8, '|') as TargetServer, extract_token(strings, 9, '|') as TargetInfo, extract_token(strings, 11, '|') as ProcessName, extract_token(strings, 12, '|') as SourceIP,extract_token(strings, 13, '|') as SourcePort INTO '$OutputFile' from '$Security_Path' WHERE EventID = $EventID" 
    LogParser.exe -stats:OFF -i:EVT $Query
    $ExplicitCreds= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="RemoteDesktop"; Event="Explicit Credentials Used"; NumberOfOccurences=$ExplicitCreds}
    $global:ResultsArray+=$hash
    Write-Host "Logons using Explicit Credential: " $ExplicitCreds -ForegroundColor Green
}
##Microsoft-Windows-TerminalServices-RDPClient%4Operational.evtx
function RDPActiveXControls {
    if ($Source_Event -eq $false) {return}
    if ($global:Valid_TerminalServicesRDP_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TerminalServices-RDPClient%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="1024"
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "RDPActiveXControls.csv"
    $Query= "Select TimeGenerated,EventID, extract_token(Strings, 0, '|') as Name, extract_token(Strings, 1, '|') as IP/HostName, extract_token(Strings, 2, '|') as Level INTO '$OutputFile' FROM '$TerminalServicesRDP_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $RDPActiveXControls= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-TerminalServices-RDPClient%4Operational.evtx";SANSCateogry="RemoteDesktop"; Event="RDP client ActiveX Controls"; NumberOfOccurences=$RDPActiveXControls}
    $global:ResultsArray+=$hash
    Write-Host "RDP Destination Hostname [ActiveX controls]: " $RDPActiveXControls -ForegroundColor Green
}
function RDPAMultitransportCon {
    if ($Source_Event -eq $false) {return}
    if ($global:Valid_TerminalServicesRDP_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TerminalServices-RDPClient%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="1102"
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "RDPAMultitransportCon.csv"
    $Query= "Select TimeGenerated,EventID, extract_token(Strings, 0, '|') as Name, extract_token(Strings, 1, '|') as IP/HostName, extract_token(Strings, 2, '|') as Level INTO '$OutputFile' FROM '$TerminalServicesRDP_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $RDPAMultitransportCon= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-TerminalServices-RDPClient%4Operational.evtx";SANSCateogry="RemoteDesktop"; Event="RDP client Multitransport Connections"; NumberOfOccurences=$RDPAMultitransportCon}
    $global:ResultsArray+=$hash
    Write-Host "RDP Destination IPs [client Multitransport Connections]: " $RDPAMultitransportCon -ForegroundColor Green
}
###=====Microsoft-Windows-WinRM%4Operational.evtx
function WSManSessions {
    if ($Source_Event -eq $false) {return}
    if ($Valid_WinRM_Path -eq $false) {
        write-host "Error: Microsoft-Windows-WinRM%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="6"
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "WSManSessionsCreated.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ConnectionString INTO '$OutputFile' FROM '$WinRM_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $WSManSessions= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-WinRM%4Operational.evtx";SANSCateogry="PowerShellRemoting"; Event="WSMan Sessions Created"; NumberOfOccurences=$WSManSessions}
    $global:ResultsArray+=$hash
    Write-Host "WSMan Sessions Created : " $WSManSessions -ForegroundColor Green  
}  
function WSManClosedCommand {
    if ($Source_Event -eq $false) {return}
    if ($Valid_WinRM_Path -eq $false) {
        write-host "Error: Microsoft-Windows-WinRM%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="15"
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "WSManClosedCommand.csv"
    $Query= "Select TimeGenerated,EventID INTO '$OutputFile' FROM '$WinRM_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $WSManClosedCommand= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-WinRM%4Operational.evtx";SANSCateogry="PowerShellRemoting"; Event="WSMan Closed Commands"; NumberOfOccurences=$WSManClosedCommand}
    $global:ResultsArray+=$hash
    Write-Host "WSMan Closed Commands : " $WSManClosedCommand -ForegroundColor Green  
}  

function WSManClosedShell {
    if ($Source_Event -eq $false) {return}
    if ($Valid_WinRM_Path -eq $false) {
        write-host "Error: Microsoft-Windows-WinRM%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="16"
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "WSManClosedShell.csv"
    $Query= "Select TimeGenerated,EventID INTO '$OutputFile' FROM '$WinRM_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $WSManClosedShell= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-WinRM%4Operational.evtx";SANSCateogry="PowerShellRemoting"; Event="WSMan Closed Shells"; NumberOfOccurences=$WSManClosedShell}
    $global:ResultsArray+=$hash
    Write-Host "WSMan Closed Shells : " $WSManClosedShell -ForegroundColor Green  
}  
function WSManSessionsClosed {
    if ($Source_Event -eq $false) {return}
    if ($Valid_WinRM_Path -eq $false) {
        write-host "Error: Microsoft-Windows-WinRM%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="33"
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "WSManSessionsClosed.csv"
    $Query= "Select TimeGenerated,EventID, Message INTO '$OutputFile' FROM '$WinRM_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $WSManSessionsClosed= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-WinRM%4Operational.evtx";SANSCateogry="PowerShellRemoting"; Event="WSMan Closed Sessions"; NumberOfOccurences=$WSManSessionsClosed}
    $global:ResultsArray+=$hash
    Write-Host "WSMan Closed Sessions : " $WSManClosedShell -ForegroundColor Green  
}  
#=========Microsoft-Windows-PowerShell%4Operational.evtx
#EventID=40691 =>Local initiation of PowerShell.exe and associated user =>ToDo
#EventID=40692 =>Local initiation of PowerShell.exe and associated user =>ToDo
#EventID=8193 =>
function PSSessionsCreated {
    if ($Source_Event -eq $false) {return}
    if ($Valid_PowerShellOperational_Path -eq $false) {
        write-host "Error: Microsoft-Windows-PowerShell%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="8194"
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "PSSessionsCreated.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS InstanceID, EXTRACT_TOKEN(Strings, 1, '|') AS MinRunSpaces, EXTRACT_TOKEN(Strings, 2, '|') AS MaxRunspaces  INTO '$OutputFile' FROM '$PowerShellOperational_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $PSSessionsCreated= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-PowerShell%4Operational.evtx";SANSCateogry="PowerShellRemoting"; Event="PS Created Sessions"; NumberOfOccurences=$PSSessionsCreated}
    $global:ResultsArray+=$hash
    Write-Host "PS Created Sessions: " $PSSessionsCreated -ForegroundColor Green

}

function PSSessionsClosed {
    if ($Source_Event -eq $false) {return}
    if ($Valid_PowerShellOperational_Path -eq $false) {
        write-host "Error: Microsoft-Windows-PowerShell%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="8197"
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "PSSessionsClosed.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS State  INTO '$OutputFile' FROM '$PowerShellOperational_Path' WHERE EventID = $EventID and State = 'Closed'"
    LogParser.exe -stats:OFF -i:EVT $Query
    $PSSessionsClosed= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-PowerShell%4Operational.evtx";SANSCateogry="PowerShellRemoting"; Event="PS Closed Sessions"; NumberOfOccurences=$PSSessionsClosed}
    $global:ResultsArray+=$hash
    Write-Host "PS Closed Sessions: " $PSSessionsClosed -ForegroundColor Green

}

