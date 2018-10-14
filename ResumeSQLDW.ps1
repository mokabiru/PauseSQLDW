$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

    "Logging in to Azure..."
    Add-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}
$sqldwdb = ""
$rgname = ""
$sqlsvr = ""

#Get the status of SQL Datawarehouses
$status = Get-AzureRmSqlDatabase -ResourceGroupName $rgname -ServerName $sqlsvr -DatabaseName $sqldwdb | Select Status 
Write-Output $status


Resume-AzureRmSqlDatabase -ResourceGroupName $rgname -ServerName $sqlsvr -DatabaseName $sqldwdb
Write-Output "Started"
