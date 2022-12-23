{$G+,I-,Q-,R-,S+,T-,V-,X+}

unit RunTime;

interface

function GetErrorMessage(Number:Word):String;

implementation

uses HexNum,Dos;

var
   OldExitPtr:Pointer;

function GetErrorMessage(Number:Word):String;
begin
     Case Number of
       1:GetErrorMessage:='Invalid function number';
       2:GetErrorMessage:='File not found';
       3:GetErrorMessage:='Path not found';
       4:GetErrorMessage:='Too many open files';
       5:GetErrorMessage:='File access denied';
       6:GetErrorMessage:='Invalid file handle';
      12:GetErrorMessage:='Invalid file access code';
      15:GetErrorMessage:='Invalid drive number';
      16:GetErrorMessage:='Cannot remove current directory';
      17:GetErrorMessage:='Cannot rename across drives';
      18:GetErrorMessage:='No more files';
     100:GetErrorMessage:='Disk read error';
     101:GetErrorMessage:='Disk write error';
     102:GetErrorMessage:='File not assigned';
     103:GetErrorMessage:='File not open';
     104:GetErrorMessage:='File not open for input';
     105:GetErrorMessage:='File not open for output';
     106:GetErrorMessage:='Invalid numeric format';
     150:GetErrorMessage:='Disk is write-protected';
     151:GetErrorMessage:='Bad drive request struct length';
     152:GetErrorMessage:='Drive not ready';
     154:GetErrorMessage:='CRC error in data';
     156:GetErrorMessage:='Disk seek error';
     157:GetErrorMessage:='Unknown media type';
     158:GetErrorMessage:='Sector Not Found';
     159:GetErrorMessage:='Printer out of paper';
     160:GetErrorMessage:='Device write fault';
     161:GetErrorMessage:='Device read fault';
     162:GetErrorMessage:='Hardware failure';
     200:GetErrorMessage:='Division by zero';
     201:GetErrorMessage:='Range check error';
     202:GetErrorMessage:='Stack overflow error';
     203:GetErrorMessage:='Heap overflow error';
     204:GetErrorMessage:='Invalid pointer operation';
     205:GetErrorMessage:='Floating point overflow';
     206:GetErrorMessage:='Floating point underflow';
     207:GetErrorMessage:='Invalid floating point operation';
     208:GetErrorMessage:='Overlay manager not installed';
     209:GetErrorMessage:='Overlay file read error';
     210:GetErrorMessage:='Object not initialized';
     211:GetErrorMessage:='Call to abstract method';
     212:GetErrorMessage:='Stream registration error';
     213:GetErrorMessage:='Collection index out of range';
     214:GetErrorMessage:='Collection overflow error';
     215:GetErrorMessage:='Arithmetic overflow error';
     216:GetErrorMessage:='General Protection fault'
     else GetErrorMessage:='Unknown error'
     end
end;

function Word2Str(D:Word;Count:Byte):String;
var
   I:Byte;
   St:String;

begin
    Str(D:Count,St);
    For I:=1 to Length(St) do If St[I]=#32 then St[I]:='0';
    Word2Str:=St
end;

procedure WriteDateTime(var F:Text);
const
     WeekDay:array [0..6] of String[9]=('Sunday','Monday','Tuesday',
     'Wednesday','Thursday','Friday','Saturday');

var
   Year,Month,Day,DayOfWeek:Word;
   Hour,Minute,Second,Sec100:Word;

begin
     GetDate(Year,Month,Day,DayOfWeek);
     GetTime(Hour,Minute,Second,Sec100);
     Write(F,'** ',Word2Str(Day,2),'.',Word2Str(Month,2),'.');
     Write(F,Word2Str(Year,4),' (',WeekDay[DayOfWeek],') ');
     Write(F,'at ',Word2Str(Hour,2),':',Word2Str(Minute,2),':');
     WriteLn(F,Word2Str(Second,2),'.',Word2Str(Sec100,2))
end;

function WordLo(Long:LongInt):Word;assembler;
asm
   mov   ax,word ptr [Long]
end;

function WordHi(Long:LongInt):Word;assembler;
asm
   mov   ax,word ptr [Long+2]
end;

procedure Normalize(var Adr:LongInt);
begin
     Adr:=(LongInt(WordHi(Adr)) shl 4)+WordLo(Adr)
end;

procedure RunTimeExitProc;far;
var
   Adr:LongInt;
   Dir:DirStr;
   Name:NameStr;
   Ext:ExtStr;
   F:Text;

begin
     If Assigned(ErrorAddr) then
        begin
             FSplit(ParamStr(0),Dir,Name,Ext);

             Assign(F,Dir+Name+'.err');
             Append(F);
             If not (IOResult=0) then ReWrite(F);

             WriteLn;
             Adr:=LongInt(ErrorAddr);
             WriteDateTime(F);

             Write('Runtime error ',Word2Str(ExitCode,3));
             Write(F,'Runtime error ',Word2Str(ExitCode,3));

             WriteLn(' (',GetErrorMessage(ExitCode),')');
             WriteLn(F,' (',GetErrorMessage(ExitCode),')');

             WriteLn('In file: ',ParamStr(0));
             WriteLn(F,'In file: ',ParamStr(0));

             Write('Error address: ',Word2Hex(WordHi(Adr)));
             Write(F,'Error address: ',Word2Hex(WordHi(Adr)));

             Write(':',Word2Hex(WordLo(Adr)));
             Write(F,':',Word2Hex(WordLo(Adr)));

             Normalize(Adr);
             WriteLn(' (',Long2Hex(Adr),')');
             WriteLn(F,' (',Long2Hex(Adr),')');

             ErrorAddr:=nil;
             ExitCode:=1;
             WriteLn(F);
             Close(F)
        end;

     ExitProc:=OldExitPtr
end;

begin
     OldExitPtr:=ExitProc;
     ExitProc:=@RunTimeExitProc
end.
