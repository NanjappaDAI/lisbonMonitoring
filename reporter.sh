#!/bin/bash
baseURL=http://192.168.1.213:8090/app
accessKey=eyJ0eXAiOiAiVENWMiJ9.QksxMjlNWjFJLXhzY3JsUE5tMzROMGNuODk4.ZmQ2ZDkyNjYtMDUzYi00ZGFiLTg0ZTEtMjQyMDMzODE2ODEz
basicAuth=bmFuamFwcGEuc29tYWlhaDoxMjM0NTY

branchName=()
buildConfigId="Automation_AutomationReporter_ReporterBranch"
buildConfigIdMaster="Automation_AutomationReporter_ReporterMaster"
year=$(date +%y); month=$((10#$(date +%m))); if [ "$month" -eq 12 ]; then nextMonth=1; nextYear=$((year+1)); else nextMonth=$((month+1)); nextYear=$year; fi
branchName+=("${year}.${month}" "${nextYear}.${nextMonth}")

# Default to 0 if null or empty
latestBuildId1=$(curl -s "http://192.168.1.213:8090/app/rest/buildTypes/id:$buildConfigId/builds?locator=branch:${branchName[0]},state:finished,count:1" -H "Authorization: Bearer $accessKey" | sed -n 's/.*<build id="\([0-9]\{1,\}\)".*/\1/p')
latestBuildId2=$(curl -s "http://192.168.1.213:8090/app/rest/buildTypes/id:$buildConfigId/builds?locator=branch:${branchName[1]},state:finished,count:1" -H "Authorization: Bearer $accessKey" | sed -n 's/.*<build id="\([0-9]\{1,\}\)".*/\1/p')
latestBuildIdMaster=$(curl -s "http://192.168.1.213:8090/app/rest/buildTypes/id:$buildConfigIdMaster/builds/state:finished,count:1" -H "Authorization: Bearer $accessKey" | sed -n 's/.*<build id="\([0-9]\{1,\}\)".*/\1/p')

latestBuildId1=${latestBuildId1:-0}
latestBuildId2=${latestBuildId2:-0}
latestBuildIdMaster=${latestBuildIdMaster:-0}

maxBuildId=$latestBuildId1
if [ "$latestBuildId2" -gt "$maxBuildId" ]; then maxBuildId=$latestBuildId2; fi
if [ "$latestBuildIdMaster" -gt "$maxBuildId" ]; then maxBuildId=$latestBuildIdMaster; fi

#echo "Latest build ID: $maxBuildId"
ReporterStatus=$(curl -s "http://192.168.1.213:8090/app/rest/builds/id:$maxBuildId" -H "Authorization: Bearer $accessKey" | sed -n 's:.*<statusText>\(.*\)</statusText>.*:\1:p')
echo "Status Text: $ReporterStatus"