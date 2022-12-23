uses
     skMHL,
     skOpen,
     skCommon,
     skComnTV;

var
 B: PMessageBase;
 A: TAddress;
 S: String;
begin
 InstallMHLcommon;

 if not OpenOrCreateMessageBase(B, 'FTest\') then
  Halt(255);

 WriteLn;

 B^.SetFlag(afEchomail or afLocal, False);
 B^.SetFlag(afNetmail, True);

 B^.CreateNewMessage;
{
 StrToAddress('2:5033/27.222', A);

 B^.SetFromAddress(A, True);

 StrToAddress('2:5020/400.111', A);

 B^.SetToAddress(A);

 B^.SetTextPos(0);

 while not B^.EndOfMessage do
  begin
   B^.GetString(S);

   WriteLn(S);
  end;
}
{
 B^.PutString('INTL 2:5033/27 2:5020/400');
 B^.PutString('FMPT 111');
 B^.PutString('TOPT 222');

 B^.PutString('zzxc');

 B^.PutString('MSGID: 2:5020/400 abcdefgh');
}
 B^.PutString('TOPT 111');
 B^.PutString('FMPT 222');
 B^.PutString('INTL 2:5020/400 2:5033/27');
 B^.PutString('MSGID: 2:5033/27.222 61cf68c6');

 B^.SetTextPos(0);

 B^.GetFromAddress(A);

 WriteLn('from: ', AddressToStr(A));

 B^.GetToAddress(A);

 WriteLn('to:   ', AddressToStr(A));

 B^.WriteMessage;

 B^.CloseMessage;

 CloseMessageBase(B);
end.