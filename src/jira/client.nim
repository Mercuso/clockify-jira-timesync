import httpclient
import json
import strformat
import base64

import ./constatns


type JiraTask* = ref object
    id*: string
    key*: string
    summary*: string


type JiraClient* = ref object
    apiClient: HttpClient

proc newJiraClient*(): JiraClient =
    result = JiraClient()
    let client = newHttpClient()
    let authToken = encode(fmt"{JIRA_USERNAME}:{JIRA_TOKEN}")
    client.headers = newHttpHeaders({ "Content-Type": "application/json", "Authorization": fmt"Basic {authToken}"})

    result.apiClient = client

proc getTaskByKey*(jiraClient: JiraClient, key: string): JiraTask =
    let response = jiraClient.apiClient.getContent(fmt"{JIRA_HOST}/rest/api/3/issue/{key}")
    let responseJson = parseJson(response)
    let taskFields = responseJson["fields"]
    let task = JiraTask()
    task.id = responseJson["id"].getStr()
    task.summary = taskFields["summary"].getStr()
    task.key = key
    result = task

proc createWorkLog*(jiraClient: JiraClient, key: string, data: JsonNode): JsonNode =
    let response = jiraClient.apiClient.postContent(fmt"{JIRA_HOST}/rest/api/3/issue/{key}/worklog", $data)
    result = parseJson(response)
