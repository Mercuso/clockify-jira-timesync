import times
import os
import httpclient

import ./clockify/service as clockifyServiceModule
import ./jira/service as jiraServiceModule
import ./easterEggs/wednesday/services

try:
    let clocifyService = newClockifyService()
    let cmdParams = commandLineParams()
    var dateStart: DateTime
    if cmdParams.len > 0:
        dateStart = times.parse(cmdParams[0], "yyyy-MM-dd")
    else:
        let nowDT = now()
        dateStart = dateTime(nowDT.year, nowDT.month, nowDT.monthday)
    let dateEnd = dateStart + 1.days
    echo "sync time entries created from ", dateStart.format("yyyy-MM-dd'T'HH:mm:sszzz"), " to ", dateEnd.format("yyyy-MM-dd'T'HH:mm:sszzz")
    if isItWednesday(now()):
        printWednesdayGreeting()
    let rtes = clocifyService.getReportTimeEntries(dateStart, dateEnd)
    let jiraService = newJiraService()
    for rte in rtes:
        if rte.taskKey.len > 0:
            echo "save work log ", rte.description
            jiraService.createWorkLog(rte.taskKey, rte.durationMinutes, rte.startTime, rte.taskComment)
        else:
            echo "skipping time entry ", rte.description
    echo "Done"
except HttpRequestError:
    quit(getCurrentExceptionMsg())
