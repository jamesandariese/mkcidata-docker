Function New-CIDATAFile {
	param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position=0)]
        [Alias("Path")]
        [string] $Target,
        [string] $VolumeId = "CIDATA",
        [string] $Image = "jamesandariese/mkcidata:alpine-3.17.2_xorriso-1.5.4-r2",
		[Parameter(ValueFromRemainingArguments)]
        [string[]]
        $files
	)
    
    if (Test-Path $Target) {
        throw "$Target already exists"
    }
    if (-not (Test-Path -isvalid $Target)) {
        throw "$Target path is invalid"
    }

    $cid = $(docker run -d -e "VOLUMEID=${CIDATA}" $Image @files)
    
    docker logs -f $cid 2>&1 `
          | Where-Object {
            ($null -ne $_) -and ("" -ne $_)
        } | ForEach-Object {
            Write-Debug "$_" ; Write-Progress -Activity "building iso" -Status "$_" -PercentComplete -1
        }

    if ($(docker wait $cid) -ne 0) {
        throw "mkisofs returned a failure.  please run with -Debug to determine why."
    }
    docker cp "${cid}:/out/build-iso.iso" $Target
}
