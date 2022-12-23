uses
{$IFDEF DELPHI}
     skComnD3,
{$ELSE}
     Drivers,

     skComnTV,
{$ENDIF}
     skCommon,
     skOpen,
     skMHL;

{$IFDEF DELPHI}
procedure PrintStr(const S: String);
 begin
  Write(S);
 end;
{$ENDIF}

var
 Base: PMessageBase;
 Command: String[1];
 UserNumber, Value: Integer;
begin
 InstallMHLcommon;

 PrintStr('skMHLlr, v1.0, (q) by sk // [rAN], 1999.'#13#10#13#10);

 if ParamCount < 3 then
  begin
   PrintStr('syntax: skMHLlr IDpath query usernumber'#13#10);
   PrintStr('        skMHLlr IDpath set usernumber value'#13#10);

   Halt(255);
  end;

 PrintStr(ParamStr(1) + #13#10);

 OpenOrCreateMessageBase(Base, ParamStr(1));

 if Base = nil then
  begin
   PrintStr('unable to open messagebase');

   Exit;
  end;

 Command:=ParamStr(2);

 Command[1]:=UpCase(Command[1]);

 StrToInteger(ParamStr(3), UserNumber);

 PrintStr('usernumber: ' + LongToStr(UserNumber) + #13#10);

 if UserNumber < 0 then
  PrintStr('invalid usernumber')
 else
  if Command = 'Q' then
   begin
    Value:=Base^.GetLastRead(UserNumber);

    PrintStr('lastread: ' + LongToStr(Value) + #13#10);
   end
  else
   if Command = 'S' then
    begin
     StrToInteger(ParamStr(4), Value);

     PrintStr('desired lastread: ' + LongToStr(Value) + #13#10);

     Base^.SetLastRead(UserNumber, Value);

     Value:=Base^.GetLastRead(UserNumber);

     PrintStr('lastread: ' + LongToStr(Value) + #13#10);
    end
   else
    PrintStr('wrong syntax!'#13#10);

 CloseMessageBase(Base);
end.