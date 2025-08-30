#!/bin/bash
accessKey=eyJhbGciOiJIUzI1NiJ9.eyJ4cC51Ijo0MiwieHAucCI6MywieHAubSI6MTcwMTAwMjYwNzIxMiwiZXhwIjoyMDE2MzYyNjA3LCJpc3MiOiJjb20uZXhwZXJpdGVzdCJ9.SMGYMR4IFha22QTlFFHg9UdyayG4kx4VcRHg7PjsYBY
dateval=$(date)
deviceArray=()
exec > /Users/auto/lisbonmonitor/outputfile.txt

echo "start-here";
echo "<html><body><table border=1>"
echo "<tr><td><span style='color:#1e90ff'>LISBON cloud monitoring report</span>:</td><td> $dateval </td></tr>"

porto=$(/usr/local/bin/sshpass -p Ab123456 ssh -o StrictHostKeyChecking=no auto@192.168.2.80 'df -h | grep disk1s1')
#porto=$(sshpass -p Ab123456 ssh -o StrictHostKeyChecking=no auto@192.168.2.80 'df -h | grep disk1s1')
IFS=' ' read -ra deviceSplit <<< "$porto"
portofs=${deviceSplit[3]}
echo "<tr><td> Porto free space </td><td> $portofs </td></tr>"


sintra=$(/usr/local/bin/sshpass -p Ab123456 ssh -o StrictHostKeyChecking=no auto@192.168.4.22 'df -h | grep disk1s5')
IFS=' ' read -ra deviceSplit <<< "$sintra"
sintrafs=${deviceSplit[3]}
echo "<tr><td> Sintra free space </td><td> $sintrafs </td></tr>"

elvas=$(/usr/local/bin/sshpass -p Ab123456 ssh -o StrictHostKeyChecking=no auto@192.168.2.150 'df -h | grep disk3s5')
IFS=' ' read -ra deviceSplit <<< "$elvas"
elvasfs=${deviceSplit[3]}
echo "<tr><td> Elvas free space </td><td> $elvasfs </td></tr>"

lisbon=$(/usr/local/bin/sshpass -p Ab123456 ssh -o StrictHostKeyChecking=no auto@192.168.6.105 'df -h | grep lv')
IFS=' ' read -ra deviceSplit <<< "$lisbon"
lisbonfs=${deviceSplit[3]}
echo "<tr><td> Lisbon free space </td><td> $lisbonfs </td></tr>"

reporter=$(/usr/local/bin/sshpass -p Ab123456 ssh -o StrictHostKeyChecking=no auto@192.168.6.106 'df -h | grep lv')
IFS=' ' read -ra deviceSplit <<< "$reporter"
reporterfs=${deviceSplit[3]}
echo "<tr><td> Reporter free space </td><td> $reporterfs </td></tr>"

uploads=$(/usr/local/bin/sshpass -p Ab123456 ssh -o StrictHostKeyChecking=no auto@192.168.6.106 'du -sh /var/lib/Experitest/reporter/uploads/')
IFS='/' read -ra deviceSplit <<< "$uploads"
uploadsSize=${deviceSplit[0]}
echo "<tr><td> Reporter uploads folder size </td><td> $uploadsSize </td></tr>"

tcagent=$(/usr/local/bin/sshpass -p Ab123456 ssh -o StrictHostKeyChecking=no auto@192.168.4.60 'df -h | grep disk1s1')
IFS=' ' read -ra deviceSplit <<< "$tcagent"
tcagentfs=${deviceSplit[3]}
echo "<tr><td> Teamcity agent free space </td><td>$tcagentfs</td></tr>"

nvserverArray=$(curl -s GET 'https://lisbon.experitest.com/api/v2/nv-servers' -H "Authorization: Bearer $accessKey" | jq -rj '.[]|"\(.name): \(.status): \(.version);"')
IFS=';' eval 'array=($nvserverArray)'
echo "<tr><td>NV server 1 </td><td> ${array[0]} </td></tr>"
echo "<tr><td>NV server 2 </td><td> ${array[1]} </td></tr>"

agentsArray=$(curl -s GET 'https://lisbon.experitest.com/api/v2/agents' -H "Authorization: Bearer $accessKey" | jq -rj '.[]|"\(.name): \(.statusForDisplay):  \(.version): \(.nvServerName);"')
IFS=';' eval 'array=($agentsArray)'
echo "<tr><td>Agent 1 </td><td> ${array[0]} </td></tr>"
echo "<tr><td>Agent 2 </td><td> ${array[1]} </td></tr>"
echo "<tr><td>Agent 3 </td><td> ${array[2]} </td></tr>"
echo "<tr><td>Agent 4 </td><td> ${array[3]} </td></tr>"
echo "<tr><td>Agent 5 </td><td> ${array[4]} </td></tr>"


regionArray=$(curl -s GET 'https://lisbon.experitest.com/api/v2/regions' -H "Authorization: Bearer $accessKey" | jq -rj '.[]|"\(.name): \(.status): \(.version);"')
IFS=';' eval 'array=($regionArray)'
echo

echo "<tr><td>Region 1 </td><td> ${array[0]} </td></tr>"
echo "<tr><td>Region 2 </td><td> ${array[1]} </td></tr>"

servicesArray=$(curl -s GET 'https://lisbon.experitest.com/api/v2/region-services' -H "Authorization: Bearer $accessKey" | jq -rj '.[]|"\(.hostOrIp) \(.type): \(.status): \(.version);"')
IFS=';' eval 'array=($servicesArray)'
echo "<tr><td>Service 1 </td><td> ${array[0]} </td></tr>"
echo "<tr><td>Service 2 </td><td> ${array[1]} </td></tr>"
echo "<tr><td>Service 3 </td><td> ${array[2]} </td></tr>"
echo "<tr><td>Service 4 </td><td> ${array[3]} </td></tr>"
echo "<tr><td>Service 5 </td><td> ${array[4]} </td></tr>"
echo "<tr><td>Service 6 </td><td> ${array[5]} </td></tr>"
echo "<tr><td>Service 7 </td><td> ${array[6]} </td></tr>"
echo "<tr><td>Service 8 </td><td> ${array[7]} </td></tr>"
echo "</table></body></html>";
echo "<p>       </p>"

echo "<html><body><table border=1>"
deviceArray=$(curl -s GET 'https://lisbon.experitest.com/api/v1/devices' -H "Authorization: Bearer $accessKey" | jq -rj '.data[]|"\(.id)%\(.deviceName)%\(.region)%\(.deviceOs)%\(.osVersion)%\(.agentName)%\(.bluetooth);"')
IFS=';' eval 'array=($deviceArray)'
ai=1
i=1
for element in ${array[@]}; do
  max=0
  extraChars=""
  IFS='%' read -ra deviceSplit <<< "$element"
  deviceID=${deviceSplit[0]}
  deviceName=${deviceSplit[1]}
  deviceRegion=${deviceSplit[2]}
  deviceOS=${deviceSplit[3]}
  OSVersion=${deviceSplit[4]}
  agentName=${deviceSplit[5]}
  btStatus=${deviceSplit[6]}
  max="$((17-${#deviceName}))"

  deviceName=$(echo $deviceName | tr '[:lower:]' '[:upper:]')
if [ ! -z "$deviceRegion" -a "$deviceRegion" != " " ]; then
  deviceIP=$(curl -s GET https://lisbon.experitest.com/api/v1/devices/$deviceID/WifiIPAddress -H "Authorization: Bearer $accessKey" | jq -rj '(.v4)," ",(.ssid)')
  IFS=' ' read -ra deviceIPSplit <<< "$deviceIP"
  deviceIPAddr=${deviceIPSplit[0]}
  deviceWiFiName=${deviceIPSplit[1]}
if [ "$deviceOS" == "Android" ]; then
  echo $deviceName
  curlOP=$(curl -s -L -X GET https://lisbon.experitest.com/api/v1/devices/$deviceID/cacerts -H "Authorization: Bearer $accessKey")
  if [[ $curlOP == *"mitmproxy"* ]]; then
  mitmCertsAvailable="MITM"
  else
  mitmCertsAvailable="   "
  fi
  echo "<tr><td> ${ai}"." </td><td> $deviceName </td><td> ${deviceID} </td><td> ${agentName:0:5} </td><td> ${OSVersion} </td><td> ${mitmCertsAvailable} </td><td> ${deviceIPAddr} </td><td> ${deviceWiFiName} </td></tr>"
  ai=$((ai+1))
fi
fi
done
echo "</table></body></html>";
echo "<p>       </p>"

echo "<html><body><table border=1>"
for element in ${array[@]}; do
  IFS='%' read -ra deviceSplit <<< "$element"
  deviceID=${deviceSplit[0]}
  deviceName=${deviceSplit[1]}
  deviceRegion=${deviceSplit[2]}
  deviceOS=${deviceSplit[3}
  OSVersion=${deviceSplit[4]}
  agentName=${deviceSplit[5]}
  btStatus=${deviceSplit[6]}
if [ ! -z "$deviceRegion" -a "$deviceRegion" != " " ]; then
  deviceIP=$(curl -s GET https://lisbon.experitest.com/api/v1/devices/$deviceID/WifiIPAddress -H "Authorization: Bearer $accessKey" | jq -rj '(.v4)," ",(.ssid)')
  IFS=' ' read -ra deviceIPSplit <<< "$deviceIP"
if [ $deviceOS == iOS ]; then
  echo "<tr><td> ${i}"."   </td><td> ${deviceName}        </td><td> ${deviceID} </td><td> ${agentName:0:5} </td><td> ${OSVersion} </td><td> ${deviceIP} </td><td> ${btStatus//null/} </td></tr>"
  i=$((i+1))
 fi
 fi
done
echo "</table></body></html>";
echo "<p>       </p>"

echo "<html><body><table border=1>"
echo "<tr><td><span style='color:#1e90ff'>BERN cloud monitoring report </span> :</td><td> $dateval </td></tr>"
bern=$(/usr/local/bin/sshpass -p Ab123456 ssh -o StrictHostKeyChecking=no auto@192.168.6.103 'df -h | grep ubuntu')
IFS=' ' read -ra deviceSplit <<< "$bern"
bernfs=${deviceSplit[3]}
echo "<tr><td> Bern free space </td><td> $bernfs </td></tr>"

zurichUploads=$(/usr/local/bin/sshpass -p Ab123456 ssh -o StrictHostKeyChecking=no auto@192.168.4.17 'du -sh /var/lib/Experitest/reporter/uploads/')
IFS='/' read -ra deviceSplit <<< "$zurichUploads"
zurichUploadsSize=${deviceSplit[0]}
echo "<tr><td> Reporter uploads folder size </td><td> $zurichUploadsSize </td></tr>"

bernAccessKey=eyJhbGciOiJIUzI1NiJ9.eyJ4cC51Ijo0NiwieHAucCI6MSwieHAubSI6MTYxODMyMTUzMjE0MSwiZXhwIjoxOTMzNjgxNTMyLCJpc3MiOiJjb20uZXhwZXJpdGVzdCJ9.c0tfNig-U-Xlj5yurF3_z9UXMAav-MU-6-8rXOXIQSM

bernAgentsArray=$(curl -s GET 'https://bern.experitest.com/api/v2/agents' -H "Authorization: Bearer $bernAccessKey" | jq -rj '.[]|"\(.name): \(.statusForDisplay):  \(.version);"')
IFS=';' eval 'array=($bernAgentsArray)'
echo "<tr><td>Agent 1 </td><td> ${array[0]} </td></tr>"

bernRegionArray=$(curl -s GET 'https://bern.experitest.com/api/v2/regions' -H "Authorization: Bearer $bernAccessKey" | jq -rj '.[]|"\(.name): \(.status): \(.version);"')
IFS=';' eval 'array=($bernRegionArray)'
echo
echo "<tr><td>Region 1 </td><td> ${array[0]} </td></tr>"

bernServicesArray=$(curl -s GET 'https://bern.experitest.com/api/v2/region-services' -H "Authorization: Bearer $bernAccessKey" | jq -rj '.[]|"\(.hostOrIp) \(.type): \(.status): \(.version);"')
IFS=';' eval 'array=($bernServicesArray)'
echo "<tr><td>Service 1 </td><td> ${array[0]} </td></tr>"
echo "<tr><td>Service 2 </td><td> ${array[1]} </td></tr>"
echo "<tr><td>Service 3 </td><td> ${array[2]} </td></tr>"
echo "</table></body></html>";
echo "<p>       </p>"

echo "<html><body><table border=1>"
echo "<tr><td><span style='color:#1e90ff'>WASHINGTON cloud monitoring report </span> :</td><td> $dateval </td></tr>"
washington=$(/usr/local/bin/sshpass -p Ab123456 ssh -o StrictHostKeyChecking=no auto@192.168.2.83 'df -h | grep centos-home')
IFS=' ' read -ra deviceSplit <<< "$washington"
washingtonfs=${deviceSplit[3]}
echo "<tr><td> Washington free space </td><td> $washingtonfs </td></tr>"

washingtonUploads=$(/usr/local/bin/sshpass -p Ab123456 ssh -o StrictHostKeyChecking=no auto@192.168.2.83 'du -sh /home/qa/data/reporter/uploads')
IFS='/' read -ra deviceSplit <<< "$washingtonUploads"
washingtonUploadsSize=${deviceSplit[0]}
echo "<tr><td> Reporter uploads folder size </td><td> $washingtonUploadsSize </td></tr>"

washingtonAccessKey=eyJhbGciOiJIUzI1NiJ9.eyJ4cC51Ijo0OSwieHAucCI6MSwieHAubSI6MTU5NzU3NTg5MjQwNywiZXhwIjoxOTEyOTM1ODkyLCJpc3MiOiJjb20uZXhwZXJpdGVzdCJ9.IfZLbSPp-tKjszUJ4juOainuWkUZzlSa72ijnTMOSuo

washingtonAgentsArray=$(curl -s GET 'https://washington.experitest.com/api/v2/selenium-agents' -H "Authorization: Bearer $washingtonAccessKey" | jq -rj '.[]|"\(.name): \(.connected): \(.status):  \(.version);"')
IFS=';' eval 'array=($washingtonAgentsArray)'
echo "<tr><td>Agent 1 </td><td> ${array[0]} </td></tr>"
echo "<tr><td>Agent 2 </td><td> ${array[1]} </td></tr>"
echo "<tr><td>Agent 3 </td><td> ${array[2]} </td></tr>"
echo "<tr><td>Agent 4 </td><td> ${array[3]} </td></tr>"

washingtonRegionArray=$(curl -s GET 'https://washington.experitest.com/api/v2/regions' -H "Authorization: Bearer $washingtonAccessKey" | jq -rj '.[]|"\(.name): \(.status): \(.version);"')
IFS=';' eval 'array=($washingtonRegionArray)'
echo
echo "<tr><td>Region 1 </td><td> ${array[0]} </td></tr>"

washingtonServicesArray=$(curl -s GET 'https://washington.experitest.com/api/v2/region-services' -H "Authorization: Bearer $washingtonAccessKey" | jq -rj '.[]|"\(.hostOrIp) \(.type): \(.status): \(.version);"')
IFS=';' eval 'array=($washingtonServicesArray)'
echo "<tr><td>Service 1 </td><td> ${array[0]} </td></tr>"
echo "<tr><td>Service 2 </td><td> ${array[1]} </td></tr>"
echo "<tr><td>Service 3 </td><td> ${array[2]} </td></tr>"
echo "</table></body></html>";
echo "<p>       </p>"

echo "<html><body><table border=1>"
echo "<tr><td><span style='color:#1e90ff'>SEOUL cloud monitoring report </span> :</td><td> $dateval </td></tr>"
seoul=$(/usr/local/bin/sshpass -p Ab123456 ssh -o StrictHostKeyChecking=no auto@192.168.2.174 'df -h | grep ubuntu')
IFS=' ' read -ra deviceSplit <<< "$seoul"
seoulfs=${deviceSplit[3]}
echo "<tr><td> Seoul free space </td><td> $seoulfs </td></tr>"

seoulUploads=$(/usr/local/bin/sshpass -p Ab123456 ssh -o StrictHostKeyChecking=no auto@192.168.2.174 'du -sh /var/lib/Experitest/reporter/uploads')
IFS='/' read -ra deviceSplit <<< "$seoulUploads"
seoulUploadsSize=${deviceSplit[0]}
echo "<tr><td> Reporter uploads folder size </td><td> $seoulUploadsSize </td></tr>"

seoulAccessKey=eyJhbGciOiJIUzI1NiJ9.eyJ4cC51Ijo0NiwieHAucCI6MSwieHAubSI6MTYxODMyMTUzMjE0MSwiZXhwIjoxOTMzNjgxNTMyLCJpc3MiOiJjb20uZXhwZXJpdGVzdCJ9.c0tfNig-U-Xlj5yurF3_z9UXMAav-MU-6-8rXOXIQSM

seoulRegionArray=$(curl -s GET 'https://seoul.experitest.com/api/v2/regions' -H "Authorization: Bearer $seoulAccessKey" | jq -rj '.[]|"\(.name): \(.status): \(.version);"')
IFS=';' eval 'array=($seoulRegionArray)'
echo
echo "<tr><td>Region 1 </td><td> ${array[0]} </td></tr>"

seoulServicesArray=$(curl -s GET 'https://seoul.experitest.com/api/v2/region-services' -H "Authorization: Bearer $seoulAccessKey" | jq -rj '.[]|"\(.hostOrIp) \(.type): \(.status): \(.version);"')
IFS=';' eval 'array=($seoulServicesArray)'
echo "<tr><td>Service 1 </td><td> ${array[0]} </td></tr>"
echo "<tr><td>Service 2 </td><td> ${array[1]} </td></tr>"
echo "<tr><td>Service 3 </td><td> ${array[2]} </td></tr>"
echo "<tr><td>Service 3 </td><td> ${array[3]} </td></tr>"
echo "</table></body></html>";
echo "<p>       </p>"

echo "<html><body><table border=1>"
echo "<tr><td><span style='color:#1e90ff'>TOKYO cloud monitoring report </span> :</td><td> $dateval </td></tr>"
tokyo=$(/usr/local/bin/sshpass -p Ab123456 ssh -o StrictHostKeyChecking=no auto@192.168.6.201 'df -h | grep ubuntu')
IFS=' ' read -ra deviceSplit <<< "$tokyo"
tokyofs=${deviceSplit[3]}
echo "<tr><td> tokyo free space </td><td> $tokyofs </td></tr>"

tokyoUploads=$(/usr/local/bin/sshpass -p Ab123456 ssh -o StrictHostKeyChecking=no auto@192.168.6.201 'du -sh /var/lib/Experitest/reporter/uploads')
IFS='/' read -ra deviceSplit <<< "$tokyoUploads"
tokyoUploadsSize=${deviceSplit[0]}
echo "<tr><td> Reporter uploads folder size </td><td> $tokyoUploadsSize </td></tr>"

tokyoAccessKey=eyJhbGciOiJIUzI1NiJ9.eyJ4cC51Ijo0NiwieHAucCI6MSwieHAubSI6MTYxODMyMTUzMjE0MSwiZXhwIjoxOTMzNjgxNTMyLCJpc3MiOiJjb20uZXhwZXJpdGVzdCJ9.c0tfNig-U-Xlj5yurF3_z9UXMAav-MU-6-8rXOXIQSM

tokyoAgentsArray=$(curl -s GET 'https://tokyo.experitest.com/api/v2/selenium-agents' -H "Authorization: Bearer $tokyoAccessKey" | jq -rj '.[]|"\(.name): \(.connected): \(.status):  \(.version);"')
IFS=';' eval 'array=($tokyoAgentsArray)'
echo "<tr><td>Agent 1 </td><td> ${array[0]} </td></tr>"
echo "<tr><td>Agent 2 </td><td> ${array[1]} </td></tr>"
echo "<tr><td>Agent 3 </td><td> ${array[2]} </td></tr>"
echo "<tr><td>Agent 4 </td><td> ${array[3]} </td></tr>"
echo "<tr><td>Agent 5 </td><td> ${array[4]} </td></tr>"

tokyoRegionArray=$(curl -s GET 'https://tokyo.experitest.com/api/v2/regions' -H "Authorization: Bearer $tokyoAccessKey" | jq -rj '.[]|"\(.name): \(.status): \(.version);"')
IFS=';' eval 'array=($tokyoRegionArray)'
echo
echo "<tr><td>Region 1 </td><td> ${array[0]} </td></tr>"

tokyoServicesArray=$(curl -s GET 'https://tokyo.experitest.com/api/v2/region-services' -H "Authorization: Bearer $tokyoAccessKey" | jq -rj '.[]|"\(.hostOrIp) \(.type): \(.status): \(.version);"')
IFS=';' eval 'array=($tokyoServicesArray)'
echo "<tr><td>Service 1 </td><td> ${array[0]} </td></tr>"
echo "<tr><td>Service 2 </td><td> ${array[1]} </td></tr>"
echo "<tr><td>Service 3 </td><td> ${array[2]} </td></tr>"
echo "</table></body></html>";
echo "<p>       </p>"


echo "end-here";
