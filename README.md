# CJ-timesync
CLI tool for moving the daily worklogs from Clockify to Jira

## Requirements for Clockify worklogs format
Format for Clockify task description:  
`[DEV-<jira task number>] <task comment>`  
Example:  
`[DEV-420] smoke testing`  

## Build and configuration
Build the binary from the source code:
```bash
nim build
```

Collect all the required values for environment variables:  
- **JIRA_HOST** - your company's Jira hostname. Example: _https://{yourcompanyname}.atlassian.net_  
- **JIRA_USERNAME** - your Jira account email
- **JIRA_TOKEN** - personal token for using Jira API. [Here](https://support.atlassian.com/atlassian-account/docs/manage-api-tokens-for-your-atlassian-account/) is the instruction how to use it
- **CLOCKIFY_API_KEY** - API key for you Clockify account
- **CLOCKIFY_WORKSPACE_ID** - ID of the workspace where the target Clockify project located
- **CLOCKIFY_TARGET_PROJECT_ID** - ID of the project for which you want to move time entries to Jira

Set these values as an anvironment variables    

## Usage
Run the command with target date as an argument:
```bash
./bin/syncTimeEntries 2022-04-03
```
if argument is not provided, the current day will be used by default
