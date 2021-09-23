function Get-TemporaryEventConsumer {
    param(
        [Parameter(Mandatory=$true)]
        [String] $Path,
        [Parameter(Mandatory=$false)]
        [String] $LogID = "200"
    )
$A= Get-WinEvent -FilterHashtable @{Id=5860 ;Path = $Path 	}
$global:TemporaryEventConsumercount=0
$A | ForEach-Object -process{
	
    $Logon = New-Object psobject
    $Logon | Add-Member -MemberType NoteProperty -name TimeCreated -value $_.TimeCreated
	$Logon | Add-Member -MemberType NoteProperty -name NameSpacename -value $_.properties[0].value
	$Logon | Add-Member -MemberType NoteProperty -name Query -value $_.properties[1].value
	$Logon | Add-Member -MemberType NoteProperty -name EventID -value $_.Id
	$global:TemporaryEventConsumercount++
    $Logon

	
 }}
 "Number of TemporaryEventConsumer events:"+ $TemporaryEventConsumercount