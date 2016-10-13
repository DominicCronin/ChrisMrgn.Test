function Exec  
{
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory=1)][scriptblock]$cmd,
        [Parameter(Position=1,Mandatory=0)][string]$errorMessage = ($msgs.error_bad_command -f $cmd)
    )
    & $cmd
    if ($lastexitcode -ne 0) {
        throw ("Exec: " + $errorMessage)
    }
}


""
""

if(Test-Path .\artifacts) { Remove-Item .\artifacts -Force -Recurse }


"Restoring Packages"
"============================="
exec { & dotnet restore }



""
""
"Running Unit Tests"
"============================="
exec { & dotnet test ChrisMrgn.Test.Core.Tests -c Release }

""
""

"Creating Nuget Packages"
"============================="

$revision = @{ $true = $env:APPVEYOR_BUILD_NUMBER; $false = 1 }[$env:APPVEYOR_BUILD_NUMBER -ne $NULL];
$revision = "{0:D4}" -f [convert]::ToInt32($revision, 10)
exec { & dotnet pack ChrisMrgn.Test.Core -c Release -o .\artifacts --version-suffix=build-$revision }  
exec { & dotnet pack ChrisMrgn.Test.Models -c Release -o .\artifacts --version-suffix=build-$revision }  