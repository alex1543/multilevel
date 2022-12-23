

rem Этот пакетный файл должна запускать программа RSS2FIDO (сама)
rem Этот пакетный файл будет запускаться только в том случае, если
rem появились новое сообщение в ленте новостей RSS
rem Название исходящего файла: [текущая область]CP866_out.txt
rem Все остальные параметры на ваше усмотрение
D:\hpt\hpt post -nf "Ilya 'FileJunkie' Ershov" -nt "All" -af "2:5030/1538" -s "ЖЖ" -e "YET.ANOTHER.LOCAL" -f loc -x CP866_out.txt

rem feutil.exe POST D:\hpt\RSS2FIDO\CP866_~1.txt YET.ANOTHER.LOCAL -from "Ilya 'FileJunkie' Ershov" -to All -subj "RSS test"



rem Имя исходящего файла можно взять из переменной окружения
set out=%1
D:\hpt\hpt post -nf "Ilya 'FileJunkie' Ershov" -nt "All" -af "2:5030/1538" -s "ЖЖ" -e "YET.ANOTHER.LOCAL" -f loc -x %out%

rem Ждем-с...
pause

