# Connect to Microsoft Graph (requires appropriate permissions)
Connect-MgGraph

# Import the CSV
$groups = Import-Csv -Path "C:\Path\To\File.csv"
foreach ($group in $groups) {
    $groupName = $group.CloudGroupName
    $groupDescription = $group.CloudGroupDescription


    # Check if group already exists to avoid duplicates
    $existingGroup = Get-MgGroup -Filter "displayName eq '$groupName'" -ConsistencyLevel eventual -CountVariable count
    if ($existingGroup) {
        Write-Host "Group '$groupName' already exists. Skipping..."
        continue
    }

    # Create the group
    New-MgGroup -DisplayName $groupName `
                -Description $groupDescription `
                -MailEnabled:$false `
                -MailNickname $groupName.Replace(".", "") `
                -SecurityEnabled:$true `
                -GroupTypes @()
    Write-Host "Created group: $groupName"
}
