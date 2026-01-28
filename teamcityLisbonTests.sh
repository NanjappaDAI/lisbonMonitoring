#!/bin/sh
baseURL=http://192.168.1.213:8090/app
accessKey=eyJ0eXAiOiAiVENWMiJ9.YzBPYjZ6RXRKUGVBXzkyQUZZMHdwTTdoWGZ3.MDZlZGFlNTEtNGU4ZC00YWMzLTkxOWItMzgxODRmMzRjNTE0
basicAuth=bmFuamFwcGEuc29tYWlhaDphdUdVQCkyMQ==
#buildDetails=$(curl -s GET 'http://192.168.1.213:8090/app/rest/buildTypes/id:Automation_AutomationCloudExecution_ContinuousTestingMaster/builds/count:1' -H "Authorization: Bearer $accessKey")

#buildDetails=$(curl -s GET 'http://192.168.1.213:8090/app/rest/buildTypes/id:Automation_AutomationCloudExecution_ContinuousTestingMaster/builds/id:1857360' -H "Authorization: Bearer $accessKey")
#buildDetails=$(curl -s GET 'http://192.168.1.213:8090/app/rest/buildTypes/id:Automation_AutomationCloudExecution_ContinuousTestingMaster/builds/id:1858671' -H "Authorization: Bearer $accessKey")
buildDetails=$(curl -s GET 'http://192.168.1.213:8090/app/rest/buildTypes/id:Automation_AutomationCloudExecution_ContinuousTestingMaster/builds/id:1854232' -H "Authorization: Bearer $accessKey")
#buildDetails=$(curl -s GET 'http://192.168.1.213:8090/app/rest/buildTypes/id:Automation_AutomationCloudExecution_ContinuousTestingMaster/builds/id:1855404' -H "Authorization: Bearer $accessKey")
#buildDetails=$(curl -s GET 'http://192.168.1.213:8090/app/rest/buildTypes/id:Automation_AutomationCloudExecution_ContinuousTestingMaster/builds/id:1857113' -H "Authorization: Bearer $accessKey")
#buildDetails=$(curl -s GET 'http://192.168.1.213:8090/app/rest/buildTypes/id:Automation_AutomationCloudExecution_ContinuousTestingMaster/builds/id:1857275' -H "Authorization: Bearer $accessKey")

#IFS='"' read -ra buildDetailsSplit <<<"$buildDetails"
#buildID=${buildDetailsSplit[7]}
#buildNumber=${buildDetailsSplit[11]}
#statusTextRaw=${buildDetailsSplit[24]}
#statusText=${statusTextRaw:13:51}

buildID=$(echo "$buildDetails" | xmllint --xpath 'string(/build/@id)' -)
buildNumber=$(echo "$buildDetails" | xmllint --xpath 'string(/build/@number)' -)
statusText=$(echo "$buildDetails" | xmllint --xpath 'string(/build/statusText)' -)

baseFolder="/Users/auto/lisbonmonitor/"
logfilename="$baseFolder$buildNumber.log"
finalReport="$baseFolder$buildNumber.txt"


curl -s -L -X GET 'http://192.168.1.213:8090/httpAuth/app/buildLog?buildId='$buildID'&indent=true' -H "Authorization: Basic $basicAuth=" >> $logfilename
echo $logfilename "Downloaded"
echo

failedTCArray=()
file=$logfilename

while IFS= read -r line; do
  if [[ $line == *"FAILED"* ]]; then
    failedLines=$line
    IFS='(' read -ra failedTestCaseSplit <<<"$failedLines"
    IFS='>' read -ra failedTestCase <<<"${failedTestCaseSplit[0]}"
    failedTestCaseFinal=${failedTestCase[@]: -2}
    test1=${failedTestCase[@]:0}
    #    echo "Test case OS " $test1
    failedTCFinal=${failedTestCaseFinal// /'.'}
    IFS=')' read -ra failedTCParamsSplit <<<"$failedLines"
    failedTCParse1=${failedTCParamsSplit[1]}
    failedTCParse2=${failedTCParse1//' FAILED'/}
    failedTCParse3=${failedTCParse2//'> '/}
    failedTCParse4=${failedTCParse3//','/}
    failedTCParse5=${failedTCParse4// /'_'}
    failedTCParse6=${failedTCParse5//'_['/}
    failedTCParams=${failedTCParse6//']'/}
    failedTestCaseName=$failedTCFinal$failedTCParams
    failedTCArray+=($failedTestCaseName)
    #      failCount=$((failCount + 1))
  fi

  if [[ $line == *"Cloud version"* ]]; then
    cloudVersionLine=$line
    IFS=' ' read -ra cloudVersionSplit <<<"$cloudVersionLine"
    cloudVersion=${cloudVersionSplit[@]: -1}
  fi
  if [[ $line == *"Triggered"* ]]; then
    buildDateLine=$line
    IFS=' ' read -ra buildDateLineSplit <<<"$buildDateLine"
    buildDate=${buildDateLineSplit[1]}
  fi
done <"$file"


reportedTest=""
while IFS= read -r line; do
  if [ ! -z "${prev}" ]; then
    line1="${prev}"
    line2="${line}"
  fi
  prev="${line}"

  if [[ $line == *"[Step 1/1] com.experitest.qa.cloud.suites"* ]]; then
    suiteNameLine="$line"
    IFS='.' read -ra suiteNameSplit <<<"$suiteNameLine"
    suiteNameParse="${suiteNameSplit[@]: -1}"
    suiteName=${suiteNameParse// /';'}
  fi

  if [[ $line == *"Test Output"* ]] && [[ $line == *"("* ]]; then
    testCaseLine=$line
    IFS='(' read -ra testCaseLineSplit <<<"$testCaseLine"
    IFS='.' read -ra testCaseSplit <<<"${testCaseLineSplit[0]}"
    IFS=')' read -ra testCaseParamsSplit <<<"${testCaseLineSplit[1]}"
    # shellcheck disable=SC2124
    testCaseParse1="${testCaseSplit[@]: -2}"
    testCaseFinal=${testCaseParse1// /'.'}

    testCaseParams="${testCaseParamsSplit[0]}"
    testcaseParamsParse=${testCaseParams// /'_'}
    testcaseParamsParse1=${testcaseParamsParse//','/}
    testcaseParamsFinal2=${testcaseParamsParse1//'['/}
    testcaseParamsFinal=${testcaseParamsFinal2//']'/}
    testCaseName="$testCaseFinal$testcaseParamsFinal"
  fi

  if [[ $line == *"After test Device"* ]]; then
    deviceDetailsLine=$line
    IFS='{' read -ra deviceDetailsSplit <<<"$deviceDetailsLine"
    deviceDetailsRaw=${deviceDetailsSplit[1]}
    IFS=',' read -ra deviceFinalSplit <<<"$deviceDetailsRaw"
    deviceUDID="${deviceFinalSplit[0]}"
    deviceModel="${deviceFinalSplit[1]}"
    deviceModelFinal=${deviceModel//' '/}
    deviceVersion="${deviceFinalSplit[2]}"
    # shellcheck disable=SC2027
    deviceDetails="${deviceUDID//"}"/};$deviceModelFinal;"${deviceVersion:0:5}" "
  fi

  if [[ $line2 == *"Test Output"* ]] && [[ $line1 != *"F:"* ]]; then
    #    printf "%0s %20s %20s %20s %20s %20s" "${buildDate};" "${cloudVersion};" "${testCaseName}_${suiteName:0:3};" "${deviceDetails};" "PASS;" "${suiteName}" >>''$buildNumber''.txt
        echo "${buildDate};""${cloudVersion};""${testCaseName}_${suiteName:0:1};""${deviceUDID//"}"/};""$deviceModelFinal;""${deviceVersion:0:5};""1;""${suiteName}" >> $finalReport
        deviceUDID='NA'
        deviceModelFinal='NA'
        deviceVersion='NA'
      fi

      if [[ $line2 == *"Test Output"* ]] && [[ $line1 == *"F:"* ]]; then
    #    printf "%0s %20s %20s %20s %20s %20s" "${buildDate};" "${cloudVersion};" "${testCaseName}_${suiteName:0:3};" "${deviceDetails};" "FAIL;" "${suiteName}" >>''$buildNumber''.txt
        echo "${buildDate};""${cloudVersion};""${testCaseName}_${suiteName:0:1};""${deviceUDID//"}"/};""$deviceModelFinal;""${deviceVersion:0:5};""0;""${suiteName}" >> $finalReport
        deviceUDID='NA'
        deviceModelFinal='NA'
        deviceVersion='NA'
      fi

done <"$file"

sed -E -i '' 's/\(\[[0-9]+\][[:space:]]*V([0-9]+)\)/_V\1/' $finalReport

echo "Cloud Version:" $cloudVersion $statusText
cat $finalReport
echo  "2026========== END OF REPORT =========="
