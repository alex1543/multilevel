set put_prog=D:\hpt\RSS2FIDO\pro_unit\

if exist %put_prog%*.ppu del %put_prog%*.ppu
if exist %put_prog%*.o del %put_prog%*.o

set put_prog=D:\hpt\RSS2FIDO\synapse\source\lib\

if exist %put_prog%*.ppu del %put_prog%*.ppu
if exist %put_prog%*.o del %put_prog%*.o

set put_prog=D:\hpt\RSS2FIDO\skmhl\sources\

if exist %put_prog%*.ppu del %put_prog%*.ppu
if exist %put_prog%*.o del %put_prog%*.o



set put_prog=D:\hpt\RSS2FIDO\out\?*
if exist %put_prog% del %put_prog%


