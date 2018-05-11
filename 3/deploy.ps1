Login-AzureRmAccount

$ResourceGroupName = "Task3"

New-AzureRmResourceGroup -Name $ResourceGroupName -Location westeurope -Verbose
New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName 