uses
     skMHL,
     skCommon,
     skComnTV,
     skOpen;

var
 B: PMessageBase;
 A: TAddress;
 D: TMessageBaseDateTime;
begin
 InstallMHLcommon;

 OpenOrCreateMessageBase(B, 's1');

 if B = nil then
  Halt(255);

 writeln;

 B^.Seek(0);

 while B^.SeekFound do
  begin
   if B^.OpenMessage then
    begin
     B^.GetWrittenDateTime(D);

     writeln(b^.current, ': ', d.day, ' ', d.month, ' ', d.year);

     B^.CloseMessage;
    end;

   B^.SeekNext;
  end;

 writeln('-- creating new message');

 writeln('cmn:', B^.CreateNewMessage);

 GetCurrentMessageBaseDateTime(D);

 D.Year:=2000;

 B^.SetWrittenDateTime(D);
 B^.SetArrivedDateTime(D);

 B^.SetFrom('skMHL Y2k test');
 B^.SetTo('All');

 StrToAddress('2:6033/27.2000@fidonet', A);

 B^.SetFromAddress(A, True);
 B^.SetToAddress(A);

 B^.SetTextPos(B^.GetTextSize);

 B^.PutString('just a test');

 writeln('wm:', B^.WriteMessage);

 writeln('cm:', B^.CloseMessage);

 CloseMessageBase(B);
end.