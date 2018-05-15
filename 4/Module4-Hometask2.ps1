$RG = 'RG'
$RG2 = 'RG2'
$StorageName = 'sascriptstraining'
$Location = 'westeurope'
$DSCConfigPath = 'https://raw.githubusercontent.com/SayreX86/Azure/master/Module4/MyDsc.ps1'
$TempDSCCOnfigPath = "$env:TEMP\MyDsc.ps1"
$vmname = 'vmnametraining'

#Check for DSC resources and install if it needs
$netmodule = Get-DscResource -Module xNetworking | Select-Object -First 1
$webadmmodule = Get-DscResource -Module xWebAdministration | Select-Object -First 1
if ($netmodule.ModuleName -eq $null) {
    Write-Host 'xNetworking module will be installed...' -BackgroundColor DarkCyan
    Install-Module -Name xNetworking -Scope CurrentUser -Force | Out-Null
}
if ($webadmmodule.ModuleName -eq $null) {
    Write-Host 'xWebAdministration module will be installed...' -BackgroundColor DarkCyan
    Install-Module -Name xWebAdministration -Scope CurrentUser -Force | Out-Null
}

#Log in Azure Account
Login-AzureRmAccount
$s = Get-AzureRmSubscription | Out-GridView -PassThru -Title "Select subscription"
Set-AzureRmContext -SubscriptionId $s.SubscriptionId
New-AzureRmResourceGroup -Name $RG2 -Location $Location -Force -Verbose

#Create StorageAccount to put DSC scripts
New-AzureRmStorageAccount -ResourceGroupName $RG2 -Name $StorageName -Type Standard_LRS -Location $Location -Verbose
Set-AzureRmCurrentStorageAccount -ResourceGroupName $RG2 -Name $StorageName -Verbose

#Download DSC script from GitHub and publish it
Invoke-WebRequest -Uri $DSCConfigPath -OutFile $TempDSCCOnfigPath
Publish-AzureRmVMDscConfiguration -ConfigurationPath $TempDSCCOnfigPath -ResourceGroupName $RG2 -StorageAccountName $StorageName -Force -Verbose

# Get the SAS token
$DSCSAS = New-AzureStorageBlobSASToken -Container 'windows-powershell-dsc' -Blob 'MyDsc.ps1.zip' -Permission r -ExpiryTime (Get-Date).AddHours(2000)

#Provide SAS token during deployment
New-AzureRmResourceGroup -Name $RG -Location westeurope -Force -Verbose
New-AzureRmResourceGroupDeployment -ResourceGroupName $RG `
-TemplateUri 'https://raw.githubusercontent.com/SayreX86/Azure/master/Module3/main.json' `
-DSC-SasToken $DSCSAS -DNS-Name $vmname -Verbose

#Check 8080 port access
$IE=new-object -com internetexplorer.application
$IE.navigate2("http://$vmname.westeurope.cloudapp.azure.com:8080/")
$IE.visible=$true