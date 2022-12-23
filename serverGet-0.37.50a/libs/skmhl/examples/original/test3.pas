uses
     Crt, skMHL, skMHLsq, skCommon, skComnTV;

var
 Memory: Longint;
 B: PMessageBase;
 S: String;
 Line: Array[0..4096] Of Char;
 K: Longint;
 DT: TMessageBaseDateTime;
begin
 ClrScr;
 InstallMHLCommon;
 Memory:=MemAvail;

 B:=New(PSquishMessageBase, Init);
 if B^.Open('E:\Engine\skMHL\Examples\1\Squish') then
  begin
   WriteLn('Open.');
   WriteLn;
   WriteLn('Highest: ', B^.GetHighest);
   WriteLn('Count: ', B^.GetCount);
   WriteLn;

   if B^.CreateNewMessage then
    begin
     B^.SetFrom('From');
     B^.SetTo('To');
     B^.PutString(#1'MSGID: 1234:22/22.33 12345678'#13'XPEH!!!!'#13#13' * Origin: suxx (1:2/3.4)');
     B^.WriteMessage;
     B^.CloseMessage;
    end
   else
    WriteLn('Unable to create message(?).');

   B^.Seek(1);
   while B^.SeekFound do
    begin
     Writeln('Seeking: ', B^.SeekFound);
     WriteLn('Current: ', B^.Current);
     if B^.OpenMessage then
      begin
       WriteLn('Opened.');
       WriteLn;
       B^.SetFrom('óÔÁpÙÊ èpÅÎ');
       B^.SetTo('äpÕÇÏÊ óÔÁpÙÊ èpÅÎÉÝÅ');
       B^.SetSubject('þôï úá èòåH?');
       WriteLn('From: "', B^.GetFrom, '"');
       WriteLn('To: "', B^.GetTo, '"');
       WriteLn('Subj: "', B^.GetSubject, '"');
       B^.SetAttribute(maTransit, True);
       GetAttributesLine(B, S);
       WriteLn('Attr: "', S, '"');
       GetCurrentMessageBaseDateTime(DT);
       B^.SetWrittenDateTime(DT);
       B^.GetWrittenDateTime(DT);
       GetDateTimeLine(DT, S);
       WriteLn('Written: ', S);
       GetCurrentMessageBaseDateTime(DT);
       B^.SetArrivedDateTime(DT);
       B^.GetArrivedDateTime(DT);
       GetDateTimeLine(DT, S);
       WriteLn('Arrived: ', S);
       WriteLn('--------------');
       B^.SetTextPos(0);
       K:=0;
       while not B^.EndOfMessage do
        begin
         B^.GetStringPChar(@Line, 4095);
         WriteLn(Line, '*');
         Inc(K);
         if K > 10 then Break;
        end;
       WriteLn('--------------');
       B^.SetTextPos(B^.GetTextSize div 10);
       B^.TruncateText;
       if B^.WriteMessage then
        WriteLn('Written.')
       else
        WriteLn('Write failed.');
       B^.CloseMessage;
       if B^.KillMessage then
        WriteLn('Killed.')
       else
        Writeln('Not killed! =(');
      end
     else
      WriteLn('Cannot open ', B^.GetStatus);
     B^.SeekNext;
    end;

   B^.Close;
  end
 else
  WriteLn('Cannot open, rc=#', B^.GetStatus);
 Dispose(B, Done);

 WriteLn;
 WriteLn('Memory leak is ', Memory - MemAvail, ' bytes.');
end.