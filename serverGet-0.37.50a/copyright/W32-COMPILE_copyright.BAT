@echo off

set name_prog=copyright
set put_prog_rss2fido=d:\hpt\rss2fido\
set put_prog=%put_prog_rss2fido%%name_prog%\
set pr_str=%put_prog%assembly.inc

:next
cd /d %put_prog%
D:\PROG_ING\FPC\bin\i386-win32\fpc.exe -Og -Fu%put_prog_rss2fido%pro_unit\ %put_prog%%name_prog%.pas
if exist %put_prog%%name_prog%.o del %put_prog%%name_prog%.o

pause
%put_prog%%name_prog%.exe %pr_str%
pause
goto next


