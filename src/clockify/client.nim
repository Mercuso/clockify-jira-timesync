import httpclient
import json
import strformat
import times
import sequtils
import ./constants

type ClockifyClient* = ref object
  apiClient: HttpClient

proc newClockifyClient*(): ClockifyClient =
  result = ClockifyClient()

  let client = newHttpClient()
  client.headers = newHttpHeaders({ "Content-Type": "application/json", "X-Api-Key": constants.CLOCKIFY_API_KEY })

  result.apiClient = client

proc getTasksReports* (clockifyClient: ClockifyClient, dateStart: DateTime, dateEnd: DateTime): seq[JsonNode] =
  let dateStartStr = dateStart.format(constants.CLOCKIFY_DATE_STR_FORMAT)
  let dateEndStr = dateEnd.format(constants.CLOCKIFY_DATE_STR_FORMAT)

  echo "start time:" & dateStartStr
  echo "end time:" & dateEndStr

  let body = %*{
      "dateRangeStart": dateStartStr,
      "dateRangeEnd": dateEndStr,
      "summaryFilter": {
      "groups": [
        "USER",
        "PROJECT",
        "TIMEENTRY"
      ]
    }
  }
  let response = clockifyClient.apiClient.request(
    fmt"{constants.CLOCKIFY_REPORTS_HOST}/workspaces/{constants.CLOCKIFY_WORKSPACE_ID}/reports/summary",
    httpMethod = HttpPost,
    body = $body # $ - to convert body to string
  )
  let clockifyReportsJSON = parseJson(response.body)
  let clockifyProjects = clockifyReportsJSON["groupOne"][0]["children"]
  let targetProject = filter(clockifyProjects.elems, proc(item: JsonNode): bool = item["_id"].getStr() == CLOCKIFY_TARGET_PROJECT_ID)[0]

  let clockifyReports = targetProject["children"]

  result = clockifyReports.elems

proc getDetailedTaskReports* (clockifyClient: ClockifyClient, dateStart: DateTime, dateEnd: DateTime): seq[JsonNode] =
    let dateStartStr = dateStart.format(constants.CLOCKIFY_DATE_STR_FORMAT)
    let dateEndStr = dateEnd.format(constants.CLOCKIFY_DATE_STR_FORMAT)
    let body = %*{
      "dateRangeStart": dateStartStr,
      "dateRangeEnd": dateEndStr,
      "detailedFilter": {},
      "projects": {
        "ids": [constants.CLOCKIFY_TARGET_PROJECT_ID]
      }
    }
    let response = clockifyClient.apiClient.request(
      fmt"{constants.CLOCKIFY_REPORTS_HOST}/workspaces/{constants.CLOCKIFY_WORKSPACE_ID}/reports/detailed",
      httpMethod = HttpPost,
      body = $body # $ - to convert body to string
    )
    echo response.body
    let clockifyReportsJSON = parseJson(response.body)
    let timeEntries = clockifyReportsJSON["timeentries"]
    result = timeEntries.elems
