$projectPath = "D:\DEV\generic-docker"

function dockerup {
    param (
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Profiles
    )

    # Display the profiles that were received
    Write-Host "Starting Docker with profiles: $($Profiles -join ', ')"

    # Navigate to the project path
    Set-Location $projectPath

    # Build the profile arguments
    $profileArgs = $Profiles | ForEach-Object { "--profile $_" }

    # Construct the full command for display
    $command = "docker-compose $($profileArgs -join ' ') up -d"
    Write-Host "Command to be executed: $command"

    # Execute the command
    Invoke-Expression $command
}

function dockerdown {
    param (
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Profiles
    )

    # Display the profiles that were received
    Write-Host "Stopping Docker with profiles: $($Profiles -join ', ')"

    # Navigate to the project path
    Set-Location $projectPath

    # Build the profile arguments
    $profileArgs = $Profiles | ForEach-Object { "--profile $_" }

    # Construct the full command for display
    $command = "docker-compose $($profileArgs -join ' ') down"
    Write-Host "Command to be executed: $command"

    # Execute the command
    Invoke-Expression $command
}
