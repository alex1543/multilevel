# makefile

FPCPath = /usr/lib/fpc/1.0.10/units/linux
LIB = ../lib
FPC = "fpc "

# Закомментируйте следующую строчку, если Вы хотите собрать skMHL
# без отладочной информации
FPC += "-gl -g"

all:
	@"$(FPC) skcommon.pas" && mv *.o *.ppu $(LIB)
	@"$(FPC) skmhl.pas" && mv *.o *.ppu $(LIB)
	@"$(FPC) skopen.pas" && mv *.o *.ppu $(LIB)

clean:
	@rm -f $(LIB)/*.ppu
	@rm -f $(LIB)/*.o	

install:
	echo "Installing units"
	@mkdir $(FPCPaths)/skmhl
	@cp $(LIB)/*.o $(FPCPath)/skmhl
	@cp $(LIB)/*.ppu $(FPCPath)/skmhl
	
help:
	@echo ""
	@echo "make without params - compile library"
	@echo "install - install library to here: $(FPCPath)"
	@echo "clean - deleting all *.o and *.ppu
	@echo "help - here help"
	@echo ""
