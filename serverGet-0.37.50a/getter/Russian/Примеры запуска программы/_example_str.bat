
rem Можно задавать параметры из командной строки. Пример:
rss2fido.exe -na "RSS Лента" -ad "http://converseman.livejournal.com/data/rss" -po "additional\post.bat" -ou "additional\text.out" -te "template\lj.tpl" -la "russian.lng"

rem Можно задавать параметры:
rem -[параметр] [значение], --[параметр]=[значение]
rem -[два_первых_символа_параметра] [значение]
rem Указывайте параметры так, как Вам удобнее

rem На примере адреса ленты:
rem 
rem rss2fido.exe -ad http://news.yandex.ru/world.rss
rem rss2fido.exe -address http://news.yandex.ru/world.rss
rem rss2fido.exe -address=http://news.yandex.ru/world.rss
rem rss2fido.exe --address=http://news.yandex.ru/world.rss
rem 
rem Т.о. мы передаем значение адреса ленты программе
rem Список всех значений смотрите в configure files
rem 


