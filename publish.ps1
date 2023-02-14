Push-Location $PSScriptRoot
try {
	Publish-Module -Path mkcidata
} finally {
	Pop-Location
}