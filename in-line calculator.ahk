/*
[script info]
version     = 1.5.2
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
iniRead, enable_backspace, % a_scriptDir "\settings.ini", settings, enable_backspace
iniRead, timeout, % a_scriptDir "\settings.ini", settings, timeout

    ;# tray menu stuff
script_icon := a_scriptDir "\in-line calculator.ico"
menu, tray, icon, % script_icon
start_with_windows(1)    ; add the option to start the script when windows boots

    ;# group calculator apps
groupAdd, calculator_apps, Calculator ahk_exe ApplicationFrameHost.exe  ; windows 10
groupAdd, calculator_apps, ahk_class CalcFrame                     ; windows classic
groupAdd, calculator_apps, ahk_exe numbers.exe                     ; windows 8 Metro

    ;# set calculator number keys
hotkey, ifWinNotActive, ahk_group calculator_apps
loop, 10
    {
    if (use_number_row = "yes")    ; set 0 to 9
        hotkey, % "~" . a_index - 1, inline_hotstring, on
    if (use_number_pad = "yes")    ; set 0 to 9 on numberpad
        hotkey, % "~numpad" . a_index - 1, inline_hotstring, on
    }
hotkey, ~- , inline_hotstring, on   ; other keys that can activate the calculator
hotkey, ~. , inline_hotstring, on
hotkey, ~( , inline_hotstring, on
hotkey, ifWinNotActive

    ;# keys that will deactivate the calculator
end_keys =
(join
{=}{#}{esc}{c}{e}{f}{g}{h}{i}{j}{k}{l}{n}{o}{q}{r}{u}{v}{w}{y}{z}{``}{!}{"}{$}
{`%}{^}{&}{*}{_}{[}{]}{{}{}}{;}{:}{'}{@}{~}{<}{>}{?}{F1}{F2}{F3}{F4}{F5}{F6}
{F7}{F8}{F9}{F10}{F11}{F12}{capslock}{tab}{enter}{scrollLock}{del}{insert}
{home}{end}{pgUp}{pgDn}{up}{down}{left}{right}{LWin}{rWin}{control}{LControl}
{rControl}{alt}{lAlt}{rAlt}{numlock}{appsKey}{printScreen}{ctrlBreak}{pause}
{help}{sleep}{numpadIns}{numpadEnd}{numpadDown}{numpadPgDn}{numpadLeft}
{numpadClear}{numpadRight}{numpadHome}{numpadUp}{numbpadPgUp}{numpadDel}
{numpadEnter}{browser_back}{browser_forward}{browser_refresh}{browser_stop}
{browser_search}{browser_favorites}{browser_home}{launch_mail}{launch_media}
{launch_app1}{launch_app2}
)
if (enable_backspace = "no")
    end_keys .= "{backspace}"    ; have backspace deactivate the calculator 

return  ; end of auto-execute --------------------------------------------------








inline_hotstring:
if (calculator_state != "active")
    {
    calculator("on")

    first_input   := regExReplace(a_thisHotkey, "[^0-9.(-]")
    active_window := winExist("a")

    input, equation, V %timeout%, %end_keys%
    this_hotstring := strReplace(errorLevel, "EndKey:", "")

    if (winExist("a") != active_window)
        goTo, turn_calculator_off
    if (a_thisHotkey = "!=") or (a_thisHotkey = "!#")
        goTo, turn_calculator_off
    if (this_hotstring != "=") and (this_hotstring != "#")
        goTo, turn_calculator_off 

    equation := convert_letters(first_input . equation)
    if equation contains +,-,*,/
        goSub, calculate_equation

    calculator("off")
    }
return



!=::
!#::
revert_clipboard := clipboardAll
clipboard =
send ^{c}
clipWait, 0.3
equation := convert_letters( trim(clipboard) )
clipboard := revert_clipboard

if (equation = "") or if regExMatch(equation, "[^0-9\Q+*-/(). \E]")
    return    ; only continue if numbers, spaces or +/-*.()

if equation not contains +,-,*,/         ; convert spaces to pluses
    stringReplace, equation, equation, % a_space, +, all

goSub, calculate_equation
return



calculate_equation:
result := eval(equation)     ; convert string to expression
if (result != "")
    {
    if inStr(result, ".")    ; trim 0's if decimal
        result := rTrim( rTrim(result, "0"), ".")

    if (this_hotstring = "=") or (this_hotstring = "#")
        send % "{backspace " strLen(equation) + 1 "}"  ; delete input

    if (this_hotstring = "#") or (a_thisHotkey = "!#")
         sendRaw % equation " = " result
    else sendRaw % result
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
        calculator_state := "idle"
        menu, tray, icon, % script_icon, 1  ; default icon
        }
    this_hotstring =  ; reset
}



convert_letters(equation) {
    for letters, symbols in {"p":"+", "a":"+", "m":"-", "s":"-"
                           , "x":"*", "t":"*", "b":"*", "d":"/"}
        stringReplace, equation, equation, % letters, % symbols, all
    return equation
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