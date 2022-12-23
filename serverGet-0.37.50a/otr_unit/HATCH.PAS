{$A+,B+,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 16384,0,655360}

program Hatch;

uses RunTime,Memory,Dos,Tools,Config,FileOp,HexNum,Cases,
     Global,Misc,Crc,Dates,Packers,OsDet,BSO,Fido;

{$I prgname.inc}
{$I const.inc}

var
   DefAddr:TFidoAddress;
   YourAddr,ToAddr,ReplMask:String;
   Area,Desc,Pwd,Params,UtcOffs:String;
   CfgName,TicName,RspFile:String;
   FileName,TempDir:String;
   DizToLDesc:Boolean;

function GetRepl(Params:String):String;
var
   I:Byte;

begin
     GetRepl:='';
     UpCaseStr(Params);
     I:=Pos('/R',Params);
     If I=0 then Exit;
     Delete(Params,1,I+1);
     TrimStr(Params);
     GetRepl:=Params
end;

function ExpandAddr(const St:String):String;
var
   Addr:TFidoAddress;

begin
     StrToAddr2(St,DefAddr,Addr);
     ExpandAddr:=AddrToStr(Addr,True)
end;

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

function ExtractDiz(const FileName,TempDir:String):Boolean;
var
   Arc:PArcInfoRec;
   DoChDir:Boolean;
   St,Save:String;
   RetVal:Word;

begin
     ExtractDiz:=False;
     DeleteROFile(TempDir+DizName);

     Arc:=FindArchiver(Arcs,FileName);
     If Arc=nil then Exit;

     WriteLn('Arch ..... ',Arc^.ArcName^);

     St:=Arc^.ExtrCmd^;
     ReplCaseStr(St,'%f',DizName);
     ReplCaseStr(St,'%a',FExpand(FileName));

     DoChDir:=(Pos('%p',St)=0);

     If DoChDir then
        begin
             GetDir(0,Save);
             ChangeDir(TempDir)
        end
     else ReplCaseStr(St,'%p',TempDir);

     RetVal:=SilentExec(GetEnv('COMSPEC'),' /c '+St+' >nul ');
     If not (RetVal=0) then WriteLn('Exec error! Code: ',RetVal);

     If DoChDir then ChDir(Save);

     ExtractDiz:=ExistFile(TempDir+DizName)
end;

procedure WriteDizToLDesc(var Tic:Text;const DizName:String);
var
   Buf:String;
   Diz:Text;

begin
     If not OpenText(Diz,DizName) then Exit;

     While not Eof(Diz) do
           begin
                ReadLn(Diz,Buf);
                WriteLn(Tic,'LDesc ',Buf)
           end;

     Close(Diz)
end;

procedure MakeTic(const Area,FileName,Desc,Pw:String);
var
   TicName:String;
   Addr:TFidoAddress;
   List:TFilesList;
   Crc32,Date:LongInt;
   Tic:Text;

begin
     StrToAddr2(ToAddr,DefAddr,Addr);

     If CheckForBusy(Addr) then
     Error('Address '+ToAddr+' is busy');

     If not CalcCrc32(FileName,Crc32) then
     Error('File '+FileName+' not found');

     Repeat
     TicName:='NN'+Word2Hex(Random($FFFF)+1)+Byte2Hex(Random($FF)+1)+'.TIC';
     TicName:=OutboundPath+TicName
     Until not ExistFile(TicName);

     If not CreateText(Tic,TicName) then
     Error('Can not open file '+TicName);

     WriteLn(Tic,'Area ',Area);
     WriteLn('Area ..... ',Area);
     WriteLn(Tic,'File ',GetFileNameExt(FileName));
     WriteLn('File ..... ',GetFileNameExt(FileName));

     If not (ReplMask='') then
        begin
             WriteLn(Tic,'Replaces ',ReplMask);
             WriteLn('Repl ..... ',ReplMask)
        end;

     WriteLn(Tic,'Desc ',Desc);
     If Length(Desc)>DescScrWrap then OutScrDesc(Desc)
     else WriteLn('Desc ..... ',Desc);

     If DizToLDesc then
     If ExtractDiz(FileName,TempDir) then
        begin
             WriteDizToLDesc(Tic,TempDir+DizName);
             DeleteROFile(TempDir+DizName)
        end;

     WriteLn(Tic,'Origin ',YourAddr);
     WriteLn(Tic,'From ',YourAddr);
     WriteLn(Tic,'Crc ',Long2Hex(Crc32));
     WriteLn('Crc ...... ',Long2Hex(Crc32));

     Write(Tic,'Created by '+PrgName+' Copyright (c) ');
     WriteLn(Tic,'DALLAS Software, Inc.');

     Write(Tic,'Path ',YourAddr,' ',GetUnixDateTime,' ');
     WriteLn(Tic,PathDateStr,UtcOffs);

     WriteLn(Tic,'Seenby ',YourAddr);
     WriteLn(Tic,'Seenby ',ToAddr);
     WriteLn(Tic,'Pw ',Pw);

     Close(Tic);

     List.Init(1,1);
     List.AddItem(FileName);
     List.AddItem('^'+TicName);

     If not AttachFiles(Addr,@List,'F') then
        begin
             List.Done;
             DeleteFile(TicName);
             Error('Can not attach files')
        end;

     List.Done;
     RemoveBusyFlag(Addr)
end;

procedure Usage;
begin
     Write('Usage: hatch.exe <area> <file> <uplink> ');
     WriteLn('<pwd> ["<desc>"] [/R <replaces>]');
     WriteLn('   or  hatch.exe @<responce-file>');
     Halt
end;

procedure SetCmdLineParams;
begin
     Area:=ParamStr(1);
     UpCaseStr(Area);
     FileName:=FExpand(ParamStr(2));
     ToAddr:=ExpandAddr(ParamStr(3));
     Pwd:=ParamStr(4);
     Desc:=GetDesc(Params);
     ReplMask:=GetRepl(Params)
end;

procedure SetRspFileParams;
var
   Rsp:Text;
   Tmp:String;

begin
     If not OpenText(Rsp,RspFile) then
     Error('Can not open file '+RspFile);

     ReadLn(Rsp,Area);
     TrimStr(Area);
     UpCaseStr(Area);

     ReadLn(Rsp,FileName);
     TrimStr(FileName);
     FileName:=FExpand(FileName);

     ReadLn(Rsp,ToAddr);
     TrimStr(ToAddr);
     ToAddr:=ExpandAddr(ToAddr);

     ReadLn(Rsp,Pwd);
     TrimStr(Pwd);

     ReadLn(Rsp,Tmp);
     TrimStr(Tmp);

     If Pos('"',Tmp)>0 then
        begin
             Desc:=GetDesc(Tmp);
             ReadLn(Rsp,ReplMask);
             TrimStr(ReplMask);
             UpCaseStr(ReplMask)
        end
     else
         begin
              Desc:='No description';
              ReplMask:=Tmp
         end;

     Close(Rsp)
end;

procedure LoadPackersList;
var
   PackName:PathStr;

begin
     PackName:=GetFileDir(ParamStr(0))+'PACKERS.CFG';

     If not ExistFile(PackName) then
     Error('Can not find file '+PackName);

     LoadPackers(Arcs,PackName)
end;

procedure ReadConfiguration;
var
   Conf:TConfCollection;

begin
     Conf.Init(1,1);

     If not Conf.ReadFile(CfgName) then
     Error('File '+CfgName+' not found');

     Conf.SetDefValue('outbound','outbound');
     Conf.SetDefValue('tempdir',GetEnv('TEMP'));
     Conf.SetDefValue('address','1:1/1.1');

     OutboundPath:=FExpand(Conf.GetValue('outbound'));
     TempDir:=FExpand(Conf.GetValue('tempdir'));

     YourAddr:=Conf.GetValue('address');
     UtcOffs:=Conf.GetValue('utcoffset');
     DizToLDesc:=Str2Bool(Conf.GetValue('diztoldesc'));

     Conf.Done;

     If not (UtcOffs='') then UtcOffs:=' '+UtcOffs;

     AddBackSlash(OutboundPath);
     AddBackSlash(TempDir);

     StrToAddr(YourAddr,DefAddr);
     If (DefAddr.Zone=0) or (DefAddr.Net=0) then
     Error('Invalid address in config file');

     YourAddr:=AddrToStr(DefAddr,True);
     LocalZone:=DefAddr.Zone
end;

begin
     Randomize;
     InitMemory;

     Write(CrLf,'<<< ',PrgName,' >>>  Copyright (c) ');
     WriteLn('1999 DALLAS Software, Inc.',CrLf);

     Params:=GetCommandLine;
     If Length(Params)>115 then
        begin
             Write('Warning: command line length is too long, ');
             WriteLn('check tic after creating',CrLf)
        end;

     RspFile:=ParamStr(1);
     If RspFile[1]='@' then
        begin
             Delete(RspFile,1,1);
             TrimStr(RspFile)
        end
     else RspFile:='';

     If (ParamCount<4) and (RspFile='') then Usage;
     CfgName:=GetFileDirName(ParamStr(0))+'.CFG';

     ReadConfiguration;

     If DizToLDesc then
        begin
             Arcs.Init(1,1);
             DetectOsType;
             LoadPackersList
        end;

     If RspFile='' then SetCmdLineParams
     else SetRspFileParams;

     WriteLn('Sending files to: ',ToAddr,CrLf);

     MakeTic(Area,FileName,Desc,Pwd);
     If DizToLDesc then Arcs.Done;

     DoneMemory;

     WriteLn(CrLf,'All done')
end.
