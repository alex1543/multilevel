@echo off

set name_prog=utf2dos
set put_prog_rss2fido=d:\hpt\rss2fido\
set put_prog=%put_prog_rss2fido%utf2dos\source\
set put_re_prog=%put_prog_rss2fido%utf2dos\
set put_upx=%put_prog_rss2fido%upx\upx.exe
set pr_str=%put_prog%converseman.rss

:next
cd /d %put_prog%
D:\PROG_ING\FPC\bin\i386-win32\fpc.exe -Og -Fu%put_prog_rss2fido%pro_unit\ %put_prog%%name_prog%.pas
if exist %put_prog%%name_prog%.o del %put_prog%%name_prog%.o
if exist %put_re_prog%%name_prog%.exe del %put_re_prog%%name_prog%.exe
%put_upx% -o %put_re_prog%%name_prog%.exe %put_prog%%name_prog%.exe
if exist %put_prog%%name_prog%.exe del %put_prog%%name_prog%.exe

pause
%put_re_prog%%name_prog%.exe %pr_str%
pause
goto next


