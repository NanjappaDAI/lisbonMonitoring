#!/bin/sh
accessKey=eyJhbGciOiJIUzI1NiJ9.eyJ4cC51Ijo0MiwieHAucCI6MywieHAubSI6MTcwMTAwMjYwNzIxMiwiZXhwIjoyMDE2MzYyNjA3LCJpc3MiOiJjb20uZXhwZXJpdGVzdCJ9.SMGYMR4IFha22QTlFFHg9UdyayG4kx4VcRHg7PjsYBY
dateval=$(date)
deviceArray=()
exec > /Users/auto/lisbonmonitor/outputfile.txt

echo "<html><body><table border=1>"
echo "<tr><td><span style='color:#1e90ff'>BERN cloud monitoring report </span> :</td><td> $dateval </td></tr>"
bern=$(/usr/local/bin/sshpass -p Ab123456 ssh -o StrictHostKeyChecking=no auto@192.168.6.103 'df -h | grep ubuntu')
IFS=' ' read -ra deviceSplit <<< "$bern"
bernfs=${deviceSplit[3]}
echo "<tr><td> Bern free space </td><td> $bernfs </td></tr>"

zurichUploads=$(/usr/local/bin/sshpass -p Ab123456 ssh -o StrictHostKeyChecking=no auto@192.168.4.17 'du -sh /var/lib/Experitest/reporter/uploads/')
IFS='/' read -ra deviceSplit <<< "$zurichUploads"
zurichUploadsSize=${deviceSplit[0]}
echo "<tr><td> Zurich reporter uploads folder size </td><td> $zurichUploadsSize </td></tr>"

bernAccessKey=eyJhbGciOiJIUzI1NiJ9.eyJ4cC51Ijo0NiwieHAucCI6MSwieHAubSI6MTYxODMyMTUzMjE0MSwiZXhwIjoxOTMzNjgxNTMyLCJpc3MiOiJjb20uZXhwZXJpdGVzdCJ9.c0tfNig-U-Xlj5yurF3_z9UXMAav-MU-6-8rXOXIQSM

bernAgentsArray=$(curl -s GET 'https://bern.experitest.com/api/v2/agents' -H "Authorization: Bearer $bernAccessKey" | jq -rj '.[]|"\(.name): \(.statusForDisplay):  \(.version);"')
IFS=';' eval 'array=($bernAgentsArray)'
echo "<tr><td> Bern Agent 1 </td><td> ${array[0]} </td></tr>"

bernRegionArray=$(curl -s GET 'https://bern.experitest.com/api/v2/regions' -H "Authorization: Bearer $bernAccessKey" | jq -rj '.[]|"\(.name): \(.status): \(.version);"')
IFS=';' eval 'array=($bernRegionArray)'
echo
echo "<tr><td> Bern Region 1 </td><td> ${array[0]} </td></tr>"

bernServicesArray=$(curl -s GET 'https://bern.experitest.com/api/v2/region-services' -H "Authorization: Bearer $bernAccessKey" | jq -rj '.[]|"\(.hostOrIp) \(.type): \(.status): \(.version);"')
IFS=';' eval 'array=($bernServicesArray)'
echo "<tr><td> Bern Service 1 </td><td> ${array[0]} </td></tr>"
echo "<tr><td> Bern Service 2 </td><td> ${array[1]} </td></tr>"
echo "<tr><td> Bern Service 3 </td><td> ${array[2]} </td></tr>"
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
echo "<tr><td> Washington reporter uploads folder size </td><td> $washingtonUploadsSize </td></tr>"

washingtonAccessKey=eyJhbGciOiJIUzI1NiJ9.eyJ4cC51Ijo0OSwieHAucCI6MSwieHAubSI6MTU5NzU3NTg5MjQwNywiZXhwIjoxOTEyOTM1ODkyLCJpc3MiOiJjb20uZXhwZXJpdGVzdCJ9.IfZLbSPp-tKjszUJ4juOainuWkUZzlSa72ijnTMOSuo

washingtonAgentsArray=$(curl -s GET 'https://washington.experitest.com/api/v2/selenium-agents' -H "Authorization: Bearer $washingtonAccessKey" | jq -rj '.[]|"\(.name): \(.connected): \(.status):  \(.version);"')
IFS=';' eval 'array=($washingtonAgentsArray)'
echo "<tr><td> Washington Selenium Agent 1 </td><td> ${array[0]} </td></tr>"
echo "<tr><td> Washington Selenium Agent 2 </td><td> ${array[1]} </td></tr>"
echo "<tr><td> Washington Selenium Agent 3 </td><td> ${array[2]} </td></tr>"
echo "<tr><td> Washington Selenium Agent 4 </td><td> ${array[3]} </td></tr>"

washingtonRegionArray=$(curl -s GET 'https://washington.experitest.com/api/v2/regions' -H "Authorization: Bearer $washingtonAccessKey" | jq -rj '.[]|"\(.name): \(.status): \(.version);"')
IFS=';' eval 'array=($washingtonRegionArray)'
echo
echo "<tr><td> Washington Region 1 </td><td> ${array[0]} </td></tr>"

washingtonServicesArray=$(curl -s GET 'https://washington.experitest.com/api/v2/region-services' -H "Authorization: Bearer $washingtonAccessKey" | jq -rj '.[]|"\(.hostOrIp) \(.type): \(.status): \(.version);"')
IFS=';' eval 'array=($washingtonServicesArray)'
echo "<tr><td> Washington Service 1 </td><td> ${array[0]} </td></tr>"
echo "<tr><td> Washington Service 2 </td><td> ${array[1]} </td></tr>"
echo "<tr><td> Washington Service 3 </td><td> ${array[2]} </td></tr>"
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
echo "<tr><td> Seoul reporter uploads folder size </td><td> $seoulUploadsSize </td></tr>"

seoulAccessKey=eyJhbGciOiJIUzI1NiJ9.eyJ4cC51Ijo0NiwieHAucCI6MSwieHAubSI6MTYxODMyMTUzMjE0MSwiZXhwIjoxOTMzNjgxNTMyLCJpc3MiOiJjb20uZXhwZXJpdGVzdCJ9.c0tfNig-U-Xlj5yurF3_z9UXMAav-MU-6-8rXOXIQSM

seoulRegionArray=$(curl -s GET 'https://seoul.experitest.com/api/v2/regions' -H "Authorization: Bearer $seoulAccessKey" | jq -rj '.[]|"\(.name): \(.status): \(.version);"')
IFS=';' eval 'array=($seoulRegionArray)'
echo
echo "<tr><td> Seoul Region 1 </td><td> ${array[0]} </td></tr>"

seoulServicesArray=$(curl -s GET 'https://seoul.experitest.com/api/v2/region-services' -H "Authorization: Bearer $seoulAccessKey" | jq -rj '.[]|"\(.hostOrIp) \(.type): \(.status): \(.version);"')
IFS=';' eval 'array=($seoulServicesArray)'
echo "<tr><td> Seoul Service 1 </td><td> ${array[0]} </td></tr>"
echo "<tr><td> Seoul Service 2 </td><td> ${array[1]} </td></tr>"
echo "<tr><td> Seoul Service 3 </td><td> ${array[2]} </td></tr>"
echo "<tr><td> Seoul Service 3 </td><td> ${array[3]} </td></tr>"
echo "</table></body></html>";
echo "<p>       </p>"

echo "<html><body><table border=1>"
echo "<tr><td><span style='color:#1e90ff'>TOKYO cloud monitoring report </span> :</td><td> $dateval </td></tr>"
tokyo=$(/usr/local/bin/sshpass -p Ab123456 ssh -o StrictHostKeyChecking=no auto@192.168.6.201 'df -h | grep ubuntu')
IFS=' ' read -ra deviceSplit <<< "$tokyo"
tokyofs=${deviceSplit[3]}
echo "<tr><td> Tokyo free space </td><td> $tokyofs </td></tr>"

tokyoUploads=$(/usr/local/bin/sshpass -p Ab123456 ssh -o StrictHostKeyChecking=no auto@192.168.6.201 'du -sh /var/lib/Experitest/reporter/uploads')
IFS='/' read -ra deviceSplit <<< "$tokyoUploads"
tokyoUploadsSize=${deviceSplit[0]}
echo "<tr><td> Tokyo reporter uploads folder size </td><td> $tokyoUploadsSize </td></tr>"

tokyoAccessKey=eyJhbGciOiJIUzI1NiJ9.eyJ4cC51Ijo0NiwieHAucCI6MSwieHAubSI6MTYxODMyMTUzMjE0MSwiZXhwIjoxOTMzNjgxNTMyLCJpc3MiOiJjb20uZXhwZXJpdGVzdCJ9.c0tfNig-U-Xlj5yurF3_z9UXMAav-MU-6-8rXOXIQSM

tokyoAgentsArray=$(curl -s GET 'https://tokyo.experitest.com/api/v2/selenium-agents' -H "Authorization: Bearer $tokyoAccessKey" | jq -rj '.[]|"\(.name): \(.connected): \(.status):  \(.version);"')
IFS=';' eval 'array=($tokyoAgentsArray)'
echo "<tr><td> Tokyo Selenium Agent 1 </td><td> ${array[0]} </td></tr>"
echo "<tr><td> Tokyo Selenium Agent 2 </td><td> ${array[1]} </td></tr>"
echo "<tr><td> Tokyo Selenium Agent 3 </td><td> ${array[2]} </td></tr>"
echo "<tr><td> Tokyo Selenium Agent 4 </td><td> ${array[3]} </td></tr>"
echo "<tr><td> Tokyo Selenium Agent 5 </td><td> ${array[4]} </td></tr>"

tokyoRegionArray=$(curl -s GET 'https://tokyo.experitest.com/api/v2/regions' -H "Authorization: Bearer $tokyoAccessKey" | jq -rj '.[]|"\(.name): \(.status): \(.version);"')
IFS=';' eval 'array=($tokyoRegionArray)'
echo
echo "<tr><td> Tokyo Region 1 </td><td> ${array[0]} </td></tr>"

tokyoServicesArray=$(curl -s GET 'https://tokyo.experitest.com/api/v2/region-services' -H "Authorization: Bearer $tokyoAccessKey" | jq -rj '.[]|"\(.hostOrIp) \(.type): \(.status): \(.version);"')
IFS=';' eval 'array=($tokyoServicesArray)'
echo "<tr><td>Service 1 </td><td> ${array[0]} </td></tr>"
echo "<tr><td>Service 2 </td><td> ${array[1]} </td></tr>"
echo "<tr><td>Service 3 </td><td> ${array[2]} </td></tr>"
echo "</table></body></html>";
echo "<p>       </p>"
echo "<tr> <td> Passed </td> <td> Failed </td> </tr>"