import os
import strutils

const JIRA_TIME_STR_REQ_FORMAT* = "yyyy-MM-dd'T'HH:mm:ss'.'fffZZZ"

let JIRA_HOST* = getEnv("JIRA_HOST")
if not JIRA_HOST.startsWith("https://"):
    quit("invalid JIRA_HOST value. Should start with 'https://'")

let JIRA_USERNAME* = getEnv("JIRA_USERNAME")
if not JIRA_USERNAME.contains("@"):
    quit("invalid JIRA_USERNAME. Should be the email")

let JIRA_TOKEN* = getEnv("JIRA_TOKEN")
if not JIRA_TOKEN.len > 0:
    quit("Missing JIRA_TOKEN")
