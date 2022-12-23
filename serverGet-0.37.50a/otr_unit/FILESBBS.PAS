{$A+,B+,D+,E-,F-,G+,I+,L+,N+,O-,P+,Q-,R-,S+,T-,V+,X+,Y+}

unit FilesBbs;

interface

function FoundInFilesBbs(const Name,FilesBbs:String):Boolean;

procedure CutFromFilesBbs(const Name,FilesBbs:String);
procedure WriteDizToFilesBbs(const Name,Diz,FilesBbs:String);
procedure WriteDescToFilesBbs(const Name,Desc,FilesBbs:String);

implementation

uses Global,FileOp,Tools,Cases;

function FoundInFilesBbs(const Name,FilesBbs:String):Boolean;
var
   Inp:Text;
   Buf:String;
   FileName:String;
   I:Byte;

begin
     FoundInFilesBbs:=False;
     If not OpenText(Inp,FilesBbs) then Exit;
     FileName:=UpCaseStrF(Name);

     While not Eof(Inp) do
           begin
                ReadLn(Inp,Buf);

                Buf:=Copy(Buf,1,12);
                TrimStr(Buf);
                UpCaseStr(Buf);

                If Buf=FileName then
                   begin
                        FoundInFilesBbs:=True;
                        Break
                   end
           end;

     Close(Inp)
end;

procedure CutFromFilesBbs(const Name,FilesBbs:String);
var
   Inp,Out:Text;
   InDesc:Boolean;
   Buf,St,Tmp:String;
   TempName:String;
   I:Byte;

begin
     InDesc:=False;

     Repeat
     TempName:=Cfg.TempDir+'$'+Int2Str(Random(65535),6)+'$.$$$'
     Until not ExistFile(TempName);

     If not OpenText(Inp,FilesBbs) then Exit;
     If not CreateText(Out,TempName) then
        begin
             Close(Inp);
             Exit
        end;

     While not Eof(Inp) do
           begin
                ReadLn(Inp,Buf);

                Tmp:=Cfg.LongDescStr;
                TrimStr(Tmp);

                If Length(Tmp)>0 then
                   begin
                        St:=Buf;
                        LTrimStr(St);
                        St:=Copy(St,1,Length(Tmp));
                        If not (St=Tmp) then
                        St:=Copy(Buf,1,12)
                   end
                else St:=Copy(Buf,1,Length(Cfg.LongDescStr));

                TrimStr(St);

                If (St=Tmp) and (not InDesc) then
                   begin
                        WriteLn(Out,Buf);
                        Continue
                   end;

                If St=UpCaseStrF(Name) then
                   begin
                        InDesc:=True;
                        Continue
                   end;

                If not (St=Tmp) then
                   begin
                        InDesc:=False;
                        WriteLn(Out,Buf)
                   end
           end;

     Close(Inp);
     Close(Out);

     DeleteFile(FilesBbs);
     RenameFile(TempName,FilesBbs)
end;

procedure WriteDizToFilesBbs(const Name,Diz,FilesBbs:String);
var
   Inp,Out:Text;
   Buf,TmpBuf:String;
   First:Boolean;

begin
     If not OpenText(Inp,Diz) then Exit;
     If not AppendText(Out,FilesBbs) then
        begin
             Close(Inp);
             Exit
        end;

     First:=True;
     Write(Out,Justify(Name,13));

     While not Eof(Inp) do
           begin
                ReadLn(Inp,Buf);

                Repeat

                If First then First:=False
                else Write(Out,Cfg.LongDescStr);

                WordWrap(Buf,TmpBuf,Buf,DizBbsWrap,False);
                WriteLn(Out,TmpBuf)

                Until Buf=''
           end;

     Close(Inp);
     Close(Out)
end;

procedure WriteDescToFilesBbs(const Name,Desc,FilesBbs:String);
var
   Out:Text;
   Buf,OutBuf:String;
   First:Boolean;
   Tmp:String;

begin
     If not AppendText(Out,FilesBbs) then Exit;

     Write(Out,Justify(Name,13));

     Buf:=Desc;
     First:=True;

     Repeat

     If First then First:=False
     else Write(Out,Cfg.LongDescStr);

     WordWrap(Buf,OutBuf,Buf,DescBbsWrap,False);

     If Cfg.CutEmptyLine then
        begin
             Tmp:=OutBuf;
             TrimStr(Tmp);

             If Tmp='' then
                begin
                     First:=True;
                     Continue
                end
        end;

     If Cfg.CutNoTxt then
     If not TextFound(OutBuf) then
        begin
             First:=True;
             Continue
        end;

     WriteLn(Out,OutBuf);

     Until Buf='';

     Close(Out)
end;

end.
