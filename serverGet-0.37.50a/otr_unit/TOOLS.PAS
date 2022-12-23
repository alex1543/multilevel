{$A+,B+,D+,E-,F-,G+,I-,L+,N+,O-,P+,Q-,R-,S-,T-,V+,X+,Y+}

unit Tools; { revision 27.09.1998 }

{$DEFINE UseCases}

interface

const
     CrLf=#13#10;

type
    CharSet=set of Char;

{===========================================================================}

{$IFNDEF UseCases}

procedure UpCaseStr(var St:String);
{ Convert string to upper case }

function UpCaseStrF(const St:String):String;
{ Return uppercased string }

{$ENDIF}

{===========================================================================}

function Spaces(const Cnt:Byte):String;
{ Return string consist of Cnt spaces }

function ConstChar(const Ch:Char;const Cnt:Byte):String;
{ Return string consist of Cnt chars set in Ch }

function CutChars(St:String;const Chars:String):String;
{ Cut all chars found in string Chars from string St }

function CutCharSet(const St:String;Chars:CharSet):String;
{ Cut all chars found in set Chars from string St }

function GetCommandLine:String;
{ Get command line }

{===========================================================================}

procedure ReplaceStr(var St:String;const Old,New:String);
{ Replace substring Old in string St with substring New }

procedure ReplCaseStr(var St:String;const Old,New:String);
{ Like ReplaceStr, but case sensitive }

{===========================================================================}

procedure TrimStr(var St:String);
{ Remove trailing spaces & tabs from string }

procedure LTrimStr(var St:String);
{ Remove spaces & tabs from begin of string }

procedure RTrimStr(var St:String);
{ Remove spaces & tabs from end of string }

procedure KillRems(var St:String);
{ Remove remark (';') from string }

{===========================================================================}

function Justify(const St:String;Len:Byte):String;
{ Return a string right-padded to length Len with blanks }

function JustifyCh(const St:String;Ch:Char;Len:Byte):String;
{ Return a string right-padded to length Len with char Ch }

function JustifyLeft(const St:String;Len:Byte):String;
{ Return a string left-padded to length Len with blanks }

function JustifyLeftCh(const St:String;Ch:Char;Len:Byte):String;
{ Return a string left-padded to length Len with char Ch }

function Center(St:String;Width:Byte):String;
{ Return a string centered in a blank string of specified width }

function CenterCh(St:String;Ch:Char;Width:Byte):String;
{ Return a string centered in a string of Ch with specified width }

{===[ from Turbo Power's OpString ]=========================================}

function WordCount(St:String;WordDelims:CharSet):Byte;
{ Return number of words in string St }

function WordPosition(N:Byte;const St:String;WordDelims:CharSet):Byte;
{ Return start position of N'th word in string St }

function ExtractWord(N:Byte;const St:String;WordDelims:CharSet):String;
{ Return the N'th word in string St}

{===[ from Turbo Power's OpString ]=========================================}

function AsciiCount(St:String;WordDelims:CharSet;Quote:Char):Byte;
{ Return number of words in string St }

function AsciiPosition(N:Byte;St:String;WordDelims:CharSet;Quote:Char):Byte;
{ Return start position of N'th word in string St }

function ExtractAscii(N:Byte;St:String;WordDelims:CharSet;Quote:Char):String;
{ Return the N'th word in string St }

{===[ from Turbo Power's OpString ]=========================================}

procedure WordWrap(Inp:String;var Out,Over:String;Margin:Byte;PadToMargin:Boolean);
{ Wrap Inp at Margin, storing the result in Out and the remainder in Over }

{===========================================================================}

function Int2Str(const D:LongInt;const Count:Byte):String;
{ Convert integer to string & append zeroes to length Count }

function Int2Str2(const D:LongInt):String;
{ Convert integer to string }

{===========================================================================}

function Str2Byte(St:String;var I:Byte):Boolean;
{ Convert string to byte, returning true if successful }

function Str2Byte2(const St:String;var I:Byte):Boolean;
{ Convert string to byte, like Str2Byte but more simple }

function Str2Int(St:String;var I:Integer):Boolean;
{ Convert string to integer, returning true if successful }

function Str2Int2(const St:String;var I:Integer):Boolean;
{ Convert string to integer, like Str2Int but more simple }

function Str2Word(St:String;var I:Word):Boolean;
{ Convert string to word, returning true if successful }

function Str2Word2(const St:String;var I:Word):Boolean;
{ Convert string to word, like Str2Word but more simple }

function Str2Long(St:String;var I:LongInt):Boolean;
{ Convert string to longint, returning true if successful }

function Str2Long2(const St:String;var I:LongInt):Boolean;
{ Convert string to longint, like Str2Long but more simple }

{===========================================================================}

function IsAlpha(const Ch:Char):Boolean;
{ Ch is a letter ('A'..'Z' or 'a'..'z') }

function IsAscii(const Ch:Char):Boolean;
{ Ch is in the range 0 to 127 ($00..$7F) }

function IsCntrl(const Ch:Char):Boolean;
{ Ch is a delete character or ordinary control character ($7F or $00..$1F) }

function IsDigit(const Ch:Char):Boolean;
{ Ch is a digit ('0'..'9') }

function IsGraph(const Ch:Char):Boolean;
{ Ch is a printing character, excluding space ($21..$7E) }

function IsLower(const Ch:Char):Boolean;
{ Ch is a lowercase letter ('a'..'z') }

function IsPrint(const Ch:Char):Boolean;
{ Ch is a printing character ($20..$7E) }

function IsSpace(const Ch:Char):Boolean;
{ Ch is a space, tab, carriage return, etc ($09..$0D or $20) }

function IsPunct(const Ch:Char):Boolean;
{ Ch is a punctuation character (IsCntrl or IsSpace) }

function IsUpper(const Ch:Char):Boolean;
{ Ch is an uppercase letter ('A' to 'Z') }

function IsXDigit(const Ch:Char):Boolean;
{ Ch is a hexadecimal digit ('0'..'9', 'A'..'F' or 'a'..'f') }

{===========================================================================}

implementation

{$IFDEF UseCases}

uses Cases;

{$ELSE}

procedure UpCaseStr(var St:String);
var
   I:Byte;

begin
     For I:=1 to Length(St) do St[I]:=UpCase(St[I])
end;

function UpCaseStrF(const St:String):String;
var
   I:Byte;

begin
     UpCaseStrF[0]:=St[0];
     For I:=1 to Length(St) do UpCaseStrF[I]:=UpCase(St[I])
end;

{$ENDIF}

function Spaces(const Cnt:Byte):String;
var
   I:Byte;

begin
     Spaces[0]:=Chr(Cnt);
     For I:=1 to Cnt do Spaces[I]:=#32
end;

function ConstChar(const Ch:Char;const Cnt:Byte):String;
var
   I:Byte;

begin
     ConstChar[0]:=Chr(Cnt);
     For I:=1 to Cnt do ConstChar[I]:=Ch
end;

function CutChars(St:String;const Chars:String):String;
var
   I:Byte;

begin
     I:=1;
     Repeat
     If Pos(St[I],Chars)=0 then Inc(I)
     else Delete(St,I,1)
     Until I>Length(St);
     CutChars:=St
end;

function CutCharSet(const St:String;Chars:CharSet):String;
var
   I:Byte;
   Out:String;

begin
     Out:='';

     For I:=1 to Length(St) do
         begin
              If not (St[I] in Chars) then Out:=Out+St[I]
         end;

     CutCharSet:=Out
end;

{$IFDEF VER70}

function GetCommandLine:String;
begin
     GetCommandLine:=String(Ptr(PrefixSeg,$80)^)
end;

{$ELSE}

function GetCommandLine:String;
var
   I:Byte;
   Buf:String;

begin
     Buf:='';
     For I:=1 to ParamCount do Buf:=Buf+ParamStr(I)+#32;
     GetCommandLine:=Buf
end;

{$ENDIF}

procedure ReplCaseStr(var St:String;const Old,New:String);
var
   I,Cnt:Byte;

begin
     Cnt:=0;

     Repeat

     I:=Pos(Old,St);
     If I=0 then Break;
     Delete(St,I,Length(Old));
     Insert(New,St,I);
     Inc(Cnt)

     Until Cnt=255
end;

procedure ReplaceStr(var St:String;const Old,New:String);
var
   StTmp,OldTmp:String;
   I,Cnt:Byte;

begin
     Cnt:=0;
     StTmp:=UpCaseStrF(St);
     OldTmp:=UpCaseStrF(Old);

     Repeat

     I:=Pos(OldTmp,StTmp);
     If I=0 then Break;
     Delete(St,I,Length(Old));
     Delete(StTmp,I,Length(OldTmp));
     Insert(New,St,I);
     Insert(New,StTmp,I);
     Inc(Cnt)

     Until Cnt=255
end;

{$B-}
procedure TrimStr(var St:String);
var
   Len:Byte;

begin
     While (Length(St)>0) and ((St[1]=#32)
     or (St[1]=#9)) do Delete(St,1,1);

     Len:=Length(St);
     While (Len>0) and ((St[Len]=#32) or (St[Len]=#9)) do
           begin
                Delete(St,Len,1);
                Len:=Length(St)
           end
end;

procedure LTrimStr(var St:String);
begin
     While (Length(St)>0) and ((St[1]=#32)
     or (St[1]=#9)) do Delete(St,1,1)
end;

procedure RTrimStr(var St:String);
var
   Len:Byte;

begin
    Len:=Length(St);
    While (Len>0) and ((St[Len]=#32) or (St[Len]=#9)) do
          begin
               Delete(St,Len,1);
               Len:=Length(St)
          end
end;
{$B+}

procedure KillRems(var St:String);
var
   I:Byte;

begin
     I:=Pos(';',St);
     If not (I=0) then Delete(St,I,$FF)
end;

function Justify(const St:String;Len:Byte):String;
var
   I:Byte;

begin
     I:=Length(St);
     If not (I<Len) then Justify:=St
     else Justify:=St+Spaces(Len-I)
end;

function JustifyCh(const St:String;Ch:Char;Len:Byte):String;
var
   I:Byte;

begin
     I:=Length(St);
     If not (I<Len) then JustifyCh:=St
     else JustifyCh:=St+ConstChar(Ch,Len-I)
end;

function JustifyLeft(const St:String;Len:Byte):String;
var
   I:Byte;

begin
     I:=Length(St);
     If not (I<Len) then JustifyLeft:=St
     else JustifyLeft:=Spaces(Len-I)+St
end;

function JustifyLeftCh(const St:String;Ch:Char;Len:Byte):String;
var
   I:Byte;

begin
     I:=Length(St);
     If not (I<Len) then JustifyLeftCh:=St
     else JustifyLeftCh:=ConstChar(Ch,Len-I)+St
end;

function CenterCh(St:String;Ch:Char;Width:Byte):String;
var
   Tmp:String;
   StLen:Byte absolute St;

begin
     CenterCh:=St;
     If not ((StLen<Width) and (StLen<255)) then Exit;

     Tmp[0]:=Chr(Width);
     FillChar(Tmp[1],Width,Ch);
     Move(St[1],Tmp[Succ((Width-StLen) shr 1)],StLen);
     CenterCh:=Tmp
end;

function Center(St:String;Width:Byte):String;
begin
     Center:=CenterCh(St,#32,Width)
end;

function WordCount(St:String;WordDelims:CharSet):Byte;
var
   I,Count:Byte;
   StLen:Byte absolute St;

begin
     I:=1;
     Count:=0;

     While I<=StLen do
           begin
                While (I<=StLen) and (St[I] in WordDelims) do Inc(I);
                If I<=StLen then Inc(Count);
                While (I<=StLen) and (not (St[I] in WordDelims)) do Inc(I)
           end;

     WordCount:=Count;
end;

function WordPosition(N:Byte;const St:String;WordDelims:CharSet):Byte;
var
   I,Count:Byte;
   StLen:Byte absolute St;

begin
     I:=1;
     Count:=0;
     WordPosition:=0;

     While (I<=StLen) and (not (Count=N)) do
           begin
                While (I<=StLen) and (St[I] in WordDelims) do Inc(I);
                If I<=StLen then Inc(Count);

                If not (Count=N) then
                While (I<=StLen) and (not (St[I] in WordDelims)) do Inc(I)
                else WordPosition:=I
           end
end;

function ExtractWord(N:Byte;const St:String;WordDelims:CharSet):String;
var
   I,Len:Byte;
   StLen:Byte absolute St;

begin
     Len:=0;
     I:=WordPosition(N,St,WordDelims);

     If not (I=0) then
     While (I<=StLen) and (not (St[I] in WordDelims)) do
           begin
                Inc(Len);
                ExtractWord[Len]:=St[I];
                Inc(I)
           end;

     ExtractWord[0]:=Char(Len)
end;

function AsciiCount(St:String;WordDelims:CharSet;Quote:Char):Byte;
var
   I,Count:Byte;
   InQuote:Boolean;
   StLen:Byte absolute St;

begin
     I:=1;
     Count:=0;
     InQuote:=False;

     While I<=StLen do
           begin
                While (I<=StLen) and (not (St[I]=Quote))
                and (St[I] in WordDelims) do
                    begin
                         If I=1 then Inc(Count);
                         Inc(I)
                    end;

                If I<=StLen then Inc(Count);

                While (I<=StLen) and ((InQuote)
                or (not (St[I] in WordDelims))) do
                   begin
                        If St[I]=Quote then InQuote:=not InQuote;
                        Inc(I)
                   end
           end;

     AsciiCount:=Count
end;

function AsciiPosition(N:Byte;St:String;WordDelims:CharSet;Quote:Char):Byte;
var
   I,Count:Byte;
   InQuote:Boolean;
   StLen:Byte absolute St;

begin
     I:=1;
     Count:=0;
     InQuote:=False;
     AsciiPosition:=0;

     While (I<=StLen) and (not (Count=N)) do
           begin
                While (I<=StLen) and (not (St[I]=Quote))
                and (St[I] in WordDelims) do
                    begin
                         If I=1 then Inc(Count);
                         Inc(I)
                    end;

                If I<=StLen then Inc(Count);

                If not (Count=N) then
                While (I<=StLen) and ((InQuote)
                or (not (St[I] in WordDelims))) do
                   begin
                        If St[I]=Quote then InQuote:=not InQuote;
                        Inc(I)
                   end
                else AsciiPosition:=I
           end
end;

function ExtractAscii(N:Byte;St:String;WordDelims:CharSet;Quote:Char):String;
var
   I,Len:Byte;
   StLen:Byte absolute St;
   InQuote:Boolean;

begin
     Len:=0;
     InQuote:=False;
     I:=AsciiPosition(N,St,WordDelims,Quote);

     If not (I=0) then
     While (I<=StLen) and ((InQuote) or (not (St[I] in WordDelims))) do
           begin
                Inc(Len);
                If St[I]=Quote then InQuote:=not InQuote;
                ExtractAscii[Len]:=St[I];
                Inc(I)
           end;

     ExtractAscii[0]:=Chr(Len)
end;

procedure WordWrap(Inp:String;var Out,Over:String;Margin:Byte;PadToMargin:Boolean);
var
   InpLen:Byte absolute Inp;
   OutLen:Byte absolute Out;
   OvrLen:Byte absolute Over;
   EOS,BOS:Byte;

begin
     EOS:=InpLen;

     If InpLen>Margin then
        begin
             EOS:=Margin;
             While (EOS<=InpLen) and (not (Inp[EOS]=#32)) do Inc(EOS);
             If EOS>InpLen then EOS:=InpLen;

             While (Inp[EOS]=#32) and (EOS>0) do Dec(EOS);

             If EOS>Margin then
                begin
                     While (EOS>0) and (not (Inp[EOS]=#32)) do Dec(EOS);
                     If not (EOS=0) then
                     While (Inp[EOS]=#32) and (EOS>0) do Dec(EOS)
                     else EOS:=Margin
                end
        end;

     OutLen:=EOS;
     Move(Inp[1],Out[1],OutLen);

     BOS:=EOS+1;
     While (BOS<=InpLen) and (Inp[BOS]=#32) do Inc(BOS);

     If not (BOS>InpLen) then
        begin
             OvrLen:=Succ(InpLen-BOS);
             Move(Inp[BOS],Over[1],OvrLen)
        end
     else OvrLen:=0;

     If PadToMargin and (OutLen<Margin) then
        begin
             FillChar(Out[OutLen+1],Margin-OutLen,#32);
             OutLen:=Margin
        end
end;

function Int2Str(const D:LongInt;const Count:Byte):String;
var
   I:Byte;
   St:String;

begin
    Str(D:Count,St);
    For I:=1 to Length(St) do If St[I]=#32 then St[I]:='0';
    Int2Str:=St
end;

function Int2Str2(const D:LongInt):String;
var
   St:String;

begin
    Str(D,St);
    Int2Str2:=St
end;

function Str2Byte(St:String;var I:Byte):Boolean;
var
   Code:Word;
   StLen:Byte absolute St;

begin
     While St[StLen]=#32 do Dec(StLen);
     If (StLen>1) and (Upcase(St[StLen])='H') then
        begin
             Move(St[1],St[2],StLen-1);
             St[1]:='$'
        end
     else If (StLen>2) and (St[1]='0') and (UpCase(St[2])='X') then
          begin
               Dec(StLen);
               Move(St[3],St[2],StLen-1);
               St[1]:='$'
          end;

    Val(St,I,Code);
    If not (Code=0) then
       begin
            I:=Code;
            Str2Byte:=False
       end
    else Str2Byte:=True
end;

function Str2Byte2(const St:String;var I:Byte):Boolean;
var
   Code:Word;

begin
     Str2Byte2:=False;
     Val(St,I,Code);
     If Code=0 then Str2Byte2:=True
     else I:=Code
end;

function Str2Int(St:String;var I:Integer):Boolean;
var
   Code:Word;
   StLen:Byte absolute St;

begin
     While St[StLen]=#32 do Dec(StLen);
     If (StLen>1) and (UpCase(St[StLen])='H') then
        begin
             Move(St[1],St[2],StLen-1);
             St[1]:='$'
        end
     else If (StLen>2) and (St[1]='0') and (UpCase(St[2])='X') then
          begin
               Dec(StLen);
               Move(St[3],St[2],StLen-1);
               St[1]:='$'
          end;

     Val(St,I,Code);
     If not (Code=0) then
        begin
             I:=Code;
             Str2Int:=False
        end
     else Str2Int:=True
end;

function Str2Int2(const St:String;var I:Integer):Boolean;
var
   Code:Word;

begin
     Str2Int2:=False;
     Val(St,I,Code);
     If Code=0 then Str2Int2:=True
     else I:=Code
end;

function Str2Word(St:String;var I:Word):Boolean;
var
   Code:Word;
   StLen:Byte absolute St;

begin
     While St[StLen]=#32 do Dec(StLen);
     If (StLen>1) and (UpCase(St[StLen])='H') then
        begin
             Move(St[1],St[2],StLen-1);
             St[1]:='$'
        end
     else If (StLen>2) and (St[1]='0') and (UpCase(St[2])='X') then
          begin
               Dec(StLen);
               Move(St[3],St[2],StLen-1);
               St[1]:='$'
          end;

     Val(St,I,Code);
     If not (Code=0) then
        begin
             I:=Code;
             Str2Word:=False
        end
     else Str2Word:=True
end;

function Str2Word2(const St:String;var I:Word):Boolean;
var
   Code:Word;

begin
     Str2Word2:=False;
     Val(St,I,Code);
     If Code=0 then Str2Word2:=True
     else I:=Code
end;

function Str2Long(St:String;var I:LongInt):Boolean;
var
   Code:Word;
   StLen:Byte absolute St;

begin
     While St[StLen]=#32 do Dec(StLen);
     If (StLen>1) and (UpCase(St[StLen])='H') then
        begin
             Move(St[1],St[2],StLen-1);
             St[1]:='$'
        end
    else If (StLen>2) and (St[1]='0') and (UpCase(St[2])='X') then
         begin
              Dec(StLen);
              Move(St[3],St[2],StLen-1);
              St[1]:='$'
         end;

    Val(St,I,Code);
    If not (Code=0) then
       begin
            I:=Code;
            Str2Long:=False
       end
    else Str2Long:=True
end;

function Str2Long2(const St:String;var I:LongInt):Boolean;
var
   Code:Word;

begin
     Str2Long2:=False;
     Val(St,I,Code);
     If Code=0 then Str2Long2:=True
     else I:=Code
end;

function IsAlpha(const Ch:Char):Boolean;
begin
     IsAlpha:=(Ch in ['A'..'Z']) or (Ch in ['a'..'z'])
end;

function IsAscii(const Ch:Char):Boolean;
begin
     IsAscii:=(Ord(Ch) and $80)=0
end;

function IsCntrl(const Ch:Char):Boolean;
begin
     IsCntrl:=(Ord(Ch)=$7F) or (Ord(Ch) in [$00..$1F])
end;

function IsDigit(const Ch:Char):Boolean;
begin
     IsDigit:=Ch in ['0'..'9']
end;

function IsGraph(const Ch:Char):Boolean;
begin
     IsGraph:=Ord(Ch) in [$21..$7E]
end;

function IsLower(const Ch:Char):Boolean;
begin
     IsLower:=Ch in ['a'..'z']
end;

function IsPrint(const Ch:Char):Boolean;
begin
     IsPrint:=Ord(Ch) in [$20..$7E]
end;

function IsSpace(const Ch:Char):Boolean;
begin
     IsSpace:=(Ord(Ch) in [$09..$0D]) or (Ch=#$20)
end;

function IsPunct(const Ch:Char):Boolean;
begin
     IsPunct:=IsCntrl(Ch) or IsSpace(Ch)
end;

function IsUpper(const Ch:Char):Boolean;
begin
     IsUpper:=Ch in ['A'..'Z']
end;

function IsXDigit(const Ch:Char):Boolean;
begin
     IsXDigit:=(Ch in ['0'..'9']) or (Ch in ['A'..'F']) or (Ch in ['a'..'f'])
end;

end.
