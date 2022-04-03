import strutils
import re

let taskRegex = re"\[\w+-\d+\]"

proc findTaskKey* (name: string): string =
  let matches = findAll(name, taskRegex)
  if matches.len > 0:
      result = matches[0][1 .. ^2]

proc findTaskComment* (name: string): string = 
  result = name.replace(taskRegex, "").strip()
