uses
     skMHL, skMHLmsg, skMHLjam, skComnTV, skCommon;

const
 MessageBasePath = 'E:\Engine\skMHL\areas\test';

var
 B: PMessageBase;
 M: Longint;
 F: Text;
 A: TAddress;
 T: TMessageBaseDateTime;
 S: String;
begin
 if ParamCount = 0 then
  begin
   WriteLn('Usage: TEST filename');
   Halt;
  end;

 {$I-}
 Assign(F, ParamStr(1));
 Reset(F);
 if IOResult <> 0 then
  begin
   WriteLn('MySelf.Suicide();');
   Halt;
  end;

 M:=MemAvail;
 InstallMHLCommon;

 B:=New(PJamMessageBase, Init);
 B^.SetFlag(afEchomail, True);

 if not B^.Open(MessageBasePath) then
  if not B^.Create(MessageBasePath) then
   begin
    WriteLn('Cannot create messagebase - code ', B^.Status, '.');
    WriteLn('Maybe curved hands? ;-)');
    Halt;
   end
  else
   WriteLn('Messagebase created')
 else
  WriteLn('Messagebase opened.');

 if B^.CreateNewMessage then
  begin
   A.Zone:=345;
   A.Net:=8189;
   A.Node:=1;
   A.Point:=69;
   B^.SetFromAddress(A, True);

   A.Point:=0;
   B^.SetToAddress(A);

   B^.SetFrom('iREN');
   B^.SetTo('Sergey Korowkin');
   B^.SetSubject('sk''s message handling library test');

   GetCurrentMessageBaseDateTime(T);
   B^.SetWrittenDateTime(T);
   B^.SetArrivedDateTime(T);

   B^.SetAttribute(maSent, False);
   B^.SetAttribute(maPrivate, True);
   B^.SetAttribute(maRRq, True);
   B^.SetAttribute(maLocal, True);

   while not Eof(F) do
    begin
     ReadLn(F, S);
     B^.PutString(S);
    end;

   if not B^.WriteMessage then
    WriteLn('Cannot write message. Wadda fuck?!');

   B^.CloseMessage;
  end
 else
  WriteLn('Cannot create new message. Wadda fuck?!');

 Dispose(B, Done);

 Close(F);

 M:=M - MemAvail;
 WriteLn('Memory leak is ', M, ' bytes.');
end.