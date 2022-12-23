uses
     skMHL, skOpen, skComnD3, skCommon;

procedure Error(const S: String);
 begin
  WriteLn(S);

  Halt(255);
 end;

var
 Base: PMessageBase;
 A: TAddress;
 T: TMessageBaseDateTime;
begin
 InstallMHLcommon;

 WriteLn;

 if not OpenOrCreateMessageBase(Base, 'Je:\engine\skmhl\$') then
  Error('unable to open/create jam');

 Base^.SetFlag(afNetmail or afLocal or afEchomail, False);
 Base^.SetFlag(afEchomail, True);

 if not Base^.CreateNewMessage then
  WriteLn('unable to create new message')
 else
  begin
   StrToAddress('2:5033/27.27', A);

   Base^.SetFromAddress(A, True);

   A.Point:=0;

   Base^.SetToAddress(A);

   Base^.SetFrom('skMHL');
   Base^.SetTo('sergey_korowkin');
   Base^.SetSubject('jam routines working fine! thank you! ;-)');

   GetCurrentMessageBaseDateTime(T);
   Base^.SetWrittenDateTime(T);
   Base^.SetArrivedDateTime(T);

   Base^.SetAttribute(maLocal, True);

   Base^.PutString('');
   Base^.PutString('everything working fine, FastEcho(tm) must scan this jam base and export new messages created by skMHL(tm).');
   Base^.PutString('');
   Base^.PutString('... http://www.mart.ru/~fidonet ...');
   Base^.PutString('--- skMHL');
   Base^.PutString(' * Origin: ehhehe (2:5033/27.27)');

   if not Base^.WriteMessage then
    WriteLn('unable to write message');

   Base^.CloseMessage;
  end;

 if not CloseMessageBase(Base) then
  Error('unable to close jam');
end.