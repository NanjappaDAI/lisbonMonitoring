#!/bin/bash
baseURL=http://192.168.1.213:8090/app
accessKey=eyJ0eXAiOiAiVENWMiJ9.QksxMjlNWjFJLXhzY3JsUE5tMzROMGNuODk4.ZmQ2ZDkyNjYtMDUzYi00ZGFiLTg0ZTEtMjQyMDMzODE2ODEz
basicAuth=bmFuamFwcGEuc29tYWlhaDoxMjM0NTY

ctStatus=$(curl -s "http://192.168.1.213:8090/app/rest/buildTypes/id:Automation_AutomationCloudExecution_ContinuousTestingMaster/builds/count:1" -H "Authorization: Bearer $accessKey" | sed -n 's:.*<statusText>\(.*\)</statusText>.*:\1:p')
ctBuildDate=$(curl -s "http://192.168.1.213:8090/app/rest/buildTypes/id:Automation_AutomationCloudExecution_ContinuousTestingMaster/builds/count:1" -H "Authorization: Bearer $accessKey" | sed -n 's:.*<startDate>\([0-9]\{8\}\).*<\/startDate>.*:\1:p')

recentruns="/Users/auto/lisbonmonitor/ct.txt"
echo "$ctBuildDate $ctStatus" >> $recentruns
tail -n 14 $recentruns > ct_latest.txt
sort -t':' -k3,3nr ct_latest.txt -o ct_latest.txt
averages=$(head -n 7 ct_latest.txt | awk -F'[ ,:]+' '{for(i=1;i<=NF;i++){if($i=="failed")f+=$(i+1); if($i=="passed")p+=$(i+1);} c++} END{if(c>0) printf "%d %d", int(f/c), int(p/c); else print "0 0"}')
failed_avg=${averages%% *}
passed_avg=${averages#* }

echo "<tr> <td> "CT" </td> <td> $passed_avg </td> <td> $failed_avg </td> </tr>" >> average.txt
echo "<tr> <td> "CT" </td> <td> $ctBuildDate </td> <td> $ctStatus </td> </tr>" >> dailyStatus.txt

