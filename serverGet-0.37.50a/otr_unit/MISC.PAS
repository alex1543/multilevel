{$A+,B+,D+,E-,F-,G+,I-,L+,N+,O-,P-,Q-,R-,S-,T-,V-,X+,Y+}

unit Misc;

interface

function ChangeDir(Dir:String):Boolean;
function SilentExec(const Path,CmdLine:String):Word;
function DeleteROFile(const FileName:String):Boolean;
function GetParams(Params:String):String;
function GetDesc(Params:String):String;
function GetUnixDateTime:LongInt;

procedure SetHFileDate(const Handle:Word;Date:LongInt);
procedure CreateZeroFile(const FileName:String);
procedure Error(const Msg:String);

implementation

uses Dos,FileOp,Memory,HexNum,UnixDate;

function ChangeDir(Dir:String):Boolean;
begin
     DelBackSlash(Dir);
     ChDir(Dir);
     ChangeDir:=(IOResult=0)
end;

procedure NewInt10;interrupt;
begin
end;

function SilentExec(const Path,CmdLine:String):Word;
var
   RetVal:Word;
   Int10:Pointer;

begin
     GetIntVec($10,Int10);
     SetIntVec($10,@NewInt10);

     DoneDosMem;
     SwapVectors;
     Exec(Path,CmdLine);
     RetVal:=DosError;
     SwapVectors;
     InitDosMem;

     SetIntVec($10,Int10);
     SilentExec:=RetVal
end;

function DeleteROFile(const FileName:String):Boolean;
var
   F:File;

begin
     Assign(F,FileName);
     SetFAttr(F,Archive);
     Erase(F);
     DeleteROFile:=(IOResult=0)
end;

function GetParams(Params:String):String;
var
   Tmp:String;
   I:Byte;

begin
     GetParams:=Params;
     I:=Pos('"',Params);
     If I=0 then Exit;
     Delete(Params,1,I);
     Tmp:=ReverseStr(Params);
     I:=Length(Tmp)-Pos('"',Tmp)+1;
     If I>0 then GetParams:=Copy(Params,1,I-1)
end;

function GetDesc(Params:String):String;
var
   I:Byte;

begin
     GetDesc:='No description';
     I:=Pos('"',Params);
     If I=0 then Exit;
     Delete(Params,1,I);
     I:=Pos('"',Params);
     If I>0 then GetDesc:=Copy(Params,1,I-1)
     else GetDesc:=Params
end;

function GetUnixDateTime:LongInt;
var
   D:DateTime;
   Temp:Word;

begin
     GetDate(D.Year,D.Month,D.Day,Temp);
     GetTime(D.Hour,D.Min,D.Sec,Temp);
     GetUnixDateTime:=Dos2UnixDate(D)
end;

procedure SetHFileDate(const Handle:Word;Date:LongInt);assembler;
asm
     mov    bx,Handle
     mov    cx,word [Date]
     mov    dx,word [Date+2]
     mov    ax,5701h
     int    21h
     jc     @@1
     xor    ax,ax
@@1:
     mov    Dos.DosError,ax
end;

procedure CreateZeroFile(const FileName:String);
var
   F:File;

begin
     Assign(F,FileName);
     ReWrite(F);
     If IOResult=0 then Close(F)
end;

procedure Error(const Msg:String);
begin
     WriteLn('Error: ',Msg);
     Halt(1)
end;

end.
