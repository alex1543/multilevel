{$A+,B+,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 16384,0,655360}

{ No Name TIC version 1.4 (release) }
{ (C) 1997-99 DALLAS Software, Inc. }

program TicProc;

uses RunTime,Objects,Memory,Dos,Global,Config,Cases,FileOp,Areas,
     FilesBbs,Misc,Crc,Tools,HexNum,Packers,Dates,OsDet,SysLog;

{
  Пpи отладке юнит RunTime надо убиpать,
  а то runtime errors ловиться не будут ;-)
}

const
     BinCfgId='TicProc.Bin'#26;
     AreaCfgId='Areas.Bin'#26;
     PackCfgId='Packers.Bin'#26;
     Warn:Boolean=False;

var
   TextCfgName,BinCfgName:PathStr;
   TextAreaName,BinAreaName:PathStr;
   TextPackName,BinPackName:PathStr;
   Tmp,CmdLine:String;

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

     Log^.Write('Arch: '+Arc^.ArcName^,'=');
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

procedure ProcessShortDesc(var Tic:TConfCollection;var Desc:String);
begin
     Desc:=Tic.GetValue('desc');
     If (Desc='') or (Desc=#0) then Desc:='No description';

     If Cfg.CutDescGraph then
        begin
             Desc:=CutCharSet(Desc,Graphics);
             DelRepeated(Desc,RepChars);
             DelRepeated(Desc,RepChars);
             DelSpaces(Desc)
        end;

     OutScrDesc(Desc);
     OutLogDesc(Desc)
end;

procedure ProcessDizDesc(const FileName:String);
begin
     If ExtractDiz(FileName,Cfg.TempDir) then
        begin
             CleanDiz(Cfg.TempDir+DizName);
             OutDizToScrAndLog(Cfg.TempDir+DizName);
        end
end;

procedure ProcessLDesc(var Tic:TConfCollection);
var
   F:Text;
   Buf:String;
   I:Integer;

begin
     If not CreateText(F,Cfg.TempDir+DizName) then Exit;

     For I:=1 to Tic.CountKeywords('ldesc') do
         begin
              Buf:=Tic.GetValueN('ldesc',I);
              If Buf=#0 then Continue;
              WriteLn(F,Buf);
         end;

     Close(F);

     CleanDiz(Cfg.TempDir+DizName);
     OutDizToScrAndLog(Cfg.TempDir+DizName)
end;

procedure ProcessReplaces(Path:String;FileName,Repl:FNameStr);
var
   Sr:SearchRec;

begin
     AddBackSlash(Path);
     UpCaseStr(FileName);

     FindFirst(Path+Repl,Archive,Sr);
     While DosError=0 do
           begin
                UpCaseStr(Sr.Name);
                If (Sr.Name=FileName) or (Sr.Name='FILES.BBS')
                or (Sr.Name='FILES.BAK') or (Sr.Name='FILES.IDX')
                or (Sr.Name='FILES.DAT') then
                   begin
                        FindNext(Sr);
                        Continue
                   end;

                DeleteFile(Path+Sr.Name);
                CutFromFilesBbs(Sr.Name,Path+'files.bbs');

                FindNext(Sr)
           end
end;

function ReadTic(var Tic:TConfCollection;const FileName:String):Boolean;
var
   F:Text;
   Buf:String;
   Keyword:String[25];
   I:Byte;

begin
     ReadTic:=False;
     If not OpenText(F,FileName) then Exit;

     While not Eof(F) do
           begin
                ReadLn(F,Buf);

                KillRems(Buf);
                TrimStr(Buf);
                If Buf='' then Continue;

                Keyword:=ExtractWord(1,Buf,Delims);
                Delete(Buf,1,Length(Keyword)+1);
                UpCaseStr(Keyword);

                If not (Keyword='LDESC') then TrimStr(Buf);

                Tic.AddItem(Keyword,Buf)
           end;

     Close(F);
     ReadTic:=True
end;

procedure ProcessTic(const Path,TicName:String);
var
   Area:String[50];
   Tmp,Desc:String;
   AreaPath:PathStr;
   FileName,Repl:String[12];
   NoDiz,NoCrc,LDesc:Boolean;
   Crc32,Norm,Size:LongInt;
   Tic:TConfCollection;
   FromVia:String[60];
   I:Integer;

begin
     Tic.Init(1,1);

     If not ReadTic(Tic,Path+TicName) then Exit;

     Inc(FilesIn);
     DeleteROFile(Cfg.TempDir+DizName);
     Tic.SetDefValue('area','unknown');

     Log^.Write('','@');
     WriteLn('Tic ...... ',TicName);
     Log^.Write('Processing '+TicName,'%');

     Area:=Tic.GetValue('area');
     UpCaseStr(Area);
     WriteLn('Area ..... ',Area);
     Log^.Write('Area: '+Area,'#');

     FromVia:=Tic.GetValue('origin')+' via '+Tic.GetValue('from');
     WriteLn('From ..... ',FromVia);
     Log^.Write('From: '+FromVia,':');

     FileName:=Tic.GetValue('file');
     UpCaseStr(FileName);
     WriteLn('File ..... ',FileName);
     Log^.Write('File: '+FileName,'&');

     If Cfg.Replaces then
        begin
             Repl:=Tic.GetValue('replaces');
             If not ((Repl='') or (Repl=#0)) then
                begin
                     UpCaseStr(Repl);
                     WriteLn('Repl ..... ',Repl);
                     Log^.Write('Repl: '+Repl,'*')
                end
        end;

     LDesc:=(Tic.CountKeywords('ldesc')>0);

     If not LDesc then
        begin
             If Cfg.ExtractDiz and ExistFile(Path+FileName)
             then ProcessDizDesc(Path+FileName)
        end
     else ProcessLDesc(Tic);

     NoDiz:=not ExistFile(Cfg.TempDir+DizName);
     If NoDiz then ProcessShortDesc(Tic,Desc);

     If Cfg.CheckCrc then
        begin
             Tmp:=Tic.GetValue('crc');
             If not ((Tmp='') or (Tmp=#0)) then
                begin
                     UpCaseStr(Tmp);
                     WriteLn('Crc ...... ',Tmp);
                     Log^.Write('Crc32: '+Tmp,'$');
                     Norm:=Hex2Long(Tmp);
                     NoCrc:=HexError
                end
             else NoCrc:=True
        end;

     Tic.Done;

     If not AreaList.Search(@Area,I) then
        begin
             Inc(AreasCreated);
             WriteLn('Not found, autocreating...');
             Log^.Write('Not found, autocreating...','#');
             AreaPath:=Cfg.FileBasePath+AcDirName(Area);
             AreaList.AddArea(Area,AreaPath,True)
        end
     else AreaPath:=AreaList.GetAreaPath(I);

     AddBackSlash(AreaPath);
     If not ExistDir(AreaPath) then MakeDir(AreaPath);

     If not ExistFile(Path+FileName) then
        begin
             WriteLn('File not found...',CrLf);
             Log^.Write('File not found...','!');

             If not (Cfg.BadFiles='') then
                begin
                     DeleteFile(Cfg.BadFiles+TicName);
                     RenameFile(Path+TicName,Cfg.BadFiles+TicName)
                end
             else DeleteFile(Path+TicName);

             Exit
        end;

     If Cfg.CheckCrc and (not NoCrc) then
     If not (CalcCrc32(Path+FileName,Crc32) and (Crc32=Norm)) then
        begin
             WriteLn('Incorrect checksum (',Long2Hex(Crc32),')...',CrLf);
             Log^.Write('Incorrect checksum ('+Long2Hex(Crc32)+')...','!');

             If Cfg.BadFiles='' then
                begin
                     DeleteFile(Path+TicName);
                     DeleteFile(Path+FileName)
                end
             else
                 begin
                      DeleteFile(Cfg.BadFiles+TicName);
                      RenameFile(Path+TicName,Cfg.BadFiles+TicName);
                      DeleteFile(Cfg.BadFiles+FileName);
                      RenameFile(Path+FileName,Cfg.BadFiles+FileName)
                 end;

             Exit
         end;

     DeleteFile(AreaPath+FileName);
     If not RenameFile(Path+FileName,AreaPath+FileName) then
        begin
             WriteLn('Error moving file...',CrLf);
             Log^.Write('Error moving file...','!');
             Exit
        end
     else DeleteFile(Path+TicName);

     Tmp:=AreaPath+'files.bbs';
     If not ExistFile(Tmp) then CreateZeroFile(Tmp)
     else CutFromFilesBbs(FileName,Tmp);

     If NoDiz then WriteDescToFilesBbs(FileName,Desc,Tmp)
     else WriteDizToFilesBbs(FileName,Cfg.TempDir+DizName,Tmp);

     If Cfg.Replaces and (not (Repl='')) then
     ProcessReplaces(AreaPath,FileName,Repl);

     Inc(FilesOk);

     If Cfg.Announce then
        begin
             WriteLn(Ann);
             WriteLn(Ann,'Area ..... ',Area);
             WriteLn(Ann,'From ..... ',FromVia);
             WriteLn(Ann,'File ..... ',FileName);

             If Cfg.Replaces and (not ((Repl='')
             or (Repl=#0))) then WriteLn(Ann,'Repl ..... ',Repl);

             Size:=GetFileSize(AreaPath+FileName);
             WriteLn(Ann,'Size ..... ',Size,' bytes');

             TotalSize:=TotalSize+Size;

             If NoDiz then OutAnnDesc(Desc)
             else OutDizToAnn(Cfg.TempDir+DizName,Ann)
        end;

     DeleteROFile(Cfg.TempDir+DizName);
     WriteLn
end;

procedure SearchForTic(Path:PathStr);
var
   Search:SearchRec;

begin
     AddBackSlash(Path);
     FindFirst(Path+'*.tic',Archive,Search);
     While DosError=0 do
           begin
                ProcessTic(Path,Search.Name);
                FindNext(Search)
           end
end;

procedure LoadAreaList;
var
   BinCfg:TBufStream;
   Txt,Bin:LongInt;
   Dir:DirStr;
   Name:NameStr;
   Ext:ExtStr;

begin
     FSplit(ParamStr(0),Dir,Name,Ext);
     TextAreaName:=Dir+'AREAS.CFG';
     BinAreaName:=Dir+'AREAS.BIN';

     If UseBinCfg then
        begin
             Txt:=GetFileDate(TextAreaName);
             Bin:=GetFileDate(BinAreaName)
        end;

     If (Txt=Bin) and UseBinCfg then
        begin
             BinCfg.Init(BinAreaName,stOpenRead,4096);
             If not (BinCfg.Status=stOk) then
             Error('Can not open file '+BinAreaName);

             Tmp[0]:=Chr(Length(AreaCfgId));
             BinCfg.Read(Tmp[1],Length(AreaCfgId));
             If not (Tmp=AreaCfgId) then
             Error('Invalid binary config file '+BinAreaName);

             AreaList.Load(BinCfg);
             BinCfg.Done
        end
     else
         begin
              AreaList.Init(1,1);
              LoadAreas(AreaList,TextAreaName);

              If UseBinCfg then
                 begin
                      BinCfg.Init(BinAreaName,stCreate,4096);
                      If not (BinCfg.Status=stOk) then
                      Error('Can not create file '+BinAreaName);

                      Tmp:=AreaCfgId;
                      BinCfg.Write(Tmp[1],Length(Tmp));

                      AreaList.Store(BinCfg);
                      SetHFileDate(BinCfg.Handle,Txt);
                      BinCfg.Done
                 end
         end;

     Write('Area definitions: ');
     WriteLn(MemAtStart-MemAvail,' bytes',CrLf);
     Tmp:=Int2Str(AreaList.Count,1)+' area(s) loaded';
     Tmp:=Tmp+' ('+Int2Str(MemAtStart-MemAvail,1)+' bytes)';
     Log^.Write(Tmp,'-')
end;

procedure LoadPackersList;
var
   I:OpSysType;
   BinCfg:TBufStream;
   Txt,Bin:LongInt;

begin
     TextPackName:=GetFileDir(ParamStr(0));
     BinPackName:=TextPackName+'PACKERS.BIN';
     TextPackName:=TextPackName+'PACKERS.CFG';

     If not ExistFile(TextPackName) then
     Error('Can not find file '+TextPackName);

     If UsePackersBin then
        begin
             Txt:=GetFileDate(TextPackName);
             Bin:=GetFileDate(BinPackName)
        end;

     If (Txt=Bin) and UsePackersBin then
        begin
             BinCfg.Init(BinPackName,stOpenRead,4096);
             If not (BinCfg.Status=stOk) then
             Error('Can not open file '+BinPackName);

             Tmp[0]:=Chr(Length(PackCfgId));
             BinCfg.Read(Tmp[1],Length(PackCfgId));
             BinCfg.Read(I,SizeOf(I));

             If not ((Tmp=PackCfgId) and (I=CurrOs)) then
                begin
                     BinCfg.Done;

                     If not (I=CurrOs) then
                        begin
                             WriteLn('Warning: Binary config for another OS');
                             Warn:=True
                        end;

                     If not (Tmp=PackCfgId) then
                        begin
                             WriteLn('Warning: Invalid binary config file');
                             Warn:=True
                        end;

                     Arcs.Init(1,1);
                     LoadPackers(Arcs,TextPackName);
                     Bin:=0
                end
             else
                 begin
                      Arcs.Load(BinCfg);
                      BinCfg.Done
                 end
        end
     else
         begin
              Arcs.Init(1,1);
              LoadPackers(Arcs,TextPackName)
         end;

     If (not (Txt=Bin)) and UsePackersBin then
        begin
             BinCfg.Init(BinPackName,stCreate,4096);
             If not (BinCfg.Status=stOk) then
             Error('Can not create file '+BinPackName);

             Tmp:=PackCfgId;
             BinCfg.Write(Tmp[1],Length(Tmp));
             BinCfg.Write(CurrOs,SizeOf(CurrOs));

             Arcs.Store(BinCfg);
             SetHFileDate(BinCfg.Handle,Txt);
             BinCfg.Done;
        end
end;

function ReadBinaryConfiguration:Boolean;
var
   BinCfg:TBufStream;

begin
     ReadBinaryConfiguration:=False;

     BinCfg.Init(BinCfgName,stOpenRead,4096);
     If not (BinCfg.Status=stOk) then
        begin
             BinCfg.Done;
             Exit
        end;

     Tmp[0]:=Chr(Length(BinCfgId));
     BinCfg.Read(Tmp[1],Length(BinCfgId));
     If not ((BinCfg.Status=stOk) and (Tmp=BinCfgId)) then
        begin
             BinCfg.Done;
             Exit
        end;

     BinCfg.Read(Cfg,SizeOf(Cfg));
     If not (BinCfg.Status=stOk) then
        begin
             BinCfg.Done;
             Exit
        end;

     CutLines.Load(BinCfg);

     ReadBinaryConfiguration:=True;
     BinCfg.Done
end;

function SaveBinaryConfiguration:Boolean;
var
   BinCfg:TBufStream;
   Txt:LongInt;

begin
     SaveBinaryConfiguration:=False;

     BinCfg.Init(BinCfgName,stCreate,4096);
     If not (BinCfg.Status=stOk) then
        begin
             BinCfg.Done;
             Exit
        end;

     Txt:=GetFileDate(TextCfgName);

     Tmp:=BinCfgId;
     BinCfg.Write(Tmp[1],Length(Tmp));
     If not (BinCfg.Status=stOk) then
        begin
             BinCfg.Done;
             Exit
        end;

     BinCfg.Write(Cfg,SizeOf(Cfg));
     If not (BinCfg.Status=stOk) then
        begin
             BinCfg.Done;
             Exit
        end;

     CutLines.Store(BinCfg);

     SetHFileDate(BinCfg.Handle,Txt);
     SaveBinaryConfiguration:=True;
     BinCfg.Done
end;

procedure ReadTextConfiguration;
var
   I:Integer;
   Conf:TConfCollection;
   Temp:String;

begin
     CutLines.Init(1,1);
     Conf.Init(1,1);

     If not Conf.ReadFile(TextCfgName) then
     Error('Can not open file '+TextCfgName);

     Conf.SetDefValue('inbound','inbound');
     Conf.SetDefValue('filebase','filebase');
     Conf.SetDefValue('logname',Cfg.LogName);
     Conf.SetDefValue('logbufsize','2000');

     Conf.SetDefValue('msgtxtfile','announce.txt');
     Conf.SetDefValue('headerfile','');
     Conf.SetDefValue('footerfile','');
     Conf.SetDefValue('origin','No Origin');
     Conf.SetDefValue('address','2:2/2.2');

     Conf.SetDefValue('prefixtolog','>@%#&$!-+=*:');
     Conf.SetDefValue('tempdir',GetEnv('TEMP'));
     Conf.SetDefValue('cutgraph','');
     Conf.SetDefValue('longdescstr',Spaces(13));

     Cfg.InboundPath:=Conf.GetValue('inbound');
     Cfg.FileBasePath:=Conf.GetValue('filebase');
     Cfg.BadFiles:=Conf.GetValue('badfiles');
     Cfg.LogName:=Conf.GetValue('logname');

     Temp:=Conf.GetValue('logbufsize');
     If not Str2Word(Temp,Cfg.LogBufSize) then Cfg.LogBufSize:=2000;

     Cfg.Announce:=Str2Bool(Conf.GetValue('announce'));

     If Cfg.Announce then
        begin
             Cfg.AddMsgId:=Str2Bool(Conf.GetValue('addmsgid'));
             Cfg.MsgTxt:=Conf.GetValue('msgtxtfile');
             Cfg.Header:=Conf.GetValue('headerfile');
             Cfg.Footer:=Conf.GetValue('footerfile');
             Cfg.Origin:=GetParams(Conf.GetValue('origin'));
             Cfg.Address:=Conf.GetValue('address')
        end;

     Cfg.PrefToLog:=GetParams(Conf.GetValue('prefixtolog'));
     Cfg.CheckCrc:=Str2Bool(Conf.GetValue('checkcrc'));
     Cfg.Replaces:=Str2Bool(Conf.GetValue('replaces'));
     Cfg.ExtractDiz:=Str2Bool(Conf.GetValue('extractdiz'));
     Cfg.TempDir:=FExpand(Conf.GetValue('tempdir'));
     AddBackSlash(Cfg.TempDir);

     Tmp:=UpCaseStrF(Conf.GetValue('cutgraph'));
     Cfg.CutDescGraph:=(Pos('DESC',Tmp)>0);
     Cfg.CutDizGraph:=(Pos('DIZ',Tmp)>0);
     Cfg.CutEmptyLine:=(Pos('SPC',Tmp)>0);
     Cfg.CutNoTxt:=(Pos('NOTXT',Tmp)>0);

     Cfg.LongDescStr:=GetParams(Conf.GetValue('longdescstr'));

     For I:=1 to Conf.CountKeywords('cutlines') do
         begin
              Temp:=Conf.GetValueN('cutlines',I);
              If (Temp=#0) or (Temp='') then Continue;
              Temp:=GetParams(Temp);
              CutLines.Insert(NewStr(Temp))
         end;

     Conf.Done;

     AddBackSlash(Cfg.InboundPath);
     AddBackSlash(Cfg.FileBasePath);
     If not (Cfg.BadFiles='') then AddBackSlash(Cfg.BadFiles);
     UpCaseStr(Cfg.InboundPath);
     UpCaseStr(Cfg.FileBasePath);

     If UseBinCfg then
     If not SaveBinaryConfiguration then
        begin
             WriteLn('Warning: can not save binary configuration');
             Warn:=True
        end
end;

procedure ReadConfiguration;
var
   Txt,Bin:LongInt;
   Dir:DirStr;
   Name:NameStr;
   Ext:ExtStr;

begin
     FSplit(ParamStr(0),Dir,Name,Ext);
     Cfg.LogName:=Dir+Name+'.LOG';
     TextCfgName:=Dir+Name+'.CFG';
     BinCfgName:=Dir+Name+'.BIN';

     If UseBinCfg then
        begin
             Txt:=GetFileDate(TextCfgName);
             Bin:=GetFileDate(BinCfgName)
        end;

     If not ((Txt=Bin) and UseBinCfg) then ReadTextConfiguration
     else If not ReadBinaryConfiguration then ReadTextConfiguration
end;

procedure DisplayPackersList;
var
   I:Integer;
   Arc:PArcInfoRec;

begin
     For I:=0 to Arcs.Count-1 do
         begin
              Arc:=Arcs.At(I);
              WriteLn(String(Arc^.ArcName^))
         end
end;

begin
     FilesIn:=0;
     FilesOk:=0;
     AreasCreated:=0;
     TotalSize:=0;

     StartTime:=GetUnixDateTime;

     Write(CrLf,'<<< ',PrgName,' >>>  Copyright (c) ');
     WriteLn('1999 DALLAS Software, Inc.',CrLf);

     InitMemory;
     DetectOsType;
     Randomize;

     CmdLine:=UpCaseStrF(GetCommandLine);

     If Pos('/?',CmdLine)>0 then
        begin
             WriteLn('Command line switches:',CrLf);
             WriteLn(' /DOS, /W32, /OS2 - Set OS type manually',CrLf);
             WriteLn(' /BC - use binary areas.cfg & ticproc.cfg');
             WriteLn(' /BP - use binary packers.cfg');
             Halt
        end;

     UseBinCfg:=(Pos('/BC',CmdLine)>0);
     UsePackersBin:=(Pos('/BP',CmdLine)>0);

     If Pos('/DOS',CmdLine)>0 then CurrOs:=tDOS
     else If Pos('/W32',CmdLine)>0 then CurrOs:=tW32
     else If Pos('/OS2',CmdLine)>0 then CurrOs:=tOS2;

     Case CurrOs of
      tDOS:OsStr:='DOS';
      tW32:OsStr:='W32';
      tOS2:OsStr:='OS2'
     end;

     ReadConfiguration;
     If Cfg.ExtractDiz then LoadPackersList
     else Arcs.Init(1,1);

     If Warn then WriteLn;

     If Pos('/D',CmdLine)>0 then
        begin
             WriteLn('Running under OS type: ',OsStr);
             WriteLn(CrLf,'Currently loaded packers:',CrLf);
             DisplayPackersList;
             Halt
        end;

     If not ExistDir(Cfg.InboundPath) then MakeDir(Cfg.InboundPath);
     If not ExistDir(Cfg.FileBasePath) then MakeDir(Cfg.FileBasePath);
     If not ExistDir(Cfg.BadFiles) then MakeDir(Cfg.BadFiles);

     With Cfg do
     Log:=New(PFileLogObj,Init('NNTIC',PrefToLog,LogName,LogBufSize));
     If Log=nil then
        begin
             WriteLn('Fatal: Can not initialize file log');
             Halt(1)
        end;

     If not (Log^.LogFileSize=0) then Log^.Write('','@');

     If Cfg.Announce then
        begin
             CreateText(Ann,Cfg.MsgTxt);

             If Cfg.AddMsgId then
                begin
                     Tmp:=Long2Hex(GetUnixDateTime);
                     LowCaseStr(Tmp);
                     WriteLn(Ann,#01'MSGID: '+Cfg.Address+' '+Tmp);
                end;

             If not (Cfg.Header='') then ProcessTpl(Cfg.Header,False)
        end;

     Log^.Write('Begin, '+PrgName,'+');

     MemAtStart:=MemAvail;
     WriteLn('Memory available: ',MemAtStart,' bytes');
     Log^.Write('Memory: '+Int2Str(MemAtStart,1)+' bytes','-');

     LoadAreaList;

     SearchForTic(Cfg.InboundPath);
     If AreasCreated>0 then
        begin
             StoreAreas(AreaList,TextAreaName);
             DeleteFile(BinAreaName)
        end;

     AreaList.Done;

     If FilesIn=0 then
        begin
             WriteLn('No TIC''s found');
             Log^.Write('No TIC''s found','#')
        end
     else
         begin
              Log^.Write('','@');
              WriteLn('Inbound files processed: ',FilesIn);
              Log^.Write('Files processed: '+Int2Str(FilesIn,1),'&');
              If AreasCreated>0 then
                 begin
                      WriteLn('New areas created: ',AreasCreated);
                      Log^.Write('New areas created: '+Int2Str(AreasCreated,1),'#')
                 end;
              If not (FilesIn=FilesOk) then
                 begin
                      WriteLn('Errors found: ',FilesIn-FilesOk);
                      Log^.Write('Errors found: '+Int2Str(FilesIn-FilesOk,1),'!')
                 end;

              EndTime:=GetUnixDateTime;
              If (AreasCreated>0) or not (FilesIn=FilesOk) then WriteLn;
              WriteLn('Total runtime: ',EndTime-StartTime,' seconds')
         end;

     If Cfg.Announce then
        begin
             If Cfg.Footer='' then WriteLn(Ann)
             else ProcessTpl(Cfg.Footer,True);

             WriteLn(Ann,'--- ',PrgName);
             If not (Cfg.Origin='') then
                begin
                     Write(Ann,' * Origin: ',Cfg.Origin);
                     WriteLn(Ann,' (',Cfg.Address,')')
                end;

             Close(Ann);

             If FilesOk=0 then DeleteFile(Cfg.MsgTxt)
        end;

     Arcs.Done;
     Log^.Write('End, '+PrgName,'+');
     Dispose(Log,Done);
     CutLines.Done;

     DoneMemory
end.
