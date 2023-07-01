/**
 * Stop system from going to screensaver by sending F24 keystroke every 40 seconds.
 * License: GNU GPLv3
 * Source: https://raymii.org
 * Author: Remy van Elst, 2019
 */
#define WINVER 0x0500
#include <windows.h>
int main()
{
    // Hide this console window
    ShowWindow(GetConsoleWindow(), SW_HIDE);
    // 40 seconds
    DWORD sleeptime = 40000;
    INPUT ip;
    while (true)
    {
        ip.type = INPUT_KEYBOARD;
        ip.ki.wScan = 0; // hardware scan code for key
        ip.ki.time = 0;
        ip.ki.dwExtraInfo = 0;
        // list of keycodes:
        // http://web.archive.org/web/20191221104344/https://docs.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes
        ip.ki.wVk = 0x87; // virtual-key code for the "F24" key
        ip.ki.dwFlags = 0; // 0 for key press
        SendInput(1, &ip, sizeof(INPUT));
        ip.ki.dwFlags = KEYEVENTF_KEYUP; // KEYEVENTF_KEYUP for key release
        SendInput(1, &ip, sizeof(INPUT));
        Sleep(sleeptime);
    }
    return 0;
}
