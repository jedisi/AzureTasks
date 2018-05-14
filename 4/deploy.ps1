#Login-AzureRmAccount

$ResourceGroupName = "Task3"

New-AzureRmResourceGroup -Name $ResourceGroupName -Location westeurope -Verbose
New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName `
                                   -TemplateUri "https://raw.githubusercontent.com/jedisi/AzureTasks/master/3/main.json" `
                                   -TemplateParameterUri "https://raw.githubusercontent.com/jedisi/AzureTasks/master/3/param.json" -Debug
