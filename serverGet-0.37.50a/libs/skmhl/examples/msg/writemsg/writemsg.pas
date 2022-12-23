uses
     skMHL,
     skOpen,
     skCommon;

var
 Base: PMessageBase;
 Sender, Receiver: TAddress;
begin

 if not OpenOrCreateMessageBase(Base, 'F./') then
  begin
   WriteLn('Failed to open netmail: ', ExplainStatus(OpenStatus));

   Halt(255);
  end;

 Base^.SetBaseType(btNetmail);

 if Base^.CreateNewMessage then
  begin

   StrToAddress('2:6028/9', Sender);
   StrToAddress('2:6028/7', Receiver);   

   Base^.SetFromAndToAddress(Sender, Receiver, True);

   Base^.SetFrom('Node9 Test Robot');
   Base^.SetTo('Valery Zager');

   Base^.SetSubject('test');

   Base^.SetTextPos(Base^.GetTextSize);

   Base^.PutString(#1'PID: skMHL');

   Base^.PutString(#1'Hello, Valery!');
   Base^.PutString(#1'');   
   Base^.PutString(#1' Just it is a subj! :)))');   
   Base^.PutString(#1'');   

   Base^.PutString('--- skMHL');

   Base^.PutOrigin(Sender, 'DubnaNet');

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