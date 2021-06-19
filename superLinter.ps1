$currentLocation = Get-Location
docker run -e RUN_LOCAL=true -v ${currentLocation}:/tmp/lint github/super-linter