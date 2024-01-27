# Connect to Azure (Uncomment and run if not already connected)
#Connect-AzAccount -Tenant "0f5c3aa5-56ab-4224-b319-eaf948e8063f" -Subscription "3e93b848-f45a-4efa-ae91-e508f932bfda" -UseDeviceAuthentication

# Step 1: Create a new Resource Group
$resourceGroupName = "RG-costs-dont-matter1"
$location = "switzerlandnorth" # e.g., "East US"
$resourceGroup = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if (-not $resourceGroup) {
    New-AzResourceGroup -Name $resourceGroupName -Location $location
    Write-Host "Created new resource group: $resourceGroupName"
} else {
    Write-Host "Resource group $resourceGroupName already exists. Proceeding with script."
}

# Step 2: Create a new Key Vault
$keyVaultName = "networkingKeyvault"
$keyVault = Get-AzKeyVault -VaultName $keyVaultName -ResourceGroupName $resourceGroupName -ErrorAction SilentlyContinue
if (-not $keyVault) {
    New-AzKeyVault -Name $keyVaultName -ResourceGroupName $resourceGroupName -Location $location -EnabledForTemplateDeployment
    Write-Host "Created new Key Vault: $keyVaultName with enabledForTemplateDeployment set to true."
} else {
    Write-Host "Key Vault $keyVaultName already exists. Proceeding with script."
    # Ensure enabledForTemplateDeployment is set to true
    Set-AzKeyVaultAccessPolicy -VaultName $keyVaultName -EnabledForTemplateDeployment -EnabledForDeployment
    Write-Host "Set -EnabledForTemplateDeployment and -EnabledForDeployment to true for existing Key Vault."
}


# Step 3: Add a random secret to the Key Vault
$secretName = "FortigateAdminPassword"
$randomPassword = -join ((33..126) * 100 | Get-Random -Count 21 | ForEach-Object {[char]$_})
$secureStringPassword = ConvertTo-SecureString $randomPassword -AsPlainText -Force
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name $secretName -SecretValue $secureStringPassword
Write-Host "Added secret to Key Vault."

# New-AzRoleDefinition -InputFile "./parameters/KV-custom-role.json"
# New-AzRoleAssignment -ResourceGroupName $resourceGroupName -RoleDefinitionName "Key Vault Bicep deployment operator" -SignInName <user-principal-name>

# Step 4: Run a Bicep deployment at the subscription level
# $templateFile = "YourBicepFile.bicep" # Path to your Bicep file
# $templateParameters = @{
#     keyVaultName = $keyVaultName
#     secretName = $secretName
#     resourceGroupName = $resourceGroupName
#     # Add other parameters if needed
# }
# New-AzDeployment -Location $location -TemplateFile $templateFile -TemplateParameterObject $templateParameters

