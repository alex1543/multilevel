
unit UnixDate;

interface

uses Dos;

function IsLeapYear(Year:Word):Boolean;
function Dos2UnixDate(D:DateTime):LongInt;
procedure Unix2DosDate(Date:LongInt;var D:DateTime);

implementation

const
     DaysPerMonth:array[1..12] of Byte=(031,028,031,030,031,030,031,031,030,031,030,031);
     DaysPerYear:array[1..12] of Word=(031,059,090,120,151,181,212,243,273,304,334,365);
     DaysPerLeapYear:array[1..12] of Word=(031,060,091,121,152,182,213,244,274,305,335,366);

const
     SecsPerYear:LongInt=31536000;
     SecsPerLeapYear:LongInt=31622400;
     SecsPerDay:LongInt=86400;
     SecsPerHour:Word=3600;
     SecsPerMinute:Byte=60;


function IsLeapYear(Year:Word):Boolean;
begin
     IsLeapYear:=((Year mod 4 = 0) and
     (Year mod 100 <> 0)) or (Year mod 400 = 0)
end;


function Dos2UnixDate(D:DateTime):LongInt;
var
   Temp:LongInt;
   Index:Word;

begin
     Temp:=D.Sec+(LongInt(SecsPerMinute)*D.Min);
     Temp:=Temp+(LongInt(SecsPerHour)*D.Hour);
     If D.Day>1 then Temp:=Temp+(LongInt(SecsPerDay)*(D.Day-1));
     If IsLeapYear(D.Year) then DaysPerMonth[02]:=29
     else DaysPerMonth[02]:=28;

     If D.Month>1 then
        begin
             For Index:=1 to (D.Month-1) do
             Temp:=Temp+(DaysPerMonth[Index]*LongInt(SecsPerDay))
        end;

     While D.Year>1970 do
           begin
                If IsLeapYear((D.Year-1)) then Temp:=Temp+SecsPerLeapYear
                else Temp:=Temp+SecsPerYear;
                Dec(D.Year)
           end;

     Dos2UnixDate:=Temp
end;

procedure Unix2DosDate(Date:LongInt;var D:DateTime);
var
   Done:Boolean;
   TotDays:Integer;
   X:Byte;

begin
     With D do
          begin
               Year:=1970;
               Month:=1;
               Day:=1;
               Hour:=0;
               Min:=0;
               Sec:=0
          end;

     Done:=False;
     While not Done do
           begin
                If Date>=SecsPerYear then
                   begin
                        Inc(D.Year);
                        Date:=Date-SecsPerYear
                   end
                else Done:=True;

                If (IsLeapYear(D.Year+1)) and (not Done)
                and (Date>=SecsPerLeapYear) then
                    begin
                         Inc(D.Year);
                         Date:=Date-SecsPerLeapYear
                    end
           end;

     Done:=False;
     TotDays:=Date div SecsPerDay;
     If IsLeapYear(D.Year) then
        begin
             X:=1;
             DaysPerMonth[02]:=29;

             Repeat
             If (TotDays<=DaysPerLeapYear[X]) then
                begin
                     D.Month:=X;
                     Done:=True;
                     Date:=Date-(TotDays*LongInt(SecsPerDay));
                     D.Day:=DaysPerMonth[D.Month]-(DaysPerLeapYear[D.Month]-TotDays)+1
                end
             else Done:=False;

             Inc(X);
             Until Done or (X>12)
        end
     else
         begin
              X:=1;
              DaysPerMonth[02]:=28;

              Repeat
              If (TotDays<=DaysPerYear[X]) then
                 begin
                      D.Month:=X;
                      Done:=True;
                      Date:=Date-(TotDays*LongInt(SecsPerDay));
                      D.Day:=DaysPerMonth[D.Month]-(DaysPerYear[D.Month]-TotDays)+1
                 end
              else Done:=False;

              Inc(X);
              Until Done or (X>12)
         end;

     D.Hour:=Date div SecsPerHour;
     Date:=Date mod SecsPerHour;
     D.Min:=Date div SecsPerMinute;
     Date:=Date mod SecsPerMinute;
     D.Sec:=Date
end;

end.
