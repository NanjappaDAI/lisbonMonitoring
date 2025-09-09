#!/bin/bash
baseURL=http://192.168.1.213:8090/app
accessKey=eyJ0eXAiOiAiVENWMiJ9.QksxMjlNWjFJLXhzY3JsUE5tMzROMGNuODk4.ZmQ2ZDkyNjYtMDUzYi00ZGFiLTg0ZTEtMjQyMDMzODE2ODEz

LocalAppiumStatus=$(curl -s "http://192.168.1.213:8090/app/rest/buildTypes/id:Automation_AutomationCloudExecution_ContinuousTestingLocalAppium/builds/count:1" -H "Authorization: Bearer $accessKey" | sed -n 's:.*<statusText>\(.*\)</statusText>.*:\1:p')
LocalAppiumBuildDate=$(curl -s "http://192.168.1.213:8090/app/rest/buildTypes/id:Automation_AutomationCloudExecution_ContinuousTestingLocalAppium/builds/count:1" -H "Authorization: Bearer $accessKey" | sed -n 's:.*<startDate>\([0-9]\{8\}\).*<\/startDate>.*:\1:p')

recentruns="/Users/auto/lisbonmonitor/LocalAppium.txt"
echo "$LocalAppiumBuildDate $LocalAppiumStatus" >> $recentruns
tail -n 14 $recentruns > LocalAppium_latest.txt
sort -t':' -k3,3nr LocalAppium_latest.txt -o LocalAppium_latest.txt
averages=$(head -n 7 LocalAppium_latest.txt | awk -F'[ ,:]+' '{for(i=1;i<=NF;i++){if($i=="failed")f+=$(i+1); if($i=="passed")p+=$(i+1);} c++} END{if(c>0) printf "%d %d", int(f/c), int(p/c); else print "0 0"}')
failed_avg=${averages%% *}
passed_avg=${averages#* }

echo "<tr> <td> "Local Appium" </td> <td> $passed_avg </td> <td> $failed_avg </td> </tr>" > average.txt
echo "<tr> <td> "Local Appium" </td> <td> $LocalAppiumBuildDate </td> <td> $LocalAppiumStatus </td> </tr>" > dailyStatus.txt