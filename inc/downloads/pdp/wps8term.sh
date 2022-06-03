#!/bin/bash
# wps8term
# Based on vmsterm, from an original script by Bob Ess
# key translations by Erik Ahlefeldt
#
# Script file to run WPS-8 via SIMH pdp-8 
# emulator with correct remapping of a vt78
# by Remy van Elst, https://raymii.org
# Key translations recorded on a vt220
# in vt52 mode, running simh and showkeys
# license: GPLv3

# usage: wps8term.sh wps.ini

FG=black
BG=white
FONT=9x15
BFONT=9x15
COLS=80
 
xterm   -ti vt52 -title "wps8term" -sb -sl 1000 \
        -geo ${COLS}x24 -fg ${FG} -bg ${BG} \
        -cr blue -fn ${FONT} -fb ${BFONT} -xrm \
        'XTerm*VT100.translations: #override \n \
        ~Shift  <Key>F5:        string("Break") \n \
        ~Shift  <Key>F6:        string(0x1b)    string("?q") \n \
        ~Shift  <Key>F7:        string(0x1b)    string("?p") \n \
        ~Shift  <Key>F8:        string(0x1b)    string("[19~") \n \
        ~Shift  <Key>F9:        string(0x1b)    string("[20~") \n \
        ~Shift  <Key>F10:       string(0x1b)    string("[21~") \n \
        ~Shift  <Key>F11:       string(0x1b)    string("[23~") \n \
        ~Shift  <Key>F12:       string(0x1b)    string("[24~") \n \
        Shift   <Key>F1:        string(0x1b)    string("[23~") \n \
        Shift   <Key>F2:        string(0x1b)    string("[24~") \n \
        Shift   <Key>F3:        string(0x1b)    string("[25~") \n \
        Shift   <Key>F4:        string(0x1b)    string("[26~") \n \
        Shift   <Key>F5:        string(0x1b)    string("[28~") \n \
        Shift   <Key>F6:        string(0x1b)    string("[29~") \n \
        Shift   <Key>F7:        string(0x1b)    string("[31~") \n \
        Shift   <Key>F8:        string(0x1b)    string("[32~") \n \
        Shift   <Key>F9:        string(0x1b)    string("[33~") \n \
        Shift   <Key>F10:       string(0x1b)    string("[34~") \n \
        Shift   <Key>F11:       string(0x1b)    string("[28~") \n \
        Shift   <Key>F12:       string(0x1b)    string("[29~") \n \
                <Key>Delete:    string(0x7f)    \n \
                <Key>BackSpace: string(0x7f)    \n \
                <Key>Num_Lock:  string(0x1b)    string("?P") \n \
                <Key>KP_Divide: string(0x1b)    string("?Q") \n \
                <Key>KP_Multiply: string(0x1b)  string("?R") \n \
                <Key>KP_Subtract: string(0x1b)  string("?S") \n \
                <Key>KP_Add:    string(0x1b)    string("?l") \n \
                <Key>KP_Enter:  string(0x1b)    string("?M") \n \
                <Key>KP_Decimal: string(0x1b)   string("?n") \n \
                <Key>KP_0:      string(0x1b)    string("?p") \n \
                <Key>KP_1:      string(0x1b)    string("?q") \n \
                <Key>KP_2:      string(0x1b)    string("?r") \n \
                <Key>KP_3:      string(0x1b)    string("?s") \n \
                <Key>KP_4:      string(0x1b)    string("?t") \n \
                <Key>KP_5:      string(0x1b)    string("?u") \n \
                <Key>KP_6:      string(0x1b)    string("?v") \n \
                <Key>KP_7:      string(0x1b)    string("?w") \n \
                <Key>KP_8:      string(0x1b)    string("?x") \n \
                <Key>KP_9:      string(0x1b)    string("?y") \n \
        ~Shift  <Key>Up:        string(0x1b)    string("?r")\n \
        Shift   <Key>Up:        scroll-back(1,lines) \n \
        ~Shift  <Key>Down:      string(0x1b)    string("?r") \n \
        Shift   <Key>Down:      scroll-forw(1,lines) \n \
                <Key>Right:     string(0x1b)    string("?p") \n \
                <Key>Left:      string(0x1b)    string("?q")' \
        -e simh-pdp8 "$1"
        
