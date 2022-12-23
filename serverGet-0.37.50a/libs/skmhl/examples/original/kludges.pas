uses
     Drivers,

     skMHL,
     skCommon,
     skComnTV,
     skOpen,
     skMHLmsg,

     Leaker;

procedure Failed(const S: String);
 begin
  PrintStr(S + #13#10);

  Halt(255);
 end;

var
 Base: PFidoMessageBase;
 Storage: Longint;
 A1, A2: TAddress;
 S: String;
begin
 LeakFix(Storage);

 InstallMHLcommon;

 if not OpenOrCreateMessageBase(PMessageBase(Base), 'Fmsg\') then
  Failed('oops');

 Base^.SetBaseType(btNetmail);

{
 Base^.Seek(1);

 if Base^.OpenMessageHeader then
  begin
   Base^.SetTextPos(0);

   while not Base^.EndOfMessage do
    begin
     Base^.GetString(S);

     writeln(s);
    end;

   Base^.CloseMessage;
  end;
}

 if not Base^.CreateNewMessage then Failed('unable to create new message');

 Base^.SetFrom('sergey korowkin');
 Base^.SetTo('tatyana medvedeva');

 Base^.SetAttribute(maPrivate, True);
 Base^.SetAttribute(maLocal, True);

 writeln(base^.getaflag('PVT'));
 base^.setaflag('ZHP', True);
 base^.setaflag('ZHP', False);
 base^.setaflag('ZHP', True);
 base^.setaflag('ZHP', False);
 base^.setaflag('PVT', False);

 writeln(base^.getaflag('ZHP'));

 Base^.SetFromAndToAddress(StrToAddressR('2:6033/27.27')^, StrToAddressR('2:6033/28.28')^, True);

 Base^.SetKludge('TID', 'TID: sk v1.6');

 Base^.SetTextPos(Base^.GetTextSize);

 Base^.PutString('hallow darling!');

 Base^.PutString('');

 Base^.PutString('--- sk v1.6');

 Base^.PutOrigin(StrToAddressR('2:6033/27.0')^, 'chica chica boom chica ding');

 if not Base^.WriteMessage then Failed('unable to write message');

 if not Base^.CloseMessage then Failed('unable to close message');


 CloseMessageBase(Pmessagebase(Base));

 LeakCount(Storage);

 writeln('leak: ', storage);
end.