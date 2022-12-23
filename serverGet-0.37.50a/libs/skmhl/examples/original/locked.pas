uses
     skMHL,
     skOpen,
     skCommon,
     skComnTV;

var
 Base: PMessageBase;
begin
 InstallMHLcommon;

 WriteLn;

 if OpenMessageBaseEx(Base, 'Sauto0013', OpenOrCreateMessageBase, 1) then
  begin
   CloseMessageBase(Base);

   writeln('ok');
  end
 else
  writeln(explainstatus(openstatus));
{
 repeat
  if OpenOrCreateMessageBase(Base, 'Sauto0013') then
   begin
    WriteLn('opened/created');

    WriteLn('press enter to close.');

    ReadLn;

    CloseMessageBase(Base);

    Break;
   end;

  if OpenStatus <> ombLocked then
   begin
    WriteLn('unexpected error: ', ExplainStatus(OpenStatus));

    Break;
   end;

  Write('.');

  Delay(1000);
 until False;
}
end.