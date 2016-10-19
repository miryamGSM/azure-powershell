﻿$taskScriptDir = [System.IO.Path]::GetDirectoryName($PSCommandPath)
$env:repoRoot = [System.IO.Path]::GetDirectoryName($taskScriptDir)
$userPsFileDir = [string]::Empty

[string]$envVariableName="TEST_CSM_ORGID_AUTHENTICATION"

[CmdletBinding]
Function Set-TestEnvironment
{
<#
.SYNOPSIS
This cmdlet helps you to setup Test Environment for running tests
In order to successfully run a test, you will need SubscriptionId, TenantId
This cmdlet will only prompt you for Subscription and Tenant information, rest all other parameters are optional

#>
    [CmdletBinding(DefaultParameterSetName='UserIdParamSet')]
    param(
        [Parameter(ParameterSetName='UserIdParamSet', Mandatory=$true, HelpMessage = "UserId (OrgId) you would like to use")]
        [ValidateNotNullOrEmpty()]
        [string]$UserId,

        [Parameter(ParameterSetName='UserIdParamSet', Mandatory=$true, HelpMessage = "UserId (OrgId) you would like to use")]
        [ValidateNotNullOrEmpty()]
        [string]$Password,

        [Parameter(ParameterSetName='SpnParamSet', Mandatory=$true, HelpMessage='ServicePrincipal/ClientId you would like to use')]   
        [ValidateNotNullOrEmpty()]
        [string]$ServicePrincipal,

        [Parameter(ParameterSetName='SpnParamSet', Mandatory=$true, HelpMessage='ServicePrincipal Secret/ClientId Secret you would like to use')]
        [ValidateNotNullOrEmpty()]
        [string]$ServicePrincipalSecret,

        [Parameter(ParameterSetName='SpnParamSet', Mandatory=$true)]
        [Parameter(ParameterSetName='UserIdParamSet', Mandatory=$true, HelpMessage = "SubscriptionId you would like to use")]
        [ValidateNotNullOrEmpty()]
        [string]$SubscriptionId,

        [Parameter(ParameterSetName='SpnParamSet', Mandatory=$true, HelpMessage='AADTenant/TenantId you would like to use')]
        [ValidateNotNullOrEmpty()]
        [string]$TenantId,

        [ValidateSet("Playback", "Record", "None")]
        [string]$RecordMode='Playback',

        [ValidateSet("Prod", "Dogfood", "Current", "Next")]
        [string]$TargetEnvironment='Prod'
    )

    [string]$uris="https://management.azure.com/"

    $formattedConnStr = [string]::Format("SubscriptionId={0};HttpRecorderMode={1};Environment={2}", $SubscriptionId, $RecordMode, $TargetEnvironment)

    if([string]::IsNullOrEmpty($UserId) -eq $false)
    {
        $formattedConnStr = [string]::Format([string]::Concat($formattedConnStr, ";UserId={0}"), $UserId)
    }

    if([string]::IsNullOrEmpty($Password) -eq $false)
    {
        $formattedConnStr = [string]::Format([string]::Concat($formattedConnStr, ";Password={0}"), $Password)
    }

    if([string]::IsNullOrEmpty($TenantId) -eq $false)
    {
        $formattedConnStr = [string]::Format([string]::Concat($formattedConnStr, ";AADTenant={0}"), $TenantId)
    }

    if([string]::IsNullOrEmpty($ServicePrincipal) -eq $false)
    {
        $formattedConnStr = [string]::Format([string]::Concat($formattedConnStr, ";ServicePrincipal={0}"), $ServicePrincipal)
    }

    if([string]::IsNullOrEmpty($ServicePrincipalSecret) -eq $false)
    {
        $formattedConnStr = [string]::Format([string]::Concat($formattedConnStr, ";ServicePrincipalSecret={0}"), $ServicePrincipalSecret)
    }
    
    $formattedConnStr = [string]::Format([string]::Concat($formattedConnStr, ";BaseUri={0}"), $uris)

    Write-Host "Below connection string is ready to be set"
    Print-ConnectionString $UserId $Password $SubscriptionId $TenantId $ServicePrincipal $ServicePrincipalSecret $RecordMode $TargetEnvironment $uris

    #Set connection string to Environment variable
    $env:TEST_CSM_ORGID_AUTHENTICATION=$formattedConnStr
    Write-Host ""

    # Retrieve the environment variable
    Write-Host ""
    Write-Host "Below connection string was set. Start Visual Studio by typing devenv" -ForegroundColor Green
    [Environment]::GetEnvironmentVariable($envVariableName)
    Write-Host ""
    
    Write-Host "If your needs demand you to set connection string differently, for all the supported Key/Value pairs in connection string"
    Write-Host "Please visit https://github.com/Azure/azure-powershell/blob/dev/documentation/Using-Azure-TestFramework.md" -ForegroundColor Yellow
}

Function Print-ConnectionString([string]$uid, [string]$pwd, [string]$subId, [string]$aadTenant, [string]$spn, [string]$spnSecret, [string]$recordMode, [string]$targetEnvironment, [string]$uris)
{

    if([string]::IsNullOrEmpty($uid) -eq $false)
    {
        Write-Host "UserId=" -ForegroundColor Green -NoNewline
        Write-Host $uid";" -NoNewline 
    }

    if([string]::IsNullOrEmpty($pwd) -eq $false)
    {
        Write-Host "Password=" -ForegroundColor Green -NoNewline
        Write-Host $pwd";" -NoNewline 
    }

    if([string]::IsNullOrEmpty($subId) -eq $false)
    {
        Write-Host "SubscriptionId=" -ForegroundColor Green -NoNewline
        Write-Host $subId";" -NoNewline 
    }

    if([string]::IsNullOrEmpty($aadTenant) -eq $false)
    {
        Write-Host "AADTenant=" -ForegroundColor Green -NoNewline
        Write-Host $aadTenant";" -NoNewline
    }

    if([string]::IsNullOrEmpty($spn) -eq $false)
    {
        Write-Host "ServicePrincipal=" -ForegroundColor Green -NoNewline
        Write-Host $spn";" -NoNewline
    }

    if([string]::IsNullOrEmpty($spnSecret) -eq $false)
    {
        Write-Host "ServicePrincipalSecret=" -ForegroundColor Green -NoNewline
        Write-Host $spnSecret";" -NoNewline
    }

    if([string]::IsNullOrEmpty($recordMode) -eq $false)
    {
        Write-Host "HttpRecorderMode=" -ForegroundColor Green -NoNewline
        Write-Host $recordMode";" -NoNewline
    }

    if([string]::IsNullOrEmpty($targetEnvironment) -eq $false)
    {
        Write-Host "Environment=" -ForegroundColor Green -NoNewline
        Write-Host $targetEnvironment";" -NoNewline
    }

    if([string]::IsNullOrEmpty($uris) -eq $false)
    {
        Write-Host "BaseUri=" -ForegroundColor Green -NoNewline
        Write-Host $uris -NoNewline
    }

    Write-Host ""
}

[CmdletBinding]
Function Get-BuildScopes
{
<#
.SYNOPSIS
You can build a particular package rather than doing a full build by providing Build Scope.
This cmdlet will help to identify existing Scope available
This will enable to execute Start-RepoBuild <scope>

#>

    Write-Host "Below are available scopes you can specify for building specific projects"
    Write-Host ""    
    Get-ChildItem -path "$env:repoRoot\src\ResourceManager" -dir | Format-Wide -Column 5 | Format-Table -Property Name    
    Get-ChildItem -path "$env:repoRoot\src\ServiceManagement" -dir | Format-Wide -Column 5 | Format-Table -Property Name
}

[CmdletBinding]
Function Start-Build
{
<#
.SYNOPSIS
This cmdlet will help to do either with full build or targeted build for specific scopes.

.PARAMETER BuildScope
Use Get-BuildScope cmdLet to get list of existing scopes that can be used to build
#>
    param(
    [parameter(Mandatory=$false, Position=0, HelpMessage='BuildScope that you would like to use. For list of build scopes, run List-BuildScopes')]
    [string]$BuildScope
    )    
    
    if([string]::IsNullOrEmpty($BuildScope) -eq $true)
    {
       Write-Host "Starting Full build"
       msbuild.exe "$env:repoRoot\build.proj" /t:Build
    }
    else
    {
        Write-Host "Building $BuildScope"
        msbuild.exe "$env:repoRoot\build.proj" /t:Build /p:Scope=$BuildScope
    }
}

[CmdletBinding]
Function Invoke-CheckinTests
{
<#
.SYNOPSIS
Runs all the check in tests
#>
    Write-Host "cmdline Args: msbuild.exe $env:repoRoot\build.proj /t:Test"
    msbuild.exe "$env:repoRoot\build.proj" /t:Test
}

<#
We allow users to include any helper powershell scripts they would like to include in the current session
Currently we support two ways to include helper powershell scripts
1) psuserspreferences environment variable
2) $env:USERPROFILE\psFiles directory
We will include all *.ps1 files from any of the above mentioned locations
#>
if([System.IO.Directory]::Exists($env:psuserpreferences))
{
	$userPsFileDir = $env:psuserpreferences
}
elseif([System.IO.Directory]::Exists("$env:USERPROFILE\psFiles"))
{
	$userPsFileDir = "$env:USERPROFILE\psFiles"
}

if([string]::IsNullOrEmpty($userPsFileDir) -eq $false)
{
	Get-ChildItem $userPsFileDir | WHERE {$_.Name -like "*.ps1"} | ForEach {
	Write-Host "Including $_" -ForegroundColor Green
	. $userPsFileDir\$_
	}
}
else
{
	Write-Host "Loading skipped. 'psuserpreferences' environment variable was not set to load user preferences." -ForegroundColor DarkYellow
}

export-modulemember -Function Set-TestEnvironment
export-modulemember -Function Get-BuildScopes
export-modulemember -Function Start-Build
export-modulemember -Function Invoke-CheckinTests