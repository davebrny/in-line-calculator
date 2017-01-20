/*
[script info]
version     = 1.6.8
description = calculate basic math without leaving the line you're typing on
author      = davebrny
source      = https://github.com/davebrny/in-line-calculator
*/

    ;# script settings
#noEnv
#singleInstance, force
sendMode input

    ;# ini settings
ini := a_scriptDir "\settings.ini"
iniRead, enable_hotstrings, % ini, settings, enable_hotstrings
iniRead, enable_number_row, % ini, settings, enable_number_row
iniRead, enable_number_pad, % ini, settings, enable_number_pad
iniRead, enable_hotkeys,    % ini, settings, enable_hotkeys
iniRead, timeout,           % ini, settings, timeout

    ;# tray menu stuff
if (a_isCompiled = 1)
    menu, tray, add, Reload This Script, reload
script_icon := a_scriptDir "\in-line calculator.ico"
menu, tray, icon, % script_icon
start_with_windows(1)    ; add the option to start the script when windows boots

    ;# group calculator apps
groupAdd, calculators, Calculator ahk_exe ApplicationFrameHost.exe  ; windows 10
groupAdd, calculators, ahk_class CalcFrame                     ; windows classic
groupAdd, calculators, ahk_exe numbers.exe                     ; windows 8 Metro

    ;# set hotstrings & hotkeys
hotkey, ifWinNotActive, ahk_group calculators
if (enable_hotstrings = "yes")
    {
    loop, 10
        {
        if (enable_number_row = "yes")    ; set 0 to 9
            hotkey, % "~" . a_index - 1, inline_hotstring, on
        if (enable_number_pad = "yes")    ; set 0 to 9 on numberpad
            hotkey, % "~numpad" . a_index - 1, inline_hotstring, on
        }
    hotkey, ~- , inline_hotstring, on  ; other keys that can activate the calculator
    hotkey, ~. , inline_hotstring, on
    hotkey, ~( , inline_hotstring, on
    }
if (enable_hotkeys = "yes")
    {
    hotkey, !=, inline_hotkey, on
    hotkey, !#, inline_hotkey, on
    }
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

return  ; end of auto-execute ---------------------------------------------------









inline_hotstring:
if (calculator_state != "active")
    {
    calculator("on")

    this_input := LTrim(a_thisHotkey, "~")
    active_window := winExist("a")

    loop,
        {
        input, new_input, V %timeout%, %end_keys%
        this_input .= new_input  ; append
        this_endkey := strReplace(errorLevel, "EndKey:", "")
        if (this_endkey = "backspace")    ; trim and continue with loop/input
            stringTrimRight, this_input, this_input, 1
        else break  ; if any other end key
        }

    if (this_endkey != "=") and (this_endkey != "#")
        goTo, turn_calculator_off
    if (winExist("a") != active_window)
        goTo, turn_calculator_off

    equation := convert_letters(this_input)    ; convert letters to math symbols
    if equation contains +,-,*,/
        goSub, calculate_equation

    calculator("off")
    }
return



inline_hotkey:
clipboard("save")
clipboard("get")
selected := clipboard
equation := convert_letters( trim(selected) )
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
    if inStr(result, ".")    ; trim trailing .000
        result := rTrim( rTrim(result, "0"), ".")

    if (a_thisHotkey = "!=") or (a_thisHotkey = "!#")
         send % "{backspace}"                           ; delete selected text
    else send % "{backspace " strLen(equation) + 1 "}"  ; delete hotstring input

    clipboard("save")
    if (this_endkey = "=") or (a_thisHotkey = "!=")
         clipboard := result
    else clipboard := equation " = " result
    clipboard("paste")

    if (a_thisHotkey = "!=") or (a_thisHotkey = "!#")
        {
        clipboard("get")
        if (clipboard = selected)  ; if clipboard wasnt pasted
            {
            toolTip, % result
            setTimer, msg_timer, 2500
            }
        }
    clipboard("restore")
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
        this_endkey =  ; clear
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
    else if (action = "get")
        {
        clipboard := ""
        send ^{c}
        clipWait, 0.3
        }
    else if (action = "paste")
        {
        send, ^{v}
        sleep 100
        }
    else if (action = "restore")
        clipboard := clipboard_r
}



msg_timer() {
    tool_id := winExist("ahk_class tooltips_class32")
    mouseGetPos, , , id_under   ; under cursor
    if (id_under != tool_id)
        {
        setTimer, msg_timer, off
        toolTip, 
        }
}



reload:
reload
sleep 1000
msgBox, 4, , The script could not be reloaded and will need to be manually restarted. Would you like Exit?
ifMsgBox, yes, exitApp
return



#ifWinActive, ahk_group calculators

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