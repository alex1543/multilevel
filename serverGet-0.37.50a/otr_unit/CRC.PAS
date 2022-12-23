{$A+,B-,D-,E-,F-,I-,L-,N-,O-,R-,S-,V+}

unit Crc;

interface

{
 This function computes the CRC used by PKZIP and Forsberg's
 ZModem. Initialize with high-values ($FFFFFFFF), and finish by
 inverting all bits (not).
}

function UpdateCrc32(Init:LongInt;var Buf;Len:Word):LongInt;
function CalcCrc32(const FileName:String;var Crc32:LongInt):Boolean;

implementation

uses FileOp,Memory;

{$L CRC32.OBJ }

function UpdateCrc32(Init:LongInt;var Buf;Len:Word):Longint;external;

function CalcCrc32(const FileName:String;var Crc32:LongInt):Boolean;
var
   F:File;
   Buffer:Pointer;
   I,Result,BufSize:Word;

begin
     Buffer:=nil;
     Crc32:=$FFFFFFFF;
     CalcCrc32:=False;

     If MaxAvail>FileBufSize then BufSize:=FileBufSize
     else If MaxAvail<1024 then Exit else BufSize:=MaxAvail;

     Buffer:=MemAlloc(BufSize);
     If Buffer=nil then Exit;

     If not OpenFile(F,FileName,fmReadOnly+fmDenyWrite) then Exit;

     While not Eof(F) do
           begin
                BlockRead(F,Buffer^,BufSize,Result);
                Crc32:=UpdateCrc32(Crc32,Buffer^,Result)
           end;

     Close(F);
     FreeMem(Buffer,BufSize);

     Crc32:=not Crc32;
     CalcCrc32:=True
end;

end.
