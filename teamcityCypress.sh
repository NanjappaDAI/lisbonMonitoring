#!/bin/bash
baseURL=http://192.168.1.213:8090/app
accessKey=eyJ0eXAiOiAiVENWMiJ9.QksxMjlNWjFJLXhzY3JsUE5tMzROMGNuODk4.ZmQ2ZDkyNjYtMDUzYi00ZGFiLTg0ZTEtMjQyMDMzODE2ODEz
basicAuth=bmFuamFwcGEuc29tYWlhaDoxMjM0NTY

branchName=()
buildConfigId="Automation_AutomationCypress_CypressBranch"
buildConfigIdMaster="Automation_AutomationCypress_CypressMaster"
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
cypressStatus=$(curl -s "http://192.168.1.213:8090/app/rest/builds/id:$maxBuildId" -H "Authorization: Bearer $accessKey" | sed -n 's:.*<statusText>\(.*\)</statusText>.*:\1:p')
cypressBuildDate=$(curl -s "http://192.168.1.213:8090/app/rest/builds/id:$maxBuildId" -H "Authorization: Bearer $accessKey" | sed -n 's:.*<startDate>\([0-9]\{8\}\).*<\/startDate>.*:\1:p')

recentruns="/Users/auto/lisbonmonitor/cypress_latest.txt"
echo "$cypressBuildDate $cypressStatus" >> $recentruns
tail -n 14 $recentruns > cypress_latest.txt
sort -t':' -k3,3nr cypress_latest.txt -o cypress_latest.txt
averages=$(head -n 7 cypress_latest.txt | awk -F'[ ,:]+' '{for(i=1;i<=NF;i++){if($i=="failed")f+=$(i+1); if($i=="passed")p+=$(i+1);} c++} END{if(c>0) printf "%d %d", int(f/c), int(p/c); else print "0 0"}')
failed_avg=${averages%% *}
passed_avg=${averages#* }

echo "<tr> <td> $passed_avg </td> <td> $failed_avg </td> </tr>"


