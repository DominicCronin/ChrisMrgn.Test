
if(Test-Path .\artifacts) { Remove-Item .\artifacts -Force -Recurse }


"Restoring Packages"
"============================="
dotnet restore



""
""
"Running Unit Tests"
"============================="
dotnet test ChrisMrgn.Test.Core.Tests -c Release

""
""

"Creating Nuget Packages"
"============================="

$revision = if ($env:APPVEYOR_BUILD_NUMBER -ne $null){$env:APPVEYOR_BUILD_NUMBER} else {1}
$revision = "{0:D4}" -f [convert]::ToInt32($revision, 10)
dotnet pack ChrisMrgn.Test.Core -c Release -o .\artifacts --version-suffix=build-$revision
dotnet pack ChrisMrgn.Test.Models -c Release -o .\artifacts --version-suffix=build-$revision