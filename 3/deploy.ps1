#Login-AzureRmAccount

$ResourceGroupName = "Task3"

New-AzureRmResourceGroup -Name $ResourceGroupName -Location westeurope -Verbose
New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile "C:\Users\Aliaksandr_Simanau\Desktop\Azure\Git\AzureTasks\3\main.json" -TemplateParameterUri "https://raw.githubusercontent.com/jedisi/AzureTasks/master/3/param.json" -debug
