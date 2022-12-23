{$A+,B+,D+,E-,F-,G+,I+,L+,N+,O-,P+,Q-,R-,S+,T-,V+,X+,Y+}

unit Dates; { revision 04.09.1998 }

{$DEFINE UseTools}

interface

{$IFDEF UseTools}

uses Dos,Tools;

{$ELSE}

uses Dos;

{$ENDIF}

const
     MonthName:array [1..12] of String[3]=('Jan','Feb',
     'Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');
     WeekDayName:array [0..6] of String[3]=('Sun','Mon',
     'Tue','Wed','Thu','Fri','Sat');

{$IFNDEF UseTools}

function Int2Str(const D:LongInt;const Count:Byte):String;
function Int2Str2(const D:LongInt):String;

{$ENDIF}

function DateTimeStr:String;
{ Return current date & time (for example: '16 Jul 05:41:50') }
function Dt2DateStr(Date:DateTime):String;
{ Return date & time stored in Date (for example: 'Jul 16 05:41:50 1997' }
function PathDateStr:String;
{ Return current date & time (for example: 'Wed Jul 16 05:41:50 1997') }

function DateStr:String;
{ Return current date (for example: 'Wed 30 Aug 1997') }
function TimeStr:String;
{ Return current time (for example: '07:10:31') }

function GetDateTime:LongInt;
{ Return packed date & time }

implementation

{$IFNDEF UseTools}

function Int2Str(const D:LongInt;const Count:Byte):String;
var
   I:Byte;
   St:String;

begin
    Str(D:Count,St);
    For I:=1 to Length(St) do If St[I]=' ' then St[I]:='0';
    Int2Str:=St
end;

function Int2Str2(const D:LongInt):String;
var
   St:String;

begin
    Str(D,St);
    Int2Str2:=St
end;

{$ENDIF}

function DateTimeStr:String; { 16 Jul 05:41:50 }
var
   Y,M,D,W:Word;
   H,M1,S,S1:Word;

begin
     GetDate(Y,M,D,W);
     GetTime(H,M1,S,S1);
     DateTimeStr:=Int2Str(D,2)+' '+
     MonthName[M]+' '+Int2Str(H,2)+':'+
     Int2Str(M1,2)+':'+Int2Str(S,2)
end;

function Dt2DateStr(Date:DateTime):String; { Jul 16 05:41:50 1997 }
begin
     DT2DateStr:=MonthName[Date.Month]+' '+
     Int2Str(Date.Day,2)+' '+Int2Str(Date.Hour,2)+':'+
     Int2Str(Date.Min,2)+':'+Int2Str(Date.Sec,2)+' '+Int2Str(Date.Year,4)
end;

function PathDateStr:String; { Wed Jul 16 05:41:50 1997 }
var
   Year,Month,Day,WeekDay:Word;
   Hour,Min,Sec,Sec100:Word;

begin
     GetTime(Hour,Min,Sec,Sec100);
     GetDate(Year,Month,Day,WeekDay);
     PathDateStr:=WeekDayName[WeekDay]+' '+MonthName[Month]+' '+
     Int2Str(Day,2)+' '+Int2Str(Hour,2)+':'+Int2Str(Min,2)+':'+
     Int2Str(Sec,2)+' '+Int2Str(Year,4)
end;

function DateStr:String; { Wed 30 Aug 1997 }
var
   Y,M,D,W:Word;

begin
     GetDate(Y,M,D,W);
     DateStr:=WeekDayName[W]+' '+Int2Str(D,2)+' '+
     MonthName[M]+' '+Int2Str(Y,4)
end;

function TimeStr:String; { 07:10:31 }
var
   H,M1,S,S1:Word;

begin
     GetTime(H,M1,S,S1);
     TimeStr:=Int2Str(H,2)+':'+
     Int2Str(M1,2)+':'+Int2Str(S,2)
end;

function GetDateTime:LongInt;
var
   D:DateTime;
   Result:LongInt;
   Temp:Word;

begin
     GetDate(D.Year,D.Month,D.Day,Temp);
     GetTime(D.Hour,D.Min,D.Sec,Temp);
     PackTime(D,Result);
     GetDateTime:=Result
end;

end.
