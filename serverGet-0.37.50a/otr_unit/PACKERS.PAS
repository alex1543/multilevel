{$A+,B+,D+,E-,F-,G+,I-,L+,N+,O-,P+,Q-,R-,S+,T-,V+,X+,Y+}

unit Packers;

interface

uses Dos,Objects,Config,Tools,Cases,HexNum,FileOp;

const
     IdDataMaxLen=9;
     OsStr:String[3]='DOS';

type
    IdDataType=array [1..IdDataMaxLen] of Byte;

type
    PArcInfoRec=^TArcInfoRec;
    TArcInfoRec=record
     ArcName:PString;
     IdOffset:LongInt;
     IdDataLen:Byte;
     IdData:IdDataType;
     Extension:String[3];
     AddCmd:PString;
     ExtrCmd:PString;
     ViewCmd:PString
    end;

type
    PArcTempRec=^TArcTempRec;
    TArcTempRec=record
     ArcName:String;
     IdOffset:LongInt;
     IdDataLen:Byte;
     IdData:IdDataType;
     Extension:String[3];
     AddCmd:String;
     ExtrCmd:String;
     ViewCmd:String
    end;


type
    PPackersCollection=^TPackersCollection;
    TPackersCollection=object(TSortedCollection)
      function KeyOf(Item:Pointer):Pointer;virtual;
      function Compare(Key1,Key2:Pointer):Integer;virtual;
      procedure FreeItem(Item:Pointer);virtual;
      function GetItem(var S:TStream):Pointer;virtual;
      procedure PutItem(var S:TStream;Item:Pointer);virtual;
      procedure AddPacker(Packer:TArcTempRec);
    end;

function NewPackerRec(Packer:TArcTempRec):Pointer;
procedure DisposePackerRec(Ptr:Pointer);

function CompareData(var Dat1,Dat2;const Size:Word):Boolean;

function LoadPackers(var Arcs:TPackersCollection;const FName:String):Boolean;
function FindArchiver(var Arcs:TPackersCollection;const Name:String):Pointer;

implementation

type
    Bytes=array [1..65520] of Byte;

function NewPackerRec(Packer:TArcTempRec):Pointer;
var
   Ptr:Pointer;

begin
     Ptr:=New(PArcInfoRec);
     PArcInfoRec(Ptr)^.ArcName:=NewStr(Packer.ArcName);
     PArcInfoRec(Ptr)^.IdOffset:=Packer.IdOffset;
     PArcInfoRec(Ptr)^.IdDataLen:=Packer.IdDataLen;
     PArcInfoRec(Ptr)^.IdData:=Packer.IdData;
     PArcInfoRec(Ptr)^.Extension:=Packer.Extension;
     PArcInfoRec(Ptr)^.AddCmd:=NewStr(Packer.AddCmd);
     PArcInfoRec(Ptr)^.ExtrCmd:=NewStr(Packer.ExtrCmd);
     PArcInfoRec(Ptr)^.ViewCmd:=NewStr(Packer.ViewCmd);
     NewPackerRec:=Ptr
end;

procedure DisposePackerRec(Ptr:Pointer);
begin
     DisposeStr(PArcInfoRec(Ptr)^.ViewCmd);
     DisposeStr(PArcInfoRec(Ptr)^.ExtrCmd);
     DisposeStr(PArcInfoRec(Ptr)^.AddCmd);
     DisposeStr(PArcInfoRec(Ptr)^.ArcName);
     Dispose(PArcInfoRec(Ptr))
end;

function TPackersCollection.KeyOf(Item:Pointer):Pointer;
begin
     KeyOf:=PArcInfoRec(Item)^.ArcName
end;

function TPackersCollection.Compare(Key1,Key2:Pointer):Integer;
begin
     If PString(Key1)^=PString(Key2)^ then Compare:=0
     else If PString(Key1)^>PString(Key2)^ then Compare:=1
     else Compare:=-1
end;

procedure TPackersCollection.FreeItem(Item:Pointer);
begin
     DisposePackerRec(Item)
end;

function TPackersCollection.GetItem(var S:TStream):Pointer;
var
   P:Pointer;
   Buf:String;
   Len:Byte;

begin
     P:=New(PArcInfoRec);

     S.Read(Len,SizeOf(Len));
     Buf[0]:=Chr(Len);
     S.Read(Buf[1],Len);
     PArcInfoRec(P)^.ArcName:=NewStr(Buf);

     S.Read(PArcInfoRec(P)^.IdOffset,SizeOf(LongInt));
     S.Read(PArcInfoRec(P)^.IdDataLen,SizeOf(Byte));
     S.Read(PArcInfoRec(P)^.IdData,SizeOf(IdDataType));

     S.Read(Len,SizeOf(Len));
     Buf[0]:=Chr(Len);
     S.Read(Buf[1],Len);
     PArcInfoRec(P)^.Extension:=Buf;

     S.Read(Len,SizeOf(Len));
     Buf[0]:=Chr(Len);
     S.Read(Buf[1],Len);
     PArcInfoRec(P)^.AddCmd:=NewStr(Buf);

     S.Read(Len,SizeOf(Len));
     Buf[0]:=Chr(Len);
     S.Read(Buf[1],Len);
     PArcInfoRec(P)^.ExtrCmd:=NewStr(Buf);

     S.Read(Len,SizeOf(Len));
     Buf[0]:=Chr(Len);
     S.Read(Buf[1],Len);
     PArcInfoRec(P)^.ViewCmd:=NewStr(Buf);

     GetItem:=P
end;

procedure TPackersCollection.PutItem(var S:TStream;Item:Pointer);
var
   Len:Byte;

begin
     Len:=Length(PArcInfoRec(Item)^.ArcName^);
     S.Write(PArcInfoRec(Item)^.ArcName^,Len+1);

     S.Write(PArcInfoRec(Item)^.IdOffset,SizeOf(LongInt));
     S.Write(PArcInfoRec(Item)^.IdDataLen,SizeOf(Byte));
     S.Write(PArcInfoRec(Item)^.IdData,SizeOf(IdDataType));

     Len:=Length(PArcInfoRec(Item)^.Extension);
     S.Write(PArcInfoRec(Item)^.Extension,Len+1);

     Len:=Length(PArcInfoRec(Item)^.AddCmd^);
     S.Write(PArcInfoRec(Item)^.AddCmd^,Len+1);
     Len:=Length(PArcInfoRec(Item)^.ExtrCmd^);
     S.Write(PArcInfoRec(Item)^.ExtrCmd^,Len+1);
     Len:=Length(PArcInfoRec(Item)^.ViewCmd^);
     S.Write(PArcInfoRec(Item)^.ViewCmd^,Len+1)
end;

procedure TPackersCollection.AddPacker(Packer:TArcTempRec);
begin
     Insert(NewPackerRec(Packer))
end;

function CompareData(var Dat1,Dat2;const Size:Word):Boolean;assembler;
asm
        cld
        push  ds
        lds   si,Dat1
        les   di,Dat2
        mov   cx,Size
        repe  cmpsb
        jnz   @@1
        mov   al,01h
        jmp   @@2
@@1:
        xor   al,al
@@2:
        pop   ds
end;

function LoadPackers(var Arcs:TPackersCollection;const FName:String):Boolean;
var
   K:Integer;
   Conf:TConfCollection;
   ArcExp,Tmp:String;
   I:Byte;

procedure AddPacker(const ArcName:String);
var
   Found:Boolean;
   TempArc:TArcTempRec;
   Ident,Tmp:String;
   I,Code:Integer;

begin
     Found:=False;
     Tmp:=ArcName+'.'+OsStr;
     UpCaseStr(Tmp);

     For I:=1 to Conf.CountKeywords('name') do
         begin
              Ident:=Conf.GetValueN('name',I);
              UpCaseStr(Ident);
              If Ident=Tmp then
                 begin
                      Found:=True;
                      Break
                 end
         end;

     If not Found then
        begin
             Tmp:=ArcName+'.DOS';
             UpCaseStr(Tmp);

             For I:=1 to Conf.CountKeywords('name') do
                 begin
                      Ident:=Conf.GetValueN('name',I);
                      UpCaseStr(Ident);
                      If Ident=Tmp then
                         begin
                              Found:=True;
                              Break
                         end
                 end
        end;

     If not Found then Exit;

     TempArc.ArcName:=Tmp;
     TempArc.Extension:=Conf.GetValueN('extension',I);
     TempArc.AddCmd:=Conf.GetValueN('add',I);
     TempArc.ExtrCmd:=Conf.GetValueN('extract',I);
     TempArc.ViewCmd:=Conf.GetValueN('view',I);
     Ident:=Conf.GetValueN('ident',I);

     I:=Pos(',',Ident);
     If I=0 then Exit;

     Tmp:=Copy(Ident,1,I-1);
     Delete(Ident,1,I);
     TrimStr(Ident);
     TrimStr(Tmp);

     If Tmp[1]='-' then Insert('$',Tmp,2)
     else Tmp:='$'+Tmp;

     Val(Tmp,TempArc.IdOffset,Code);
     If not (Code=0) then Exit;

     TempArc.IdDataLen:=Length(Ident) div 2;
     If TempArc.IdDataLen>IdDataMaxLen then Exit;

     Hex2Data(TempArc.IdData,Ident);
     If HexError then Exit;

     Arcs.AddPacker(TempArc)
end;

begin
     LoadPackers:=False;

     Conf.Init(1,1);
     If not Conf.ReadFile(FName) then
        begin
             Conf.Done;
             Exit
        end;

     K:=Conf.CountKeywords('name');
     If not (K=Conf.CountKeywords('ident')) then Exit;
     If not (K=Conf.CountKeywords('extension')) then Exit;
     If not (K=Conf.CountKeywords('add')) then Exit;
     If not (K=Conf.CountKeywords('extract')) then Exit;
     If not (K=Conf.CountKeywords('view')) then Exit;

     For K:=1 to Conf.CountKeywords('export') do
         begin
              ArcExp:=Conf.GetValueN('export',K);
              If ArcExp=#0 then Continue;
              UpCaseStr(ArcExp);
              TrimStr(ArcExp);

              While not (ArcExp='') do
                    begin
                         I:=Pos(',',ArcExp);
                         If I=0 then I:=$FF;
                         Tmp:=Copy(ArcExp,1,I-1);
                         Delete(ArcExp,1,I);
                         TrimStr(ArcExp);
                         TrimStr(Tmp);
                         AddPacker(Tmp)
                    end
           end;

     Conf.Done;
     LoadPackers:=True
end;

function FindArchiver(var Arcs:TPackersCollection;const Name:String):Pointer;
var
   I:Integer;
   ArcRec:PArcInfoRec;
   TempId:IdDataType;
   TempExt:String[4];
   Tmp:Byte;
   F:File;

begin
     FindArchiver:=nil;
     TempExt:=GetFileExt(Name);
     Delete(TempExt,1,1);

     If not OpenFile(F,Name,fmReadOnly+fmDenyWrite) then Exit;

     For I:=0 to Arcs.Count-1 do { Pass 1 - by extension }
         begin
              ArcRec:=Arcs.At(I);
              If not (ArcRec^.Extension=TempExt) then Continue;

              If not (ArcRec^.IdOffset<0) then Seek(F,ArcRec^.IdOffset)
              else Seek(F,FileSize(F)-ArcRec^.IdOffset);

              BlockRead(F,TempId,SizeOf(TempId));
              If not (IOResult=0) then Continue;
              Tmp:=ArcRec^.IdDataLen;

              If CompareData(TempId,ArcRec^.IdData,Tmp) then
                 begin
                      Close(F);
                      FindArchiver:=ArcRec;
                      Exit
                 end
         end;

     For I:=0 to Arcs.Count-1 do { Pass 2 - by ident }
         begin
              ArcRec:=Arcs.At(I);
              If not (ArcRec^.IdOffset<0) then Seek(F,ArcRec^.IdOffset)
              else Seek(F,FileSize(F)-ArcRec^.IdOffset);

              BlockRead(F,TempId,SizeOf(TempId));
              If not (IOResult=0) then Continue;
              Tmp:=ArcRec^.IdDataLen;

              If CompareData(TempId,ArcRec^.IdData,Tmp) then
                 begin
                      Close(F);
                      FindArchiver:=ArcRec;
                      Exit
                 end
         end;

     Close(F)
end;

end.
