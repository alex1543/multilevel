uses
     skMHL,
     skOpen,
     skCommon,
     skComnTV;

var
 Base: PMessageBase;
 Sender, Receiver: TAddress;
begin
 InstallMHLcommon;

 if not OpenOrCreateMessageBase(Base, 'FF:\Fido\Netmail') then
  begin
   WriteLn('Failed to open netmail: ', ExplainStatus(OpenStatus));

   Halt(255);
  end;

 Base^.SetBaseType(btNetmail);

 if Base^.CreateNewMessage then
  begin
   StrToAddress('2:6033/27.0', Sender);
   StrToAddress('2:6033/28.0', Receiver);

   Base^.SetFromAndToAddress(Sender, Receiver, True);

   Base^.SetFrom('sergey korowkin');
   Base^.SetTo('tatyana medvedeva');

   Base^.SetSubject('J.I.L.Y. my dear ;-)');

   Base^.SetTextPos(Base^.GetTextSize);

   Base^.PutString(#1'PID: tanyushka''s letter generator');

   Base^.PutString('');
   Base^.PutString('сегодня в девять я у тебя.');
   Base^.PutString('ok?');
   Base^.PutString('');

   Base^.PutString('--- tiny sk');

   Base^.PutOrigin(Sender, 'avariya * summer is crazy');

   Base^.SetAttribute(maSent, False);
   Base^.SetAttribute(maLocal, True);
   Base^.SetAttribute(maPrivate, True);

   if not Base^.WriteMessage then
    WriteLn('Failed to write message: ', ExplainStatus(Base^.GetStatus));

   Base^.CloseMessage;
  end
 else
  WriteLn('Failed to create new message: ', ExplainStatus(Base^.GetStatus));

 CloseMessageBase(Base);
end.