{
===============================================================================

 mhltvi.inc - part of skMHL Library by sergey korowkin (2:6033/27@fidonet),
              port to *nix based OS by Andrew V. Sichevoi (2:6028/9@fidonet)

 Include file
 Version : v0.1beta24-avs2
 License : GNU GPL v2.0
 Compiler: FreePascal Compiler v1.0.10

=============================================================================== 
}

{ TV objects interface (VP/BP) }

const
 BlockSize      = 1024 * 8;

type
 PMessageBaseFileStream = ^TMessageBaseFileStream;
 TMessageBaseFileStream = object(TMessageBaseStream)
  Link: PStream;

  constructor Init(const AFileName: String; const AMode: Longint);
  destructor Done; virtual;

  procedure Read(var Buf; Count: Word); virtual;
  procedure Write(var Buf; Count: Word); virtual;
  procedure Seek(Position: Longint); virtual;
  function GetPos: Longint; virtual;
  function GetSize: Longint; virtual;
  procedure Flush; virtual;
  procedure Truncate; virtual;
  procedure Reset; virtual;
 private
  procedure UpdateStatus;
 end;

 PMessageBaseFileFind = ^TMessageBaseFileFind;
 TMessageBaseFileFind = object(TMessageBaseFind)
  Sr: SearchRec;
  function StartSearch(const Mask: String; Attributes: Longint): Boolean; virtual;
  function NextSearch: Boolean; virtual;
  procedure StopSearch; virtual;
 private
  procedure Fresh;
 end;

 PMessageBaseMemoryBlock = ^TMessageBaseMemoryBlock;
 TMessageBaseMemoryBlock = record
  Size: Longint;
  Block: Pointer;
  Next: PMessageBaseMemoryBlock;
 end;

 PMessageBaseRamBuffer = ^TMessageBaseRamBuffer;
 TMessageBaseRamBuffer = array[0..65521] of byte;

 PMessageBaseRamBlock = ^TMessageBaseRamBlock;
 TMessageBaseRamBlock = record
  Buffer: PMessageBaseRamBuffer;
  Size: Longint;
  Next: PMessageBaseRamBlock;
 end;

 PMessageBaseRamStream = ^TMessageBaseRamStream;
 TMessageBaseRamStream = object(TMessageBaseStream)
  First: PMessageBaseRamBlock;
  CurPos, CurSize, VirtualSize: Longint;
  constructor Init;
  destructor Done; virtual;
  function GetPos: Longint; virtual;
  function GetSize: Longint; virtual;
  procedure Read(var Buf; Count: Word); virtual;
  procedure Seek(Pos: Longint); virtual;
  procedure Truncate; virtual;
  procedure Write(var Buf; Count: Word); virtual;
  procedure CopyFrom(var S: TMessageBaseStream; Count: Longint); virtual;
  procedure Flush; virtual;
 private
  procedure SetSize(NewSize: Longint);
  procedure GetPosEx(Position: Longint; var Block: PMessageBaseRamBlock; var Offset, Remain: Longint);
 end;
