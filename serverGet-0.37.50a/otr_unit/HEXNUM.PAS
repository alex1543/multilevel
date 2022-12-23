unit HexNum; { revision 09.02.1999 }

interface

const
     HexChars:array [0..15] of Char='0123456789ABCDEF';
     HexError:Boolean=False;

{===========================================================================}

function Byte2Hex(const Num:Byte):String;
function Hex2Byte(const Hex:String):Byte;

function Word2Hex(const Num:Word):String;
function Hex2Word(const Hex:String):Word;

function Long2Hex(const Num:LongInt):String;
function Hex2Long(const Hex:String):LongInt;

{===========================================================================}

function Data2Hex(var Data;Size:Byte):String;
procedure Hex2Data(var Data;const St:String);

{===========================================================================}

function Byte2Bin(const Num:Byte):String;
function Bin2Byte(const St:String):Byte;

function Word2Bin(const Num:Word):String;
function Bin2Word(const St:String):Word;

function Long2Bin(const Num:LongInt):String;
function Bin2Long(const St:String):LongInt;

{===========================================================================}

function Byte2Oct(Num:Byte):String;
function Word2Oct(Num:Word):String;
function Long2Oct(Num:LongInt):String;

{===========================================================================}

function ReverseStr(const St:String):String;
function ChangeBase(var Num;Bits,Base:Byte;StripZero:Boolean):String;

{===========================================================================}

implementation

function Byte2Hex(const Num:Byte):String;
begin
     Byte2Hex[0]:=Chr(2);
     Byte2Hex[1]:=HexChars[Num shr 4];
     Byte2Hex[2]:=HexChars[Num and 15];
     HexError:=False
end;

function Hex2Byte(const Hex:String):Byte;
var
   Value:Byte;
   Code:Integer;

begin
     Val('$'+Hex,Value,Code);
     HexError:=not (Code=0);
     Hex2Byte:=Value
end;

function Word2Hex(const Num:Word):String;
begin
     Word2Hex:=Byte2Hex(Hi(Num))+Byte2Hex(Lo(Num));
     HexError:=False
end;

function Hex2Word(const Hex:String):Word;
var
   Value:Word;
   Code:Integer;

begin
     Val('$'+Hex,Value,Code);
     HexError:=not (Code=0);
     Hex2Word:=Value
end;

function Long2Hex(const Num:LongInt):String;
begin
     Long2Hex:=Word2Hex(Num shr 16)+Word2Hex(Num);
     HexError:=False
end;

function Hex2Long(const Hex:String):LongInt;
var
   Value:LongInt;
   Code:Integer;

begin
     Val('$'+Hex,Value,Code);
     HexError:=not (Code=0);
     Hex2Long:=Value
end;

function Data2Hex(var Data;Size:Byte):String;
var
   I:Byte;
   Ptr:^Byte;
   St:String;

begin
     St:='';
     Ptr:=@Data;
     If Size>127 then Size:=127;

     For I:=1 to Size do
         begin
              St:=St+Byte2Hex(Ptr^);
              Inc(Ptr)
         end;

     Data2Hex:=St
end;

procedure Hex2Data(var Data;const St:String);
var
   I:Byte;
   Ptr:^Byte;

begin
     Ptr:=@Data;
     For I:=1 to (Length(St) div 2) do
         begin
              Ptr^:=Hex2Byte(Copy(St,I*2-1,2));
              If HexError then Exit;
              Inc(Ptr)
         end
end;

function Byte2Bin(const Num:Byte):String;
var
   I,N:Byte;
   B:Boolean;

begin
     N:=1;
     Byte2Bin[0]:=#8;
     HexError:=False;

     For I:=7 downto 0 do
         begin
              B:=(Num and (1 shl Byte(I))=0);
              Byte2Bin[N]:=HexChars[Ord(not B)];
              Inc(N)
         end
end;

function Bin2Byte(const St:String):Byte;
var
   I,S,RC:Byte;

begin
     RC:=0;
     HexError:=True;

     For I:=1 to Length(St) do
         begin
              S:=Length(St)-I;
              If not (St[I] in ['0','1']) then Exit;
              If St[I]='1' then RC:=RC+(1 shl Byte(S))
         end;

     Bin2Byte:=RC;
     HexError:=False
end;

function Word2Bin(const Num:Word):String;
var
   I,N:Byte;
   B:Boolean;

begin
     N:=1;
     Word2Bin[0]:=#16;
     HexError:=False;

     For I:=15 downto 0 do
         begin
              B:=(Num and (1 shl Word(I))=0);
              Word2Bin[N]:=HexChars[Ord(not B)];
              Inc(N)
         end
end;

function Bin2Word(const St:String):Word;
var
   I,S:Byte;
   RC:Word;

begin
     RC:=0;
     HexError:=True;

     For I:=1 to Length(St) do
         begin
              S:=Length(St)-I;
              If not (St[I] in ['0','1']) then Exit;
              If St[I]='1' then RC:=RC+(1 shl Word(S))
         end;

     Bin2Word:=RC;
     HexError:=False
end;

function Long2Bin(const Num:LongInt):String;
var
   I,N:Byte;
   B:Boolean;

begin
     N:=1;
     Long2Bin[0]:=#32;
     HexError:=False;

     For I:=31 downto 0 do
         begin
              B:=(Num and (1 shl LongInt(I))=0);
              Long2Bin[N]:=HexChars[Ord(not B)];
              Inc(N)
         end
end;

function Bin2Long(const St:String):LongInt;
var
   I,S:Byte;
   RC:LongInt;

begin
     RC:=0;
     HexError:=True;

     For I:=1 to Length(St) do
         begin
              S:=Length(St)-I;
              If not (St[I] in ['0','1']) then Exit;
              If St[I]='1' then RC:=RC+(1 shl LongInt(S))
         end;

     Bin2Long:=RC;
     HexError:=False
end;

function Byte2Oct(Num:Byte):String;
var
   I:Byte;

begin
     Byte2Oct[0]:=#3;
     HexError:=False;

     For I:=0 to 2 do
         begin
              Byte2Oct[3-I]:=HexChars[Num and 7];
              Num:=Num shr 3
         end;
end;

function Word2Oct(Num:Word):String;
var
   I:Byte;

begin
     Word2Oct[0]:=#6;
     HexError:=False;

     For I:=0 to 5 do
         begin
              Word2Oct[6-I]:=HexChars[Num and 7];
              Num:=Num shr 3
         end
end;

function Long2Oct(Num:LongInt):String;
var
   I:Byte;

begin
     Long2Oct[0]:=#12;
     HexError:=False;

     For I:=0 to 11 do
         begin
              Long2Oct[12-I]:=HexChars[Num and 7];
              Num:=Num shr 3
         end
end;

function ReverseStr(const St:String):String;
var
   I:Byte;
   Temp:String;

begin
     Temp:='';
     For I:=Length(St) downto 1 do Temp:=Temp+St[I];
     ReverseStr:=Temp
end;

function ChangeBase(var Num;Bits,Base:Byte;StripZero:Boolean):String;
var
   Index:Byte;
   Digit:String;
   Dec:LongInt;

begin
     Dec:=0;
     Index:=0;
     Digit:='';

     Move(Num,Dec,Bits div 8);

     Repeat

     Inc(Index);
     Digit:=Digit+Chr(Dec mod Base + Ord('0'));
     If (Digit[Index]>'9') then Inc(Digit[Index],7);
     Dec:=Dec div Base

     Until ((Dec=0) and StripZero) or (Index=Bits);

     ChangeBase:=ReverseStr(Digit);
     HexError:=False
end;

end.
