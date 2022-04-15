task build, "build project":
  exec "nim c -d:ssl --out:./bin/syncTimeEntries ./src/index.nim"
