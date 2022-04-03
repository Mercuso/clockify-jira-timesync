import os

const CLOCKIFY_REPORTS_HOST = "https://reports.api.clockify.me"
const CLOCKIFY_DATE_STR_FORMAT = "yyyy-MM-dd'T'HH:mm:ss'.'fff'Z'"

let CLOCKIFY_API_KEY = getEnv("CLOCKIFY_API_KEY")
let CLOCKIFY_WORKSPACE_ID = getEnv("CLOCKIFY_WORKSPACE_ID")
let CLOCKIFY_TARGET_PROJECT_ID = getEnv("CLOCKIFY_TARGET_PROJECT_ID")

export CLOCKIFY_API_KEY
export CLOCKIFY_DATE_STR_FORMAT
export CLOCKIFY_TARGET_PROJECT_ID
export CLOCKIFY_REPORTS_HOST
export CLOCKIFY_WORKSPACE_ID
