import times
import os
import httpclient

import ./clockify/service as clockifyServiceModule
import ./jira/service as jiraServiceModule

try:
    let clocifyService = newClockifyService()
    let cmdParams = commandLineParams()
    let dateStart = times.parse(cmdParams[0], "yyyy-MM-dd")
    let dateEnd = dateStart + 1.days
    echo "sync time entries created from ", dateStart.format("yyyy-MM-dd'T'HH:mm:sszzz"), " to ", dateEnd.format("yyyy-MM-dd'T'HH:mm:sszzz")

    let rtes = clocifyService.getReportTimeEntries(dateStart, dateEnd)
    let jiraService = newJiraService()
    for rte in rtes:
        if rte.taskKey.len > 0:
            echo "save work log for task ", rte.taskKey
            jiraService.createWorkLog(rte.taskKey, rte.durationMinutes, rte.startTime, rte.taskComment)
    echo "Done"
except HttpRequestError:
    quit(getCurrentExceptionMsg())
