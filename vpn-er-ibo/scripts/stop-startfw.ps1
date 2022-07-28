# PS Script to stop and star Azure Firewall

#Variables 
$RG = "lab-er-vpn-s2s-Internet"

#Stop Firewall

$azfw=Get-AzFirewall -ResourceGroupName $RG
$azfw | ForEach-Object {
    $_.Deallocate() 
    Write-Host "Stopping Azure Firewall" $_.name
    Set-AzFirewall -AzureFirewall $_ | Out-Null
    Write-Host "Azure Firewall" $_.name "has stopped"
}

#Start Firewall



$azfw=Get-AzFirewall -ResourceGroupName $RG
$azfw | ForEach-Object -Parallel {
    $publicip = Get-AzPublicIpAddress -ResourceGroupName $RG -Name Az-Hub-azfw-pip
    $vnet = Get-AzVirtualNetwork -Name Az-Hub-vnet -ResourceGroupName $RG
    $_.Allocate($vnet,$publicip) 
    Write-Host "Starting Azure Firewall" $_.name
    Set-AzFirewall -AzureFirewall $_ | Out-Null
    Write-Host "Azure Firewall" $_.name "has started"
}


$azfw = Get-AzFirewall -Name "Az-Hub-azfw" -ResourceGroupName $RG
$publicip = Get-AzPublicIpAddress -ResourceGroupName $RG -Name Az-Hub-azfw-pip
$vnet = Get-AzVirtualNetwork -Name Az-Hub-vnet -ResourceGroupName $RG
$azfw.Allocate($vnet,$publicip)
Set-AzFirewall -AzureFirewall $azfw