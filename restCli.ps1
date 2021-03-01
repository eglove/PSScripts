# Temporary script to run restCLI and remove annoying logs
java -jar restcli.jar -e "dev" trello.http --log-level=NONE
Remove-Item -Recurse -Force test-reports