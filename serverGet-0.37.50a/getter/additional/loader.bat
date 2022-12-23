
set adress=%1
set out=%2
; Можно вместо master wget.exe указать wget.bat и тп.
d:\hpt\rss2fido\wget.exe %adress% --output-document=%out%
; Так же доступны все переменные из конфиг файла

