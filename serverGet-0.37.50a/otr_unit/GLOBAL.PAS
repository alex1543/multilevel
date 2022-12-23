{$A+,B+,D+,E-,F-,G+,I+,L+,N+,O-,P+,Q-,R-,S+,T-,V+,X+,Y+}

unit Global;

interface

uses Objects,Dos,Tools,FileOp,Areas,Packers,
     HexNum,Dates,SysLog,Misc;

{$I prgname.inc}

type
    NnTicConfig=record
     InboundPath,FileBasePath,
     MsgTxt,LogName,TempDir:PathStr;
     Header,Footer,BadFiles:PathStr;
     Origin,Address,PrefToLog:String;
     CheckCrc,Announce,AddMsgId,ExtractDiz:Boolean;
     CutDescGraph,CutDizGraph:Boolean;
     CutEmptyLine,CutNoTxt,Replaces:Boolean;
     LongDescStr:String;
     LogBufSize:Word;
    end;

{$I const.inc}

var
   Cfg:NnTicConfig;
   Log:PFileLogObj;
   CutLines:TStringCollection;
   Arcs:TPackersCollection;
   AreaList:TAreaCollection;
   MemAtStart,FilesIn,FilesOk:LongInt;
   UseBinCfg,UsePackersBin:Boolean;
   StartTime,EndTime:LongInt;
   AreasCreated:LongInt;
   TotalSize:LongInt;
   LogFile,Ann:Text;

procedure DelSpaces(var St:String);
procedure DelRepeated(var St:String;const Chars:String);

function AcDirName(AreaTag:String):String;
function TextFound(const St:String):Boolean;
function SearchCutLines(const St:String):Boolean;

procedure ProcessTpl(const FileName:String;const NlErr:Boolean);
procedure CleanDiz(const FileName:String);

procedure OutScrDesc(Desc:String);
procedure OutAnnDesc(Desc:String);
procedure OutLogDesc(Desc:String);

procedure OutDizToScrAndLog(const Name:String);
procedure OutDizToAnn(const Name:String;var Out:Text);

implementation

procedure DelSpaces(var St:String);
var
   Len,I:Byte;
   Tmp:String;

begin
    While (Length(St)>0) and (St[1]=' ') do Delete(St,1,1);

    Len:=Length(St);
    While (Len>0) and (St[Len]=' ') do
          begin
               Delete(St,Len,1);
               Len:=Length(St)
          end;

    Len:=0;
    Tmp:='';

    For I:=1 to Length(St) do
        begin
             If St[I]=' ' then Inc(Len)
             else Len:=0;

             If Len>1 then Continue;
             Tmp:=Tmp+St[I]
        end;

    St:=Tmp
end;

procedure DelRepeated(var St:String;const Chars:String);
var
   C,I:Byte;
   Tmp:String;

begin
     For C:=1 to Length(Chars) do
         begin
              Tmp:='';

              For I:=1 to Length(St) do
                  begin
                       If not (((I<Length(St)) and (St[I]=Chars[C])
                       and (St[I+1]=Chars[C])) or ((I>1) and (St[I]=Chars[C])
                       and (St[I-1]=Chars[C]))) then Tmp:=Tmp+St[I]
                  end;

              St:=Tmp
         end
end;

function AcDirName(AreaTag:String):String;
begin
     AreaTag:=Copy(CutChars(AreaTag,'.'),1,11);
     If Length(AreaTag)>8 then Insert('.',AreaTag,9);
     AcDirName:=AreaTag
end;

function TextFound(const St:String):Boolean;
var
   I:Byte;

begin
     TextFound:=True;
     For I:=1 to Length(St) do If St[I] in TextSet then Exit;
     TextFound:=False
end;

function SearchCutLines(const St:String):Boolean;
var
   I:Integer;
   Buf:String;

begin
     SearchCutLines:=True;

     For I:=0 to CutLines.Count-1 do
         begin
              Buf:=String(CutLines.At(I)^);
              If Pos(Buf,St)>0 then Exit
         end;

     SearchCutLines:=False
end;

procedure ProcessTpl(const FileName:String;const NlErr:Boolean);
var
   Tpl:Text;
   Buf:String;
   Len:Byte;

begin
     If not OpenText(Tpl,FileName) then
        begin
             If NlErr then WriteLn(Ann);
             Exit
        end;

     While not Eof(Tpl) do
           begin
                ReadLn(Tpl,Buf);

                Len:=Length(Buf);
                KillRems(Buf);
                If Length(Buf)<Len then
                   begin
                        TrimStr(Buf);
                        If Buf='' then Continue;
                   end
                else TrimStr(Buf);

                ReplaceStr(Buf,'@DateStr',DateStr);
                ReplaceStr(Buf,'@TimeStr',TimeStr);
                ReplaceStr(Buf,'@TotalFiles',Int2Str2(FilesOk));
                ReplaceStr(Buf,'@TotalSize',Int2Str2(TotalSize));
                ReplaceStr(Buf,'@Address',Cfg.Address);
                ReplaceStr(Buf,'@Origin',Cfg.Origin);

                WriteLn(Ann,Buf)
           end;

     Close(Tpl)
end;

procedure CleanDiz(const FileName:String);
var
   Inp,Out:Text;
   TempName:PathStr;
   Empty,L:Byte;
   Buf,TmpBuf:String;

begin
     If not OpenText(Inp,FileName) then Exit;

     Repeat
     TempName:=Cfg.TempDir+'$'+Int2Str(Random(65535),6)+'$.$$d'
     Until not ExistFile(TempName);

     If not CreateText(Out,TempName) then
        begin
             Close(Inp);
             Exit
        end;

     L:=0;
     Empty:=0;

     While not Eof(Inp) do
           begin
                Inc(L);
                ReadLn(Inp,Buf);

                If SearchCutLines(Buf) then Continue;

                If Cfg.CutNoTxt then
                If not TextFound(Buf) then Continue;

                If Cfg.CutDizGraph then
                   begin
                        Buf:=CutCharSet(Buf,Graphics);
                        DelRepeated(Buf,RepChars);
                        DelSpaces(Buf)
                   end;

                TmpBuf:=Buf;
                TrimStr(TmpBuf);

                If not Cfg.CutEmptyLine then
                   begin
                        If TmpBuf='' then Inc(Empty)
                        else Empty:=0;

                        If (Empty=L) or (Empty>1) or ((Empty>0)
                        and Eof(Inp)) then Continue
                   end
                else If TmpBuf='' then Continue;

                WriteLn(Out,Buf)
           end;

     Close(Out);
     Close(Inp);

     DeleteROFile(FileName);
     RenameFile(TempName,FileName)
end;

{
procedure OutScrDesc(Desc:String);
var
   Tmp:String;
   I:Byte;

begin
     Repeat

     If Length(Desc)>DescScrWrap then
        begin
             Tmp:=Copy(Desc,1,Succ(DescScrWrap));
             Tmp:=ReverseStr(Tmp);
             I:=Succ(DescScrWrap)-Pos(' ',Tmp);
             If I=Succ(DescScrWrap) then Dec(I)
        end
     else I:=Length(Desc);

     Tmp:=Copy(Desc,1,I);
     TrimStr(Tmp);
     WriteLn('Desc ..... ',Tmp);
     Delete(Desc,1,I+1);

     Until Length(Desc)=0
end;

procedure OutAnnDesc(Desc:String);
var
   Tmp:String;
   I:Byte;

begin
     Repeat

     If Length(Desc)>DescAnnWrap then
        begin
             Tmp:=Copy(Desc,1,Succ(DescAnnWrap));
             Tmp:=ReverseStr(Tmp);
             I:=Succ(DescAnnWrap)-Pos(' ',Tmp);
             If I=Succ(DescAnnWrap) then Dec(I)
        end
     else I:=Length(Desc);

     Tmp:=Copy(Desc,1,I);
     TrimStr(Tmp);
     WriteLn(Ann,'Desc ..... ',Tmp);
     Delete(Desc,1,I+1);

     Until Length(Desc)=0
end;

procedure OutLogDesc(Desc:String);
var
   Tmp:String;
   I:Byte;

begin
     Repeat

     If Length(Desc)>DescLogWrap then
        begin
             Tmp:=Copy(Desc,1,Succ(DescLogWrap));
             Tmp:=ReverseStr(Tmp);
             I:=Succ(DescLogWrap)-Pos(' ',Tmp);
             If I=Succ(DescLogWrap) then Dec(I)
        end
     else I:=Length(Desc);

     Tmp:=Copy(Desc,1,I);
     TrimStr(Tmp);
     Log^.Write('Desc: '+Tmp,'>');
     Delete(Desc,1,I+1);

     Until Length(Desc)=0
end;
}

procedure OutScrDesc(Desc:String);
var
   OutBuf,Tmp:String;

begin
     Repeat

     WordWrap(Desc,OutBuf,Desc,DescScrWrap,False);

     If Cfg.CutEmptyLine then
        begin
             Tmp:=OutBuf;
             TrimStr(Tmp);
             If Tmp='' then Continue
        end;

     If Cfg.CutNoTxt then
     If not TextFound(OutBuf) then Continue;

     WriteLn('Desc ..... ',OutBuf);

     Until Desc=''
end;

procedure OutLogDesc(Desc:String);
var
   OutBuf,Tmp:String;

begin
     Repeat

     WordWrap(Desc,OutBuf,Desc,DescLogWrap,False);

     If Cfg.CutEmptyLine then
        begin
             Tmp:=OutBuf;
             TrimStr(Tmp);
             If Tmp='' then Continue
        end;

     If Cfg.CutNoTxt then
     If not TextFound(OutBuf) then Continue;

     Log^.Write('Desc: '+OutBuf,'>');

     Until Desc=''
end;

procedure OutAnnDesc(Desc:String);
var
   OutBuf,Tmp:String;

begin
     Repeat

     WordWrap(Desc,OutBuf,Desc,DescAnnWrap,False);

     If Cfg.CutEmptyLine then
        begin
             Tmp:=OutBuf;
             TrimStr(Tmp);
             If Tmp='' then Continue
        end;

     If Cfg.CutNoTxt then
     If not TextFound(OutBuf) then Continue;

     WriteLn(Ann,'Desc ..... ',OutBuf);

     Until Desc=''
end;

procedure OutDizToScrAndLog(const Name:String);
var
   F:Text;
   Buf,TmpBuf:String;
   Save:String;

begin
     If not OpenText(F,Name) then Exit;

     While not Eof(F) do
           begin
                ReadLn(F,Buf);
                Save:=Buf;

                Repeat
                WordWrap(Buf,TmpBuf,Buf,DizScrWrap,False);
                WriteLn('Desc ..... ',TmpBuf);
                Until Buf='';

                Buf:=Save;

                Repeat
                WordWrap(Buf,TmpBuf,Buf,DizLogWrap,False);
                Log^.Write('Desc: '+TmpBuf,'>')
                Until Buf=''
           end;

     Close(F)
end;

procedure OutDizToLog(const Name:String);
var
   F:Text;
   Buf,TmpBuf:String;

begin
     If not OpenText(F,Name) then Exit;

     While not Eof(F) do
           begin
                ReadLn(F,Buf);

           end;

     Close(F)
end;

procedure OutDizToAnn(const Name:String;var Out:Text);
var
   F:Text;
   Buf,TmpBuf:String;

begin
     If not OpenText(F,Name) then Exit;

     While not Eof(F) do
           begin
                ReadLn(F,Buf);

                Repeat
                WordWrap(Buf,TmpBuf,Buf,DizAnnWrap,False);
                WriteLn(Out,'Desc ..... ',TmpBuf)
                Until Buf=''
           end;

     Close(F)
end;

begin
     Log:=nil;
end.
