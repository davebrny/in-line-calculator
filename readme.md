# in-line calculator

<a href="url"><img src="http://i.imgur.com/xlONmxY.gif"></a><br></br>



#### What's this?

An interface-less calculator for Windows that lets you do basic math without having to leave the line you're typing on.  
&nbsp;



#### Where can it be used?

Almost anywhere in windows where you can enter text. Any text editor, search box or command line... even the text edit box that you use to rename files.  
&nbsp;  



#### How do you use it?

Press the equals key to activate the calculator, type out an equation, then use one of the two end keys to calculate it

```
=5p5
```

The &nbsp; <kbd>**=**</kbd> &nbsp; key deletes the equation and pastes the answer:  

```
10
```
The &nbsp; <kbd>**#**</kbd> &nbsp; key keeps the equation and pastes the answer at the end:  

```
5+5 = 10
```

&nbsp;



#### What's that p for?

As well as the regular math symbols (**+ - * /**), letters can be used which makes it easier to type since you don't have to use the shift key.


| math key | key to use if you're ~~lazy~~ efficient |  
|:--------:|:--------------------------------|  
| <kbd>+</kbd> | <kbd>p</kbd> &nbsp; `(plus)`  &nbsp; <kbd>a</kbd> &nbsp; `(and)`  
| <kbd>-</kbd> | <kbd>m</kbd> &nbsp; `(minus)` &nbsp; <kbd>s</kbd> &nbsp; `(subtract)`  
| <kbd>*</kbd> | <kbd>t</kbd> &nbsp; `(times)` &nbsp; <kbd>b</kbd> &nbsp; `(by)`   &nbsp; <kbd>x</kbd> &nbsp; `(multiply)`  
| <kbd>/</kbd> | <kbd>d</kbd> &nbsp; `(divide)`    


Some examples:

```
7 p 11 m 2 = 16
7 + 11 - 2
```

```
(27 d 4) x 12 = 81
(27 / 4) * 12
```

&nbsp;




#### How does it work?

When you press the equals key, the calculator will turn on and start logging the following keys:  

- &nbsp; `0` - `9` &nbsp; (number row or number pad)  
- &nbsp; `+` `-` `*` `/`  
- &nbsp; `.` `,` `(` `)`  
- &nbsp; `a` `b` `d` `m` `p` `s` `t` `x`  
- &nbsp; `space`  `backspace`  


If a key is pressed that isn't in the above list then the calculator will turn off and anything that was typed will be cleared from memory.
For example, typing `=5pw5=` won't calculate anything since the `w` key would have turned the calculator off.


> *The tray icon can be used to check what state the calculator is in. If the calculator is on the icon will be a "plus" symbol, if it's off then it will be showing the default "equal" symbol.  
You can use the escape key at any time to reset or turn off the calculator*

&nbsp;
&nbsp;


---


## Other features



**Select an equation**  

Select an equation and use one of the following hotkeys:

<kbd>alt</kbd> + <kbd>=</kbd> &nbsp; Result only  
<kbd>alt</kbd> + <kbd>#</kbd> &nbsp; Equation & result  

*This feature uses the clipboard to get the equation text and paste it back again so if it's used on static text (like on this page) where the result can't be pasted, then it will be shown in a tooltip message instead.*  

&nbsp;



**Add numbers quickly**  

When selecting an equation, if there are no math symbols in the selected text, then every space between the numbers will be replaced with pluses.  
`100 200 300` will become `100+200+300`

&nbsp;



**Windows calculator**  

The keys &nbsp; <kbd>a</kbd> <kbd>b</kbd> <kbd>d</kbd> <kbd>p</kbd> <kbd>m</kbd> <kbd>s</kbd> <kbd>t</kbd> <kbd>x</kbd> &nbsp; are remapped to send the corresponding math symbols when Windows calculator is open.   
The &nbsp; <kbd>=</kbd> &nbsp; key is remapped to send &nbsp; <kbd>enter</kbd>

&nbsp;


## Options

*(Any time you make any changes to the `settings.ini` file you will need to select "Reload This Script" from the tray icon to update the script with the new settings)*   


**Custom trigger key**  

The key that triggers the calculator can be changed to something else beside the equals key.  
To have any of the number keys be the trigger that starts the calculator, leave `trigger_key` empty.

> Triggering with the number keys can sometimes calculate things that aren't equations. This can happen in situations where you're typing a date like "31-12-2017" and then happen to use one of the end keys right after.  One way of avoiding this is by remembering to press the `escape` key to turn off the calculator before pressing an end key. If you forget to do that then `ctrl + z` can always be used to undo the calculation.


**Enable/Disable**  

To disable both the number row and number pad keys and use the "select equation" feature only, set `enable_hotstrings` to `no`.
There are also options to disable either the number row or the number pad keys which is useful if you're using the number keys to trigger the calculator and want to have one set of keys that wont trigger anything.  


**Calculator timeout**  

The default time the calculator will stay on after typing an equation is 60 seconds. This is so the calculator doesn't stay on when you use one of the trigger keys but don't intend to use the calculator. Change `timeout` to `T120` for 120 seconds, `T30` for 30 seconds or leave it blank to disable the timeout altogether.


**Start with windows**  

To have the script start when windows boots up, select "Start With Windows" from the tray icon.

&nbsp;


## Credits

Laszlo, Oldman and many others from the AHK community.
