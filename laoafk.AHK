; USER-DEFINED SETTINGS
;==SCREEN CENTER==
;   (LOST ARK MUST BE FULLSCREEN, ON THE FIRST MONITOR)
;   1280,720 IS FOR A 2560x1440 MONITOR
X = 1280
Y = 720
;==MAX PIXEL MOVEMENT FROM CENTER==
MAX_DISTANCE = 69
;==MIN-MAX CLICKS==
MIN_CLICKS = 1
MAX_CLICKS = 3
;==TIME BETWEEN ANTI-AFK CHECKS==
;   (1000 MS = 1 SECOND)
MIN_MS = 240000  ; 240000ms = 4 mins
MAX_MS = 840000 ; 1800000ms = 14 mins
;==MS BETWEEN PRESS DOWN AND RELEASE CLICK==
MIN_BETWEEN = 149
MAX_BETWEEN = 249
;==CONFIG FINISH. DO NOT ALTER REST OF FILE UNLESS YOU KNOW WHAT YOU'RE DOING==

;==============================================================================

; SCRIPT-REQUIRED SETTINGS
CoordMode, Mouse, Screen

; CREATE VARS
isEnabled := False
negMaxDistance := 0 - MAX_DISTANCE
totalRuns := 0

; SETUP GUI
gui, add, button, x5 y5 h75 w100 genablescript, Enable
gui, add, button, x110 y5 h75 w100 gdisablescript, Disable`n(F8)
gui, show, w215 h85, [OFF] LAOAFK
return

; FUNCTIONS
RemoveToolTip:
ToolTip
return

timestring(ms) ; https://www.autohotkey.com/board/topic/29053-how-to-convert-milliseconds-to-hourminutesecond/
{
    ms /= 1000
    secs := mod(ms, 60)
    ms //=60
    mins := mod(ms, 60)
    hours := ms //60
    return hours . ":" . mins . ":" . secs
}

; GUI FUNCTIONS
enablescript:
{
    if (!isEnabled)
    {
        isEnabled := True
        gui, show, , [ON] LAOAFK
        SoundBeep, 1000, 200
        While (isEnabled)
        {
            Random, antiafk, MIN_MS, MAX_MS
            currentMS := (a_hour*3600 + a_min*60 + a_sec)*1000 + a_msec
            nextMS := currentMS + antiafk
            nextMSString := timestring(nextMS)
            ToolTip, Next run at: %nextMSString%`nScript has run a total of %totalRuns% times.`nReminder: F8 will disable the script
            SetTimer, RemoveToolTip, -%antiafk%

            if (totalRuns > 0)
            {
                Random, clicksToDo, MIN_CLICKS, MAX_CLICKS
                Loop, %clicksToDo%
                {
                    Random, distanceX, negMaxDistance, MAX_DISTANCE
                    Random, distanceY, negMaxDistance, MAX_DISTANCE
                    MouseMove, X + distanceX, Y + distanceY
                    ControlClick, xX yY, ahk_exe LOSTARK.exe, , Left, 1, NA D
                    Random, between, MIN_BETWEEN, MAX_BETWEEN
                    Sleep, between
                    ControlClick, xX yY, ahk_exe LOSTARK.exe, , Left, 1, NA U
                    Sleep, between/3
                }
            }
            totalRuns += 1
            Sleep, antiafk
        }
    }
}
return

disablescript:
{
    if (isEnabled)
    {
        isEnabled := False
        gui, show, , [OFF] LAOAFK
        SoundBeep, 200, 200
        ToolTip
        totalRuns := 0
    }
}
return
F8::
    if (isEnabled)
    {
        isEnabled := False
        gui, show, , [OFF] LAOAFK
        SoundBeep, 200, 200
        ToolTip
        totalRuns := 0
    }
    return

; WHEN CLOSING APP
guiclose:
exit:
{
    exitapp
}
return
