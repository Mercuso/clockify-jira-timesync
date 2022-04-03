import json
import times
import strformat

import ./constatns
import ./client

type JiraService = ref object
    client: JiraClient

proc newJiraService*(): JiraService = 
    let jiraClient = newJiraClient()
    result = JiraService(client: jiraClient)

proc createWorkLog* (jiraService: JiraService, taskKey: string, durationMinutes: int, startTime: DateTime, comment: string): void =
    let reqBody = %*{
        "timeSpent": fmt"{$durationMinutes}m",
        "started": startTime.format(JIRA_TIME_STR_REQ_FORMAT),
        "comment": {
        "version": 1,
        "type": "doc",
          "content": [
            {
              "type": "paragraph",
              "content": [
              {
                  "type": "text",
                  "text": comment
                }
              ]
            }
          ]
        }
      }
    discard jiraService.client.createWorkLog(taskKey, reqBody)