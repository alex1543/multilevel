{$A+,B+,D+,E-,F-,G+,I+,L+,N+,O-,P+,Q-,R-,S+,T-,V+,X+,Y+}

unit Areas;

interface

uses Objects;

type
    PAreaRec=^TAreaRec;
    TAreaRec=record
      AreaTag:PString;
      AreaPath:PString;
      NewArea:Boolean
    end;

type
    PAreaCollection=^TAreaCollection;
    TAreaCollection=object(TSortedCollection)
      function KeyOf(Item:Pointer):Pointer;virtual;
      function Compare(Key1,Key2:Pointer):Integer;virtual;
      procedure FreeItem(Item:Pointer);virtual;
      function GetItem(var S:TStream):Pointer;virtual;
      procedure PutItem(var S:TStream;Item:Pointer);virtual;
      procedure AddArea(Area,Path:String;NewArea:Boolean);
      function GetAreaTag(I:Integer):String;
      function GetAreaPath(I:Integer):String;
      function GetNewArea(I:Integer):Boolean;
    end;

function NewAreaRec(Area,Path:String;NewArea:Boolean):Pointer;
procedure DisposeAreaRec(Ptr:Pointer);

function LoadAreas(var Areas:TAreaCollection;const FName:String):Boolean;
function StoreAreas(var Areas:TAreaCollection;const FName:String):Boolean;

implementation

uses Tools,Cases,FileOp;

function NewAreaRec(Area,Path:String;NewArea:Boolean):Pointer;
var
   Ptr:Pointer;

begin
     Ptr:=New(PAreaRec);
     PAreaRec(Ptr)^.AreaTag:=NewStr(Area);
     PAreaRec(Ptr)^.AreaPath:=NewStr(Path);
     PAreaRec(Ptr)^.NewArea:=NewArea;
     NewAreaRec:=Ptr
end;

procedure DisposeAreaRec(Ptr:Pointer);
begin
     DisposeStr(PAreaRec(Ptr)^.AreaTag);
     DisposeStr(PAreaRec(Ptr)^.AreaPath);
     Dispose(PAreaRec(Ptr))
end;

function TAreaCollection.KeyOf(Item:Pointer):Pointer;
begin
     KeyOf:=PAreaRec(Item)^.AreaTag
end;

function TAreaCollection.Compare(Key1,Key2:Pointer):Integer;
begin
     If PString(Key1)^=PString(Key2)^ then Compare:=0
     else If PString(Key1)^>PString(Key2)^ then Compare:=1
     else Compare:=-1
end;

procedure TAreaCollection.FreeItem(Item:Pointer);
begin
     DisposeAreaRec(Item)
end;

function TAreaCollection.GetItem(var S:TStream):Pointer;
var
   P:Pointer;
   Buf:String;
   Len:Byte;

begin
     P:=New(PAreaRec);
     S.Read(Len,SizeOf(Len));
     Buf[0]:=Chr(Len);
     S.Read(Buf[1],Len);
     PAreaRec(P)^.AreaTag:=NewStr(Buf);
     S.Read(Len,SizeOf(Len));
     Buf[0]:=Chr(Len);
     S.Read(Buf[1],Len);
     PAreaRec(P)^.AreaPath:=NewStr(Buf);
     S.Read(PAreaRec(P)^.NewArea,SizeOf(Boolean));
     GetItem:=P
end;

procedure TAreaCollection.PutItem(var S:TStream;Item:Pointer);
var
   Len:Byte;

begin
     Len:=Length(PAreaRec(Item)^.AreaTag^);
     S.Write(PAreaRec(Item)^.AreaTag^,Len+1);
     Len:=Length(PAreaRec(Item)^.AreaPath^);
     S.Write(PAreaRec(Item)^.AreaPath^,Len+1);
     S.Write(PAreaRec(Item)^.NewArea,SizeOf(Boolean))
end;

procedure TAreaCollection.AddArea(Area,Path:String;NewArea:Boolean);
begin
     Insert(NewAreaRec(Area,Path,NewArea))
end;

function TAreaCollection.GetAreaTag(I:Integer):String;
begin
     GetAreaTag:=PAreaRec(At(I))^.AreaTag^
end;

function TAreaCollection.GetAreaPath(I:Integer):String;
begin
     GetAreaPath:=PAreaRec(At(I))^.AreaPath^
end;

function TAreaCollection.GetNewArea(I:Integer):Boolean;
begin
     GetNewArea:=PAreaRec(At(I))^.NewArea
end;

function LoadAreas(var Areas:TAreaCollection;const FName:String):Boolean;
var
   Buf,AreaTag:String;
   AreaCfg:Text;
   I:Byte;

begin
     LoadAreas:=False;

     If not OpenText(AreaCfg,FName) then Exit;

     While not Eof(AreaCfg) do
           begin
                ReadLn(AreaCfg,Buf);
                If Buf='' then Continue;

                KillRems(Buf);
                TrimStr(Buf);
                If Buf='' then Continue;
                UpCaseStr(Buf);

                AreaTag:=ExtractWord(1,Buf,[#9,#32]);
                Delete(Buf,1,Length(AreaTag));
                TrimStr(Buf);

                Areas.AddArea(AreaTag,Buf,False)
           end;

     Close(AreaCfg);
     LoadAreas:=True
end;

function StoreAreas(var Areas:TAreaCollection;const FName:String):Boolean;
var
   AreaTag,Path:String;
   AreaCfg:Text;
   I:Integer;

begin
     StoreAreas:=False;

     If not AppendText(AreaCfg,FName) then Exit;

     For I:=0 to Areas.Count-1 do
         begin
              With Areas do
                   begin
                        If not GetNewArea(I) then Continue;
                        AreaTag:=GetAreaTag(I);
                        Write(AreaCfg,Justify(AreaTag,20));
                        Path:=GetAreaPath(I);
                        SmartCaseStr(Path,':.\-0123456789'#32);
                        WriteLn(AreaCfg,Path)
                   end
         end;

     Close(AreaCfg);
     StoreAreas:=True
end;

end.
