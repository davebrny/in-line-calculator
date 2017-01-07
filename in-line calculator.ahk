/*
[script info]
version     = 1.6.3
description = calculate basic math without leaving the line you're typing on
author      = davebrny
source      = https://github.com/davebrny/in-line-calculator
*/

    ;# script settings
#noEnv
#singleInstance, force
sendMode input

    ;# read ini settings
iniRead, use_number_row,   % a_scriptDir "\settings.ini", settings, use_number_row
iniRead, use_number_pad,   % a_scriptDir "\settings.ini", settings, use_number_pad
iniRead, timeout, % a_scriptDir "\settings.ini", settings, timeout

    ;# tray menu stuff
script_icon := a_scriptDir "\in-line calculator.ico"
menu, tray, icon, % script_icon
start_with_windows(1)    ; add the option to start the script when windows boots

    ;# group calculator apps
groupAdd, calculator_apps, Calculator ahk_exe ApplicationFrameHost.exe  ; windows 10
groupAdd, calculator_apps, ahk_class CalcFrame                     ; windows classic
groupAdd, calculator_apps, ahk_exe numbers.exe                     ; windows 8 Metro

    ;# calculator hotstring keys
hotkey, ifWinNotActive, ahk_group calculator_apps
loop, 10
    {
    if (use_number_row = "yes")    ; set 0 to 9
        hotkey, % "~" . a_index - 1, inline_hotstring, on
    if (use_number_pad = "yes")    ; set 0 to 9 on numberpad
        hotkey, % "~numpad" . a_index - 1, inline_hotstring, on
    }
hotkey, ~- , inline_hotstring, on  ; other keys that can activate the calculator
hotkey, ~. , inline_hotstring, on
hotkey, ~( , inline_hotstring, on
hotkey, ifWinNotActive

    ;# keys that will end the calculator
end_keys =
(join
{c}{e}{f}{g}{h}{i}{j}{k}{l}{n}{o}{q}{r}{u}{v}{w}{y}{z}{[}{]}{;}{'}{``}{#}{=}{!}{"}
{$}{`%}{^}{&}{_}{{}{}}{:}{@}{~}{<}{>}{?}{\}{|}{up}{down}{left}{right}{esc}{enter}
{delete}{backspace}{tab}{LWin}{rWin}{LControl}{rControl}{LAlt}{rAlt}{printScreen}
{home}{end}{insert}{pgUp}{pgDn}{numlock}{scrollLock}{help}{appsKey}{pause}{sleep}
{ctrlBreak}{capsLock}{numpadEnter}{numpadUp}{numpadDown}{numpadLeft}{numpadRight}
{numpadAdd}{numpadSub}{numpadMult}{numpadDiv}{numpadClear}{numpadHome}{numpadEnd}
{numpadPgUp}{numpadPgDn}{numpadIns}{numpadDel}{browser_back}{browser_forward}
{browser_refresh}{browser_stop}{browser_search}{browser_favorites}{browser_home}
{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{F13}{F14}{F15}{F16}{F17}{F18}
{F19}{F20}{F21}{F22}{F23}{F24}
)

return  ; end of auto-execute --------------------------------------------------









inline_hotstring:
if (calculator_state != "active")
    {
    calculator("on")

    this_input := regExReplace(a_thisHotkey, "[^0-9.(-]")
    active_window := winExist("a")

    loop,
        {
        input, new_input, V %timeout%, %end_keys%
        this_input .= new_input  ; append
        this_endkey := strReplace(errorLevel, "EndKey:", "")
        if (this_endkey = "backspace")  ; trim 1 and continue with loop/input
            stringTrimRight, this_input, this_input, 1
        else break
        }

    if (winExist("a") != active_window)
        goTo, turn_calculator_off
    if (a_thisHotkey = "!=") or (a_thisHotkey = "!#")
        goTo, turn_calculator_off
    if (this_endkey != "=") and (this_endkey != "#")
        goTo, turn_calculator_off

    equation := convert_letters(this_input)
    if equation contains +,-,*,/
        goSub, calculate_equation

    calculator("off")
    }
return



!=::    ; in-line hotkeys
!#::
clipboard("save")
clipboard("clear")
send ^{c}
clipWait, 0.3
equation := convert_letters( trim(clipboard) )
clipboard("restore")

if (equation = "") or if regExMatch(equation, "[^0-9\Q+*-/(). \E]")
    return    ; only continue if numbers, +/-*.() or spaces

if equation not contains +,-,*,/         ; convert spaces to pluses
    stringReplace, equation, equation, % a_space, +, all

goSub, calculate_equation
return



calculate_equation:
result := eval(equation)    ; convert string to expression
if (result != "")
    {
    if inStr(result, ".")   ; trim 0's if decimal
        result := rTrim( rTrim(result, "0"), ".")

    if (this_endkey = "=") or (this_endkey = "#")
        send % "{backspace " strLen(equation) + 1 "}"  ; delete input

    if (this_endkey = "=") or (a_thisHotkey = "!=")
        sendRaw % result
    else
        {
        clipboard("save")
        clipboard := equation " = " result
        send, ^{v}
        sleep 50
        clipboard("restore")
        }
    }
return



;   █   █   █   █   █   █   █   █   █   █   █   █



turn_calculator_off:
calculator("off")
return


calculator(mode) {
    global
    if (mode = "on")
        {
        calculator_state := "active"
        menu, tray, icon, % script_icon, 2  ; plus icon
        }
    else
        {
        this_endkey =
        calculator_state := "idle"
        menu, tray, icon, % script_icon, 1  ; default icon
        }
}



convert_letters(string) {
    for letters, symbols in {"p":"+", "a":"+", "m":"-", "s":"-"
                           , "x":"*", "t":"*", "b":"*", "d":"/"}
        stringReplace, string, string, % letters, % symbols, all
    return string
}



clipboard(action="") {
    global
    if (action = "save")
        clipboard_r := clipboardAll
    else if (action = "restore")
        clipboard := clipboard_r
    else if (action = "clear")
        clipboard := ""
}



#ifWinActive, ahk_group calculator_apps

p::send, {+}    ; plus
a::send, {+}    ; and OR add
m::send, {-}    ; minus
s::send, {-}    ; subtract
x::send, {*}    ; multiply
t::send, {*}    ; times
b::send, {*}    ; by
d::send, {/}    ; divide

=::send, {enter}

#ifWinActive