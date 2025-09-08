#!/bin/bash
baseURL=http://192.168.1.213:8090/app
accessKey=eyJ0eXAiOiAiVENWMiJ9.QksxMjlNWjFJLXhzY3JsUE5tMzROMGNuODk4.ZmQ2ZDkyNjYtMDUzYi00ZGFiLTg0ZTEtMjQyMDMzODE2ODEz
basicAuth=bmFuamFwcGEuc29tYWlhaDoxMjM0NTY

ContinuousTestingStatus=$(curl -s "http://192.168.1.213:8090/app/rest/buildTypes/id:Automation_AutomationCloudExecution_ContinuousTestingMaster/builds/count:1" -H "Authorization: Bearer $accessKey" | sed -n 's:.*<statusText>\(.*\)</statusText>.*:\1:p')
echo "CT Status Text: $ContinuousTestingStatus"

LocalAppiumStatus=$(curl -s "http://192.168.1.213:8090/app/rest/buildTypes/id:Automation_AutomationCloudExecution_ContinuousTestingLocalAppium/builds/count:1" -H "Authorization: Bearer $accessKey" | sed -n 's:.*<statusText>\(.*\)</statusText>.*:\1:p')
echo "Local Appium Status Text: $ContinuousTestingStatus"

LocalAppiumStatus=$(curl -s "http://192.168.1.213:8090/app/rest/buildTypes/id:Automation_AutomationSeleniumAgent_SeleniumIntegrationTest_RunTestsSeleniumIntegrationTestsMaster/builds/count:1" -H "Authorization: Bearer $accessKey" | sed -n 's:.*<statusText>\(.*\)</statusText>.*:\1:p')
echo "Selenium Integration Status Text: $ContinuousTestingStatus"