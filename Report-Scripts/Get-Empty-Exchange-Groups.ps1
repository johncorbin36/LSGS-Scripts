# Parameters for script
param([String]$FilePath="C:\temp\Empty-Exchange-Groups.csv")

# Connect to script dependencies 
Connect-ExchangeOnline

# Create CSV for data
if (Test-Path $FilePath) { Remove-Item $FilePath }
Add-Content -Path $FilePath -Value '"Distrobution Group Name","Distrobution Group Email"'

# For each distribution group in exchange online
$i = 0
foreach ($Group in $Groups = Get-DistributionGroup -ResultSize Unlimited) {
    
    # Write progress
    $i++
    Write-Progress -Activity "Checking group:" $Group.DisplayName -Status "$(($i / $Groups.Count)* 100)% Complete:" -PercentComplete (($i / $Groups.Count)* 100)

    # Check if the group is empty and write to list if true
    if ($(Get-DistributionGroupMember -Identity $Group.DisplayName).Count -eq 0) {

        # Write group to file
        Write-Host $Group.DisplayName "is empty." -ForegroundColor DarkYellow
        Add-Content -Path $FilePath -Value "$($Group.DisplayName),$($Group.PrimarySmtpAddress)"

    }

}

# Complete
Write-Host 'Script complete.'
Write-Host "Data exported to $($FilePath)"
