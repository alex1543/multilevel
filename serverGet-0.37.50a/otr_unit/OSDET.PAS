unit OsDet;

interface

type
    OpSysType=(tDOS,tW32,tOS2);

const
     CurrOs:OpSysType=tDOS;

type
    TTrueVerRec=record
    Major,Minor:Byte;
    Revision:Byte;
    Flags,AL:Byte
    end;

function Os2Installed:Boolean;
function GetWinVer:Word;

procedure GetTrueVer(var Ver:TTrueVerRec);
procedure DetectOsType;

implementation

uses Packers;

function Os2Installed:Boolean;assembler;
asm
   mov    ax,4010h
   int    2Fh
   cmp    ax,4010h
   je     @@1
   mov    al,01h
@@1:
   xor    al,al
@@2:
end;

function GetWinVer:Word;assembler;
asm
   mov   ax,160Ah
   int   2Fh
   or    ax,ax
   jnz   @@1
   mov   ax,bx
   jmp   @@2
@@1:
   xor  ax,ax
@@2:
end;

procedure GetTrueVer(var Ver:TTrueVerRec);assembler;
asm
   mov  ax,3306h
   int  21h
   xchg cx,bx
   push ds
   lds  bx,Ver
   mov  [bx+0],cl
   mov  [bx+1],ch
   mov  [bx+2],dl
   mov  [bx+3],dh
   mov  [bx+4],al
   pop  ds
end;

procedure DetectOsType;
var
   Ver:TTrueVerRec;
   WinVer:Word;

begin
     GetTrueVer(Ver);
     WinVer:=GetWinVer;

     If Os2Installed then { OS/2 }
        begin
             CurrOs:=tOS2;
             OsStr:='OS2';
             Exit
        end;

     If ((Ver.Major=5) and (Ver.Minor=50)) { NT 4.0 }
     or (Hi(WinVer)=4) then { Win95 }
        begin
             CurrOs:=tW32;
             OsStr:='W32';
             Exit
        end;

     CurrOs:=tDOS;
     OsStr:='DOS'
end;

end.
