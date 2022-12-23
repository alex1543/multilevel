@echo off

set name_prog=rss2fido
set put_prog=d:\hpt\rss2fido\
set put_re_prog=d:\hpt\rss2fido\rss2fido\
rem set put_fpc=D:\PROG_ING\FPC\bin\i386-win32\
rem set par_os=-Tlinux
rem if %1==lnx set par_os=-Tlinux
rem if %1==lnx set put_fpc=D:\PROG_ING\FPC\bin\i386-win32\
rem if %1==win set par_os=-Twin32
rem if %1==win set put_fpc=D:\PROG_ING\FPC\bin\fpc_2.0.2_i386-win32\
set put_fpc=D:\PROG_ING\FPC\bin\fpc_2.0.2_i386-win32\
set put_upx=%put_fpc%upx.exe
rem set pr_str=http://news.yandex.ru/hardware.rss
rem set pr_str=http://filejunkie.livejournal.com/data/rss
rem set pr_str=http://users.livejournal.com/_muslimgauze_/data/rss debage
rem set pr_str=http://echo.920.spb.ru/area/su.chainik
rem set pr_str=http://freestudents.ru/rss.php
rem set pr_str=http://freestudents.ru/forum/rss.php
rem set pr_str=http://by_Rain.livejournal.com/data/1rss debage
rem set pr_str=http://converseman.livejournal.com/data/rss
rem set pr_str=-c D:\hpt\rss2fido\test.cfg
set pr_str=-c
rem set pr_str=http://primamedia.ru/search/search.php?&search=%C4%E0%EB%FC%F1%E2%FF%E7%FC&order=d
rem set pr_str=http://echo.920.spb.ru/area/opera.talk

:next
copy /y %put_re_prog%full.cfg %put_re_prog%config\russian\full.cfg
copy /y %put_re_prog%lj.tpl %put_re_prog%template\lj.tpl
copy /y %put_re_prog%Russian.lng %put_re_prog%language\Russian.lng

cd /d %put_prog%
%put_prog%copyright\copyright.exe %put_prog%copyright\assembly.inc 2
rem %put_prog%info\info.exe %put_prog%rss2fido\info.txt %put_prog%info\info.inc
rem %put_prog%info\info.exe %put_prog%rss2fido\help.txt %put_prog%info\help.inc
%put_fpc%fpc.exe %par_os% -FE%put_prog%out\ -Og -Fu%put_prog%skmhl\sources\ -Fu%put_prog%pkt\ -Fu%put_prog%uue\ -Fi%put_prog%ico\ -Fu%put_prog%unit\ -Fu%put_prog%pro_unit\ -Fi%put_prog%pro_unit\ -FuD:\PROG_ING\FPC\sysfpc\ -Fu%put_prog%synapse\source\lib\ -Fu%put_prog%pkt\RMSG\ -Fi%put_prog%inc\ -Fi%put_prog%copyright\ -Fi%put_prog%info\ %put_prog%%name_prog%.pas
if exist %put_prog%%name_prog%.o del %put_prog%%name_prog%.o
rem move %put_prog%%name_prog%.exe %put_re_prog%
if exist %put_re_prog%%name_prog%.exe del %put_re_prog%%name_prog%.exe
rem copy %put_prog%out\%name_prog%.exe %put_prog%%name_prog%.exe
if exist %put_prog%out\%name_prog%.exe move %put_prog%out\%name_prog%.exe %put_prog%%name_prog%.exe
if exist %put_prog%%name_prog%.exe %put_upx% -o %put_re_prog%%name_prog%.exe -f %put_prog%%name_prog%.exe
rem copy %put_re_prog%%name_prog%.exe %put_prog%%name_prog%.exe
if exist %put_prog%%name_prog%.exe del %put_prog%%name_prog%.exe
if exist %put_re_prog%%name_prog%.dtb del %put_re_prog%%name_prog%.dtb
if exist %put_re_prog%%name_prog%.log del %put_re_prog%%name_prog%.log
if exist %put_re_prog%lock.ok del %put_re_prog%lock.ok
cd /d %put_re_prog%
if exist %put_re_prog%%name_prog%.exe pause
if exist %put_re_prog%%name_prog%.exe %put_re_prog%%name_prog%.exe %pr_str%
pause
goto next


