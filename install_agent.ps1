<#
Replace <WORKSPACE_ID> and <PRIMARY_KEY> with values from Log Analytics workspace.
Run this script on a Windows VM to install the Log Analytics agent.
#>

$WorkspaceId = "<WORKSPACE_ID>"
$WorkspaceKey = "<PRIMARY_KEY>"

Write-Host "Place the MMASetup-AMD64.exe in this folder (download from Log Analytics > Agents management)."
Start-Process -FilePath ".\MMASetup-AMD64.exe" -ArgumentList "/Q:A /C:`"setup.exe /qn ADD_OPINSIGHTS=1 OPINSIGHTS_WORKSPACE_ID=$WorkspaceId OPINSIGHTS_WORKSPACE_KEY=$WorkspaceKey`"" -Wait

Write-Host "Agent install attempted. Confirm in the Log Analytics workspace -> Agent status."
