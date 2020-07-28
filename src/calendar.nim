import strformat, times

type
    Day* = 1..31

    WeekDay* = enum
        sun="Sunday", mon="Monday", tues="Tuesday", wed="Wednesday",
        thur="Thursday", fri="Friday", sat="Saturday"

    Month* = enum
        jan="January", feb="February", mar="March", apr="April",
        may="May", jun="June", jul="July", aug="August", sept="September",
        oct="October", nov="November", dec="December"

    Year* = int

    Date* = object
        day: Day
        month: Month
        year: Year

proc date*(m: int, d: int, y: int): Date =
    return Date(month: Month(m-1), day: Day(d), year: Year(y))

proc is_leapyear*(date: Date): bool =
    if date.year %% 4 == 0 and date.year %% 100 != 0:
        return true
    elif date.year %% 100 == 0 and date.year %% 400 == 0:
        return true
    else:
        return false

proc days_in_month*(date: Date): int =
    if date.month == feb:
        return 28 + int(date.is_leapyear)
    else:
        return 31 - ord(date.month) %% 7 %% 2

proc day_of_week*(date: Date): WeekDay =
    let
        t = [0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4]
        m = ord(date.month) + 1
        d = date.day
    var y = date.year

    if (m < 3) : 
        y = y - 1
    return WeekDay((y + int(y / 4) - int(y / 100) + int(y / 400) + t[m - 1] + d) %% 7)


proc `$`*(date: Date): string =
    # Escape code for bold text, bright white foreground
    # and red background.
    result = "\u001b[1m\u001b[37m\u001b[41m\u001b[4m" 
    # Center the month, day, and year in the header
    result &= fmt"""{$date.month & " " & $date.day & ", " & $date.year:^20}"""
    # Reset the text formatting to normal
    result &= & "\u001b[0m "
    # Print day names on the calenday
    result &= "\nSu Mo Tu We Th Fr Sa\n"
    var
        first_day = date
        i = 1
    # Get the day of the week of the first day of the month
    first_day.day = 1
    let first_weekday = first_day.day_of_week()

    for d in sun..sat:
        if d >= first_weekday:
            if i == date.day:
                result &= "\u001b[1m\u001b[7m" & fmt"{i:>2}" & "\u001b[0m "
            else:
                result &= fmt"{i:>2} "
            inc(i)
        else:
            result &= "   "
    result &= "\n"
    let sat = i
    while i <= date.days_in_month():
        if i == date.day:
            result &= "\u001b[1m\u001b[7m" & fmt"{i:>2}" & "\u001b[0m "
            inc(i)
        else:
            result &= fmt"{i:>2} "
            inc(i)
            if (i-sat) %% 7 == 0:
                result &= "\n"

when isMainModule:
    let
        current_time = now()
        m = int(current_time.month)
        d = int(current_time.monthday)
        y = int(current_time.year)

    echo date(m, d, y)