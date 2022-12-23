uses
     Crt, skMHL, skMHLjam, skMHLmsg, skComnTV, skCommon;

var
 B: PMessageBase;
 Memory: Longint;
 S: String;
 Address: TAddress;
 K: Longint;
 DT: TMessageBaseDateTime;
begin
 Memory:=MemAvail;

 ClrScr;
 InstallMHLCommon;

 B:=New(PJamMessageBase, Init);
 if B^.Open('Jam\Jam') then
  begin
   WriteLn('Opened');
   B^.Seek(1);
   B^.OpenMessage;
   B^.CloseMessage;
   if B^.CreateNewMessage then
    begin
     WriteLn('Created.');
     B^.SetFrom('hren');
     B^.SetTo('pitch');
     B^.SetSubject('ahahahahamn');
     B^.WriteMessage;
     B^.CloseMessage;
     B^.KillMessage;
    end
   else
    WriteLn('Cannot create new message.');
  end
 else
  WriteLn('Cannot open - rc=#', B^.Status);

 Dispose(B, Done);

 WriteLn;
 WriteLn('Memory leak is ', Memory - MemAvail, ' bytes.');
end.