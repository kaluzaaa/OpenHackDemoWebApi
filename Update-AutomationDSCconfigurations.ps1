Param(
  [string]$ResourceGroupName = $env:AUTOMATIONACCOUNTRESOURCEGROUPNAME,
  [string]$AutomationAccountName = $env:AUTOMATIONACCOUNTNAME,
  [string]$ConfigurationName = $env:DSCCONFIGURATIONNAME
)

$BuildNumber = ($env:BUILD_BUILDNUMBER).Replace("_","").Replace($env:BUILD_DEFINITIONNAME,"")

Set-AzureRmAutomationVariable -ResourceGroupName $ResourceGroupName `
    -AutomationAccountName $AutomationAccountName `
    -Name "LoBVersion" -Value "$($BuildNumber)" -Encrypted $False

Set-AzureRmAutomationVariable -ResourceGroupName $ResourceGroupName `
    -AutomationAccountName $AutomationAccountName `
    -Name "LoBVersionUri" -Value "$($env:LOBVERSIONURI)" -Encrypted $False

Set-AzureRmAutomationVariable -ResourceGroupName $ResourceGroupName `
    -AutomationAccountName $AutomationAccountName `
    -Name "LoBVersionSASToken" -Value "$($env:LOBVERSIONSASTOKEN)" -Encrypted $False

Set-AzureRmAutomationVariable -ResourceGroupName $ResourceGroupName `
    -AutomationAccountName $AutomationAccountName `
    -Name "LoBName" -Value "$($env:BUILD_BUILDNUMBER)" -Encrypted $False

$output = Start-AzureRmAutomationDscCompilationJob -ResourceGroupName $ResourceGroupName `
            -AutomationAccountName $AutomationAccountName `
            -ConfigurationName $ConfigurationName
            
while( ($output | Get-AzureRmAutomationDscCompilationJob).EndTime -eq $null)
{
    Start-Sleep -s 5
    "Waiting for Dsc Compilation Job..."
}
"Dsc Compilation Job Done!"