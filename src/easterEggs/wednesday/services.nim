import times
import ./constants

proc isItWednesday* (dateTime: DateTime): bool =
    return dateTime.weekday == WeekDay.dWed

proc printWednesdayGreeting*(): void =
    echo "\nthis is\n", wednesdayWordASCII
    echo "loading worklogs for my dudes..."
