import json
import times
import math

import ./utils
import ./client


type ReportTimeEntry* = ref object
    description: string
    startTimeStr: string
    duration*: int  # - spent time in seconds

proc taskKey* (entry: ReportTimeEntry): string =
    result = utils.findTaskKey(entry.description)

proc taskComment* (entry: ReportTimeEntry): string =
    result = utils.findTaskComment(entry.description)

proc startTime* (entry: ReportTimeEntry): DateTime =
    result = times.parse(entry.startTimeStr, "yyyy-MM-dd'T'HH:mm:sszzz")

proc durationMinutes* (entry: ReportTimeEntry): int =
    result = int(round(entry.duration/60))

type ClockifyService = ref object
    client: ClockifyClient

proc newClockifyService*(): ClockifyService =
    let client = newClockifyClient()
    result = ClockifyService(client: client)

proc getReportTimeEntries*(clockifyService: ClockifyService, dateStart: DateTime, dateEnd: DateTime): seq[ReportTimeEntry] =
    let timeEntries = clockifyService.client.getDetailedTaskReports(dateStart, dateEnd)
    var rtes: seq[ReportTimeEntry] = @[]
    for te in timeEntries:
        let rte = ReportTimeEntry(description: te["description"].getStr(), startTimeStr: te["timeInterval"]["start"].getStr(), duration: te["timeInterval"]["duration"].getInt())
        rtes.add(rte)
    result = rtes


