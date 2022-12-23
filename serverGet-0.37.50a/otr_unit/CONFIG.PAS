{$A+,B+,D+,E-,F-,G+,I+,L+,N+,O-,P+,Q-,R-,S+,T-,V+,X+,Y+}

unit Config; { revision 14.03.1999 }

interface

uses Objects,Memory,Tools,Cases,FileOp;

const
     Delims=[#9,#32];
     ShowWarnings:Boolean=False;

type
    PConfRec=^TConfRec;
    TConfRec=record
     Keyword,Value:PString
    end;

type
    PConfCollection=^TConfCollection;
    TConfCollection=object(TSortedCollection)
     constructor Init(ALimit,ADelta:Integer);
     procedure Insert(Item: Pointer);virtual;
     procedure AddItem(const Keyword,Value:String);virtual;
     procedure FreeItem(Item:Pointer);virtual;
     procedure SetDefValue(Keyword:String;const DefValue:String);
     procedure SetValue(Keyword:String;const NewValue:String);
     function GetValue(Keyword:String):String;
     function GetValueN(Keyword:String;Num:Integer):String;
     function CountKeywords(Keyword:String):Integer;
     function Compare(Key1,Key2:Pointer):Integer;virtual;
     function KeyOf(Item:Pointer):Pointer;virtual;
     function ReadFile(const FileName:String):Boolean;
    end;

function NewConfRec(const Keyword,Value:String):Pointer;
procedure DisposeConfRec(var Item:Pointer);

function Str2Bool(const St:String):Boolean;

implementation

function NewConfRec(const Keyword,Value:String):Pointer;
var
   P:PConfRec;

begin
     P:=MemAlloc(SizeOf(P^));
     P^.Keyword:=NewStr(UpCaseStrF(Keyword));
     P^.Value:=NewStr(Value);
     NewConfRec:=P
end;

procedure DisposeConfRec(var Item:Pointer);
begin
     If Item=nil then Exit;

     With PConfRec(Item)^ do
          begin
               DisposeStr(Value);
               DisposeStr(Keyword)
          end;

     FreeMem(Item,SizeOf(PConfRec))
end;

constructor TConfCollection.Init(ALimit,ADelta:Integer);
begin
     inherited Init(ALimit,ADelta);
     Duplicates:=True
end;

procedure TConfCollection.Insert(Item:Pointer);
var
   I:Integer;

begin
     If Duplicates then
        begin
             If Search(KeyOf(Item),I) then
                begin
                     {$B-}
                     While (I<Count) and
                     (Compare(KeyOf(At(I)),KeyOf(Item))=0) do Inc(I);
                     {$B+}
                end;

             AtInsert(I,Item)
        end
     else
         begin
              If not Search(KeyOf(Item),I) then AtInsert(I,Item)
         end
end;

procedure TConfCollection.AddItem(const Keyword,Value:String);
begin
     Insert(NewConfRec(Keyword,Value))
end;

procedure TConfCollection.FreeItem(Item:Pointer);
begin
     DisposeConfRec(Item)
end;

procedure TConfCollection.SetDefValue(Keyword:String;const DefValue:String);
var
   I:Integer;
   Item:PConfRec;

begin
     UpCaseStr(Keyword);
     If not Search(@Keyword,I) then AddItem(Keyword,DefValue)
end;

procedure TConfCollection.SetValue(Keyword:String;const NewValue:String);
var
   I:Integer;
   Item:PConfRec;

begin
     UpCaseStr(Keyword);
     If Search(@Keyword,I) then
        begin
             Item:=At(I);
             If Assigned(Item^.Value) then DisposeStr(Item^.Value);
             Item^.Value:=NewStr(NewValue)
        end
     else AddItem(Keyword,NewValue)
end;

function TConfCollection.GetValue(Keyword:String):String;
var
   I:Integer;
   Item:PConfRec;

begin
     GetValue:=#0;

     UpCaseStr(Keyword);
     If not Search(@Keyword,I) then Exit;

     Item:=At(I);
     If Assigned(Item^.Value) then GetValue:=Item^.Value^
     else GetValue:=''
end;

function TConfCollection.GetValueN(Keyword:String;Num:Integer):String;
var
   I:Integer;
   Item:PConfRec;

begin
     GetValueN:=#0;

     UpCaseStr(Keyword);
     If not Search(@Keyword,I) then Exit;

     I:=I+Num-1;
     If (I>Count) or (I<0) then Exit;

     Item:=At(I);
     If not (Item^.Keyword^=Keyword) then Exit;
     If Assigned(Item^.Value) then GetValueN:=Item^.Value^
     else GetValueN:=''
end;

function TConfCollection.CountKeywords(Keyword:String):Integer;
var
   I,L:Integer;

begin
     CountKeywords:=0;
     UpCaseStr(Keyword);
     If not Search(@Keyword,I) then Exit;

     L:=I;

     {$B-}
     While (L<Count) and
     (Compare(KeyOf(At(L)),@Keyword)=0) do Inc(L);
     {$B+}

     CountKeywords:=L-I
end;

function TConfCollection.Compare(Key1,Key2:Pointer):Integer;
begin
     If PString(Key1)^=PString(Key2)^ then Compare:=0
     else If PString(Key1)^>PString(Key2)^ then Compare:=1
     else Compare:=-1
end;

function TConfCollection.KeyOf(Item:Pointer):Pointer;
begin
     KeyOf:=PConfRec(Item)^.Keyword
end;

function TConfCollection.ReadFile(const FileName:String):Boolean;
var
   F:Text;
   Buf:String;
   Keyword:String[25];
   I:Byte;

begin
     ReadFile:=False;

     {$I-}
     Assign(F,FileName);
     Reset(F);
     If not (IOResult=0) then Exit;
     {$I+}

     While not Eof(F) do
           begin
                ReadLn(F,Buf);

                KillRems(Buf);
                TrimStr(Buf);
                If Buf='' then Continue;

                I:=WordPosition(2,Buf,Delims);
                Keyword:=ExtractWord(1,Buf,Delims);
                If I>0 then
                   begin
                        System.Delete(Buf,1,I-1);
                        TrimStr(Buf)
                   end
                else Buf:='';

                UpCaseStr(Keyword);

                If Keyword='INCLUDE' then
                   begin
                        If (not ReadFile(Buf)) and ShowWarnings then
                           begin
                                Write('Error processing file ');
                                WriteLn(Buf)
                           end;

                        Continue
                   end;

                AddItem(Keyword,Buf)
           end;

     Close(F);
     ReadFile:=True
end;

function Str2Bool(const St:String):Boolean;
var
   Temp:String[3];

begin
     Str2Bool:=False;
     Temp:=UpCaseStrF(Copy(St,1,3));
     If (Temp='YES') or (Temp='ON') or
     (Temp='1') then Str2Bool:=True
end;

end.
