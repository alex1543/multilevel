uses
     Wizard,

     skMHL,
     skOpen,
     skCommon,
     skComnTV;

procedure Failed(const Reason: String);
 begin
  WriteLn(Reason);

  Halt;
 end;

var
 Base: PMessageBase;
begin
 InstallMHLcommon;

 if not OpenOrCreateMessageBase(Base, 'se:\engine\skmhl\auto0013') then
  Failed('unable to open: ' + ExplainStatus(OpenStatus));

 Base^.SetBaseType(btEchomail);

 if not Base^.CreateNewMessage then
  Failed('failed to create new message: ' + ExplainStatus(Base^.Status))
 else
  begin
   Base^.SetFrom('sk');
   Base^.SetTo('all');
   Base^.SetSubject('i know, you gonna digest!');

   Base^.SetFromAddress(StrToAddressR('2:6033/27.0')^, True);

   Base^.SetTextPos(Base^.GetTextSize);

   Base^.PutString('');
   Base^.PutString('¹ˆp‰©¥©Š ½¾¥ ‰¾¥Š, ©¹½‰p¥Ž¥!');
   Base^.PutString('');
   Base^.PutString('--- BUGTRAQ');
   Base^.PutOrigin(StrToAddressR('666:666/666.666')^, '* Arrival * Devil * Brain *');

   if not Base^.WriteMessage then
    Failed('failed to write message: ' + ExplainStatus(Base^.Status));

   Base^.CloseMessage;
  end;

 CloseMessageBase(Base);
end.