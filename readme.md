# in-line calculator

<a href="url"><img src="http://i.imgur.com/xlONmxY.gif"></a><br></br>



#### What's this?

A calculator for Windows that lets you do basic math without having to leave the line you're typing on.  
&nbsp;  



#### Where can it be used?

Almost anywhere in windows where you can enter text. Any text editor, search box or command line... even the text edit box that you use to rename files.  
&nbsp;  



#### How does it work?

Type out an equation, then use one of the two end keys to calculate it

```
5p5
```

The &nbsp; <kbd>**=**</kbd> &nbsp; key deletes the equation and pastes the answer  

```
10
```
The &nbsp; <kbd>**#**</kbd> &nbsp; key keeps the equation and pastes the answer at the end  

```
5+5 = 10
```

&nbsp;



#### What's that p for?

Letters can be used instead of &nbsp; **+ - * /** &nbsp; which makes it easier to type since you don't have to use the shift key.


| math key | key to use if you're ~~lazy~~ efficient |  
|:--------:|:--------------------------------|  
| <kbd>+</kbd> | <kbd>p</kbd> &nbsp; `(plus)`  &nbsp; <kbd>a</kbd> &nbsp; `(and)`  
| <kbd>-</kbd> | <kbd>m</kbd> &nbsp; `(minus)` &nbsp; <kbd>s</kbd> &nbsp; `(subtract)`  
| <kbd>*</kbd> | <kbd>t</kbd> &nbsp; `(times)` &nbsp; <kbd>b</kbd> &nbsp; `(by)`   &nbsp; <kbd>x</kbd> &nbsp; `(multiply)`  
| <kbd>/</kbd> | <kbd>d</kbd> &nbsp; `(divide)`    


Some examples:

```
7 p (11 m 2) = 16
7 + (11 - 2)
```

```
(27 d 4) p (12 x 15) = 186.75
(27 / 4) + (12 * 15)
```


&nbsp;

---

&nbsp;

&nbsp;



## Other Features



**Select an equation**

Select an equation and use one of the following hotkeys:

<kbd>alt</kbd> + <kbd>=</kbd> &nbsp; Leaves the result only  
<kbd>alt</kbd> + <kbd>#</kbd> &nbsp; Equation & result  

*This feature uses the clipboard to get the equation text and paste it back again so if its used on static text (like on this page) then the result will be shown in a tooltip message instead.*  

&nbsp;



**Add numbers quickly**

When selecting an equation, if there are no math symbols in the selected text, then every space between the numbers will be replaced with pluses.  
`100 200 300` will become `100+200+300`

&nbsp;



**Windows calculator**

The keys &nbsp; <kbd>a</kbd> <kbd>b</kbd> <kbd>d</kbd> <kbd>p</kbd> <kbd>s</kbd> <kbd>t</kbd> <kbd>x</kbd> &nbsp; are remapped to send the corresponding math symbols when Windows calculator is open.   
The &nbsp; <kbd>=</kbd> &nbsp; key is remapped to send &nbsp; <kbd>enter</kbd>

&nbsp;


## Options

**Calculator Timeout**  

After you start typing an equation you have 60 seconds until the calculator turns off. To change this, set `timeout` in the **settings.ini** file to `T120` for 120 seconds, `T30` for 30 seconds or leave it blank to disable the timeout altogether.

**Enable/Disable**  

If you have a keyboard with a number pad and wont be using the number row keys then you can set `enable_number_row` to `no` to stop them from triggering the calculator.

To disable both the number row and number pad keys and use only the "select equation" feature then set `enable_hotstrings` to `no`.

> Any time you make changes to the settings you will need to select "Reload This Script" from the tray icon.


**Start With Windows**  

To have the script start when windows boots up, select "Start With Windows" from the tray icon.

&nbsp;

---

### Credits

Laszlo, Oldman and many others from the AHK community.
