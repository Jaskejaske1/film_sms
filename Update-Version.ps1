# Bump patch version in pubspec.yaml
$pubspec = Get-Content "pubspec.yaml"
$versionLine = $pubspec | Where-Object { $_ -match "^version:" }
if ($versionLine -match "(\d+\.\d+\.\d+)\+(\d+)") {
    $mainVer = $matches[1]
    $patch = [int]$matches[2] + 1
    $newVersion = "$mainVer+$patch"
    $pubspec = $pubspec -replace "^version:.*", "version: $newVersion"
    Set-Content "pubspec.yaml" $pubspec
    git add pubspec.yaml
    git commit -m "Bump version to $newVersion"
    git tag "v$newVersion"
    git push origin main
    git push origin "v$newVersion"
    Write-Host "Version bumped and tag pushed: $newVersion"
}
else {
    Write-Host "Could not find version line in pubspec.yaml"
}