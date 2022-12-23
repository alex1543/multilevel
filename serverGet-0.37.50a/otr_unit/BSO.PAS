{$A+,B+,D+,E-,F-,G+,I-,L+,N+,O-,P-,Q-,R-,S-,T-,V-,X+,Y+}

unit BSO;

interface

uses Objects,Dos,FileOp,HexNum,Fido,Misc;

var
   OutboundPath:String;
   LocalZone:Word;

type
    TFilesList=object(TCollection)
     procedure AddItem(const St:String);
     procedure FreeItem(Item:Pointer);virtual;
    end;

procedure GetFloName(const Adr:TFidoAddress;var OutDir,FloName:String);

function CheckForBusy(const Adr:TFidoAddress):Boolean;
procedure CreateBusyFlag(const Adr:TFidoAddress);
procedure RemoveBusyFlag(const Adr:TFidoAddress);

function MakePoll(const Adr:TFidoAddress;Flavor:Char):Boolean;
function AttachFiles(const Adr:TFidoAddress;List:PCollection;Flavor:Char):Boolean;

implementation

procedure TFilesList.AddItem(const St:String);
begin
     Insert(NewStr(St))
end;

procedure TFilesList.FreeItem(Item:Pointer);
begin
     DisposeStr(Item)
end;

procedure GetFloName(const Adr:TFidoAddress;var OutDir,FloName:String);
begin
     OutDir:=OutboundPath;

     If not (Adr.Zone=LocalZone) then
        begin
             DelBackSlash(OutDir);
             OutDir:=OutDir+'.'+Copy(Word2Hex(Adr.Zone),2,3)
        end;

     AddBackSlash(OutDir);

     If not ExistDir(OutDir) then MakeDir(OutDir);

     FloName:=Word2Hex(Adr.Net)+Word2Hex(Adr.Node);
     If not (Adr.Point=0) then
        begin
             OutDir:=OutDir+FloName+'.PNT';
             AddBackSlash(OutDir);
             If not ExistDir(OutDir) then MakeDir(OutDir);
             FloName:='0000'+Word2Hex(Adr.Point)
        end
end;

function CheckForBusy(const Adr:TFidoAddress):Boolean;
var
   OutDir:DirStr;
   LoName:NameStr;

begin
     GetFloName(Adr,OutDir,LoName);
     CheckForBusy:=ExistFileM(OutDir+LoName+'.?sy')
end;

procedure CreateBusyFlag(const Adr:TFidoAddress);
var
   OutDir:DirStr;
   LoName:NameStr;

begin
     GetFloName(Adr,OutDir,LoName);
     CreateZeroFile(OutDir+LoName+'.bsy')
end;

procedure RemoveBusyFlag(const Adr:TFidoAddress);
var
   OutDir:DirStr;
   LoName:NameStr;

begin
     GetFloName(Adr,OutDir,LoName);
     DeleteFile(OutDir+LoName+'.bsy')
end;

function MakePoll(const Adr:TFidoAddress;Flavor:Char):Boolean;
var
   OutDir:DirStr;
   LoName:FNameStr;

begin
     MakePoll:=False;
     GetFloName(Adr,OutDir,LoName);
     LoName:=OutDir+LoName;

     If ExistFileM(LoName+'.?sy') then Exit;
     CreateZeroFile(LoName+'.bsy');

     If not ExistFile(LoName+'.'+Flavor+'lo') then
     CreateZeroFile(LoName+'.'+Flavor+'lo');

     DeleteFile(LoName+'.bsy');
     MakePoll:=True
end;

function AttachFiles(const Adr:TFidoAddress;List:PCollection;Flavor:Char):Boolean;
var
   OutDir:DirStr;
   LoName:FNameStr;
   I:Integer;
   F:Text;

begin
     AttachFiles:=False;
     GetFloName(Adr,OutDir,LoName);
     LoName:=OutDir+LoName;

     If ExistFileM(LoName+'.?sy') then Exit;
     CreateZeroFile(LoName+'.bsy');

     If not ExistFile(LoName+'.'+Flavor+'lo') then
        begin
             If not CreateText(F,LoName+'.'+Flavor+'lo') then
                begin
                     DeleteFile(LoName+'.bsy');
                     Exit
                end
        end
     else
         begin
              If not AppendText(F,LoName+'.'+Flavor+'lo') then
                 begin
                      DeleteFile(LoName+'.bsy');
                      Exit
                 end
         end;

     For I:=0 to List^.Count-1 do WriteLn(F,PString(List^.At(I))^);

     Close(F);
     DeleteFile(LoName+'.bsy');
     AttachFiles:=True
end;

end.
