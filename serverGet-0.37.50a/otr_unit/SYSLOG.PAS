{$A+,B+,D-,E-,F-,G+,I+,L+,N+,O-,P+,Q-,R-,S+,T-,V+,X+,Y+}

unit SysLog; { revision 10.02.1998 }

interface

uses Objects,Memory;

{===========================================================================}

type
    PLogObj=^TLogObj;
    TLogObj=object(TObject)
    private
     PrgId:PString;
     Prefixes:PString;
     LastMsg:String;
     LastPref:Char;
    public
     constructor Init(const Id,Pref:String);
     procedure Write(const Msg:String;Pref:Char);virtual;
     function LogLastPref:Char;
     function LogIsPref(Pref:Char):Boolean;
     destructor Done;virtual;
    end;

{===========================================================================}

type
    PConLogObj=^TConLogObj;
    TConLogObj=object(TLogObj)
     procedure Write(const Msg:String;Pref:Char);virtual;
    end;

{===========================================================================}

type
    PFileLogObj=^TFileLogObj;
    TFileLogObj=object(TLogObj)
    private
     Log:Text;
     LogBuf:PChar;
     LogBufSize:Word;
     LogBufThr:Word;
     FileName:PString;
    public
     constructor Init(const Id,Pref,FName:String;Size:Word);
     procedure Write(const Msg:String;Pref:Char);virtual;
     procedure FlushBuffer; { Flushes log buffer }
     function LogBufPos:Word; { Returns size of data in buffer }
     function LogFileSize:LongInt; { Returns size of log file }
     destructor Done;virtual;
    end;

{===========================================================================}

implementation

uses Crt,Strings,Dates,FileOp;

{ TLogObj }

constructor TLogObj.Init(const Id,Pref:String);
begin
     inherited Init;
     PrgId:=NewStr(Id);
     Prefixes:=NewStr(Pref);
     LastPref:=#0;
     LastMsg:=#0
end;

procedure TLogObj.Write(const Msg:String;Pref:Char);
begin
     LastPref:=Pref;

     If Assigned(Prefixes) then
     If Pos(Pref,Prefixes^)=0 then Exit;

     If Msg=LastMsg then Exit
     else LastMsg:=Msg
end;

function TLogObj.LogLastPref:Char;
begin
     LogLastPref:=LastPref
end;

function TLogObj.LogIsPref(Pref:Char):Boolean;
begin
     LogIsPref:=False;
     If Assigned(Prefixes) then
     If Pos(Pref,Prefixes^)>0 then LogIsPref:=True
end;

destructor TLogObj.Done;
begin
     DisposeStr(PrgId);
     DisposeStr(Prefixes)
end;

{ TConLogObj }

procedure TConLogObj.Write(const Msg:String;Pref:Char);
begin
     LastPref:=Pref;

     If Assigned(Prefixes) then
     If Pos(Pref,Prefixes^)=0 then Exit;

     If Msg=LastMsg then Exit
     else LastMsg:=Msg;

     If not (WhereX=1) then System.WriteLn;
     System.Write(Pref,#32,TimeStr,#32);
     If Assigned(PrgId) then System.Write(PrgId^,#32);
     System.WriteLn(Msg)
end;

{ TFileLogObj }

constructor TFileLogObj.Init(const Id,Pref,FName:String;Size:Word);
begin
     inherited Init(Id,Pref);

     LogBufSize:=Size;
     If Size<300 then LogBufSize:=300;
     If Size=0 then LogBufThr:=0
     else LogBufThr:=Size-1;

     LogBuf:=MemAlloc(LogBufSize);
     If LogBuf=nil then Fail;
     LogBuf[0]:=#0;

     FileName:=NewStr(FName);
     If not AppendText(Log,FName) then
        begin
             If not CreateText(Log,FName) then
                begin
                     DisposeStr(FileName);
                     FreeMem(LogBuf,LogBufSize);
                     Fail
                end
        end;

     Close(Log)
end;

procedure TFileLogObj.Write(const Msg:String;Pref:Char);
var
   Buf:String;

begin
     LastPref:=Pref;

     If Assigned(Prefixes) then
     If Pos(Pref,Prefixes^)=0 then Exit;

     If Msg=LastMsg then Exit
     else LastMsg:=Msg;

     Buf:=Pref+#32+DateTimeStr+#32;
     If Assigned(PrgId) then Buf:=Buf+PrgId^;
     Buf:=Buf+#32+Msg+#13#10#0;

     If StrLen(LogBuf)+Length(Buf)>LogBufThr then FlushBuffer;
     StrLCat(LogBuf,@Buf[1],LogBufSize-1);
     If LogBufThr=0 then FlushBuffer
end;

procedure TFileLogObj.FlushBuffer;
var
   Cnt:Byte;
   IORes:Integer;

begin
     Cnt:=0;

     {$IFOPT I+}
     {$DEFINE I_DISABLED}
     {$I-}
     {$ENDIF}

     Repeat

     Append(Log);
     IORes:=IOResult;

     If IORes=0 then Break;

     If IORes=5 then
        begin
             Delay(500);
             Inc(Cnt);
        end
     else RunError(IORes);

     Until Cnt=20;

     {$IFDEF I_DISABLED}
     {$UNDEF I_DISABLED}
     {$I+}
     {$ENDIF}

     If Cnt=20 then RunError(IORes);

     System.Write(Log,LogBuf);
     Close(Log);
     LogBuf[0]:=#0
end;

function TFileLogObj.LogBufPos:Word;
begin
     LogBufPos:=StrLen(LogBuf)
end;

function TFileLogObj.LogFileSize:LongInt;
begin
     LogFileSize:=GetFileSize(FileName^)
end;

destructor TFileLogObj.Done;
begin
     If StrLen(LogBuf)>0 then FlushBuffer;
     If GetFileSize(FileName^)=0 then DeleteFile(FileName^);

     DisposeStr(FileName);
     FreeMem(LogBuf,LogBufSize);

     inherited Done
end;

end.
