{$A+,B+,D+,E-,F-,G+,I+,L+,N+,O-,P+,Q-,R-,S+,T-,V+,X+,Y+}

unit Cases; { revision 12.09.1998 }

interface

function UpCase(const C:Char):Char;
function LowCase(const C:Char):Char;
function UpCCase(const C:Char):Char;
function LowCCase(const C:Char):Char;
function DosUpCase(const C:Char):Char;

function ToggleCase(C:Char):Char;
function ToggleCCase(C:Char):Char;

procedure UpCaseStr(var Str:String);
procedure UpCCaseStr(var Str:String);
procedure LowCaseStr(var Str:String);
procedure LowCCaseStr(var Str:String);
procedure DosUpCaseStr(var Str:String);

function UpCaseStrF(const St:String):String;
function UpCCaseStrF(const St:String):String;

procedure ToggleCaseStr(var Str:String);
procedure ToggleCCaseStr(var Str:String);

procedure SmartCaseStr(var Str:String;const Delim:String);
procedure SmartCCaseStr(var Str:String;const Delim:String);

implementation

function UpCase(const C:Char):Char;assembler;
asm
   mov  al,C
   cmp  al,61h
   jb   @Exit
   cmp  al,7Ah
   ja   @Exit
   sub  al,20h

@Exit:

end;

function LowCase(const C:Char):Char;assembler;
asm
   mov  al,C
   cmp  al,41h
   jb   @Exit
   cmp  al,5Ah
   ja   @Exit
   add  al,20h

@Exit:

end;

function UpCCase(const C:Char):Char;assembler;
asm
   mov  al,C
   cmp  al,61h
   jb   @Exit
   cmp  al,7Ah
   jna  @Up1

   cmp  al,0A0h
   jb   @Exit
   cmp  al,0AFh
   jna  @Up1

   cmp  al,0E0h
   jb   @Exit
   cmp  al,0EFh
   jna  @Up2
   jmp  @Exit

@Up1:
   sub  al,20h
   jmp  @Exit


@Up2:
   sub  al,50h

@Exit:

end;

function LowCCase(const C:Char):Char;assembler;
asm
   mov  al,C
   cmp  al,41h
   jb   @Exit
   cmp  al,5Ah
   jna  @Up1

   cmp  al,80h
   jb   @Exit
   cmp  al,8Fh
   jna  @Up1

   cmp  al,90h
   jb   @Exit
   cmp  al,9Fh
   jna  @Up2
   jmp  @Exit

@Up1:
   add  al,20h
   jmp  @Exit


@Up2:
   add  al,50h

@Exit:

end;

function DosUpCase(const C:Char):Char;assembler;
asm
   mov  dl,C
   mov  ax,6520h
   int  21h
   mov  al,dl
end;

function ToggleCase(C:Char):Char;
begin
     If Ord(C) in [$61..$7A] then C:=UpCase(C)
     else C:=LowCase(C);
     ToggleCase:=C
end;

function ToggleCCase(C:Char):Char;
begin
     If (Ord(C) in [$41..$5A]) or (Ord(C) in [$80..$9F]) then C:=LowCCase(C)
     else C:=UpCCase(C);
     ToggleCCase:=C
end;

procedure UpCaseStr(var Str:String);
var
   I:Byte;

begin
     For I:=1 to Length(Str) do Str[I]:=UpCase(Str[I])
end;

procedure LowCaseStr(var Str:String);
var
   I:Byte;

begin
     For I:=1 to Length(Str) do Str[I]:=LowCase(Str[I])
end;

procedure UpCCaseStr(var Str:String);
var
   I:Byte;

begin
     For I:=1 to Length(Str) do Str[I]:=UpCCase(Str[I])
end;

procedure LowCCaseStr(var Str:String);
var
   I:Byte;

begin
     For I:=1 to Length(Str) do Str[I]:=LowCCase(Str[I])
end;

procedure DosUpCaseStr(var Str:String);assembler;
asm
   push ds
   lds  dx,Str
   inc  dx
   mov  cl,byte ptr Str
   mov  ax,6521h
   int  21h
   pop  ds
end;

procedure ToggleCaseStr(var Str:String);
var
   I:Byte;

begin
     For I:=1 to Length(Str) do Str[I]:=ToggleCase(Str[I])
end;

procedure ToggleCCaseStr(var Str:String);
var
   I:Byte;

begin
     For I:=1 to Length(Str) do Str[I]:=ToggleCCase(Str[I])
end;

function UpCaseStrF(const St:String):String;
var
   I:Byte;

begin
     UpCaseStrF[0]:=Chr(Length(St));
     For I:=1 to Length(St) do UpCaseStrF[I]:=UpCase(St[I])
end;

function UpCCaseStrF(const St:String):String;
var
   I:Byte;

begin
     UpCCaseStrF[0]:=Chr(Length(St));
     For I:=1 to Length(St) do UpCCaseStrF[I]:=UpCCase(St[I])
end;

procedure SmartCaseStr(var Str:String;const Delim:String);
var
   I:Byte;

begin
     LowCaseStr(Str);
     For I:=1 to Length(Str) do If I=1 then Str[1]:=UpCase(Str[1])
     else If not (Pos(Str[I-1],Delim)=0) then Str[I]:=UpCase(Str[I])
end;

procedure SmartCCaseStr(var Str:String;const Delim:String);
var
   I:Byte;

begin
     LowCCaseStr(Str);
     For I:=1 to Length(Str) do If I=1 then Str[1]:=UpCCase(Str[1])
     else If not (Pos(Str[I-1],Delim)=0) then Str[I]:=UpCCase(Str[I])
end;

end.
