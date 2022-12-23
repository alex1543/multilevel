{$A+,B+,D+,E-,F-,G+,I-,L+,N+,O-,P+,Q-,R-,S+,T-,V+,X+,Y+}

unit Fido;

interface

type
    PFidoAddress=^TFidoAddress;
    TFidoAddress=record
    Zone,Net,Node,Point:Word
    end;

procedure StrToAddr(St:String;var Addr:TFidoAddress);
procedure StrToAddr2(St:String;var Def,Addr:TFidoAddress);

function AddrToStr(const Addr:TFidoAddress;WithZeroPnt:Boolean):String;

implementation

uses Tools;

procedure StrToAddr(St:String;var Addr:TFidoAddress);
var
   I:Byte;
   Tmp:Integer;

begin
     FillChar(Addr,SizeOf(Addr),0);

     TrimStr(St);
     I:=Pos('@',St);
     If not (I=0) then Delete(St,I,$FF);

     I:=Pos(':',St);
     If I=0 then Exit;
     Val(Copy(St,1,I-1),Addr.Zone,Tmp);
     If not (Tmp=0) then Addr.Zone:=0;
     Delete(St,1,I);

     I:=Pos('/',St);
     If I=0 then Exit;
     Val(Copy(St,1,I-1),Addr.Net,Tmp);
     If not (Tmp=0) then Addr.Net:=0;
     Delete(St,1,I);

     I:=Pos('.',St);

     If I=0 then
        begin
             Val(St,Addr.Node,Tmp);
             If not (Tmp=0) then Addr.Node:=0;
             Addr.Point:=0;
             Exit
        end;

     Val(Copy(St,1,I-1),Addr.Node,Tmp);
     If not (Tmp=0) then Addr.Node:=0;

     Delete(St,1,I);
     Val(St,Addr.Point,Tmp);
     If not (Tmp=0) then Addr.Point:=0
end;

procedure StrToAddr2(St:String;var Def,Addr:TFidoAddress);
var
   I:Byte;
   Tmp:Integer;

begin
     TrimStr(St);
     Addr:=Def;

     I:=Pos(':',St);
     If not (I=0) then
        begin
             Val(Copy(St,1,I-1),Addr.Zone,Tmp);
             If not (Tmp=0) then Addr.Zone:=Def.Zone;
             Delete(St,1,I)
        end;

     I:=Pos('/',St);
     If not (I=0) then
        begin
             Val(Copy(St,1,I-1),Addr.Net,Tmp);
             If not (Tmp=0) then Addr.Net:=Def.Net;
             Delete(St,1,I)
        end;

     I:=Pos('.',St);

     If I=0 then
        begin
             Val(St,Addr.Node,Tmp);
             If not (Tmp=0) then Addr.Node:=Def.Node;
             Addr.Point:=0;
             Exit
        end;

     Val(Copy(St,1,I-1),Addr.Node,Tmp);
     If not (Tmp=0) then Addr.Node:=Def.Node;

     Delete(St,1,I);
     Val(St,Addr.Point,Tmp);
     If not (Tmp=0) then Addr.Point:=0
end;

function AddrToStr(const Addr:TFidoAddress;WithZeroPnt:Boolean):String;
var
   Buf:String[6];

begin
     Buf:='.'+Int2Str2(Addr.Point);
     If (Addr.Point=0) and (not WithZeroPnt) then Buf:='';
     AddrToStr:=Int2Str2(Addr.Zone)+':'+Int2Str2(Addr.Net)+'/'+
     Int2Str2(Addr.Node)+Buf
end;

end.
