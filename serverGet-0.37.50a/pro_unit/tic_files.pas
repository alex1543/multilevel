{$I-}
unit tic_files; { revision 11.01.1999 }

interface

uses Dos;

const
     fmReadOnly=$00;
     fmWriteOnly=$01;
     fmReadWrite=$02;
     fmDenyAll=$10;
     fmDenyWrite=$20;
     fmDenyRead=$30;
     fmDenyNone=$40;
     fmNoInherit=$80;

const
     FileBufSize:Word=32768; { Size of buffer for file operations }

{===========================================================================}

procedure AddBackSlash(var St:String);
{ Add trailing '\' to path if not exist }

function AddBackSlashF(const St:String):String;
{ Add trailing '\' to path if not exist }

procedure DelBackSlash(var St:String);
{ Delete trailing '\' from path if exist }

function DelBackSlashF(const St:String):String;
{ Delete trailing '\' from path if exist }

{===========================================================================}

function ExistDir(const DirName:String):Boolean;
{ Return True if specified directory exist }

function ExistFile(const FileName:String):Boolean;
{ Return True if specified file exist }

function ExistFileM(const FileName:String):Boolean;
{ Return True if specified file exist, support file masks }

{===========================================================================}

function MakeDir(Path:String):Boolean;
{ Make dir with full path, return False on error }

function MakeDir2(Dir:String):Boolean;
{ Make dir (only one), return False on error }

{===========================================================================}

function OpenFile(var F:File;const Name:String;const Mode:Byte):Boolean;
{ Open untyped file with RecSize=1, returns False on error }

function OpenText(var F:Text;const Name:String):Boolean;
{ Open text file, returns False on error, True otherwise }

function CreateFile(var F:File;const Name:String):Boolean;
{ Create untyped file with RecSize=1, returns False on error }

function CreateText(var F:Text;const Name:String):Boolean;
{ Create text file, returns False on error, True otherwise }

function AppendText(var F:Text;const Name:String):Boolean;
{ Open text file for append, returns False on error, True otherwise }

{===========================================================================}

function RenameFile(const CurrName,NewName:String):Boolean;
{ Rename file (files must be on one logical disk) }

function DeleteFile(const FileName:String):Boolean;
{ Delete file, return False on error }

function DeleteMaskFile(Dir:String;const Mask:String):Boolean;
{ Delete files by mask, return False on error }

function CopyFile(const Src,Dest:String):Boolean;
{ Copy file, return False on error }

function CopyMaskFile(SrcDir,DestDir:String;const Mask:String):Boolean;
{ Copy files by mask, return False on error }

function MoveFile(const Src,Dest:String):Boolean;
{ Move (not Rename!) file, return False on error }

function MoveMaskFile(SrcDir,DestDir:String;const Mask:String):Boolean;
{ Move files by mask, return False on error }

{===========================================================================}

function GetFileSize(const FileName:String):LongInt;
{ Return size of file, $FFFFFFFF on error }

function GetFileDate(const FileName:String):LongInt;
{ Return date of file, 0 on error }

{===========================================================================}

function GetFileDir(const FileName:String):String;
{ Return directory of file }

function GetFileDirName(const FileName:String):String;
{ Return directory and name of file }

function GetFileName(const FileName:String):String;
{ Return name of file (without extension) }

function GetFileNameExt(const FileName:String):String;
{ Return name & extension of file }

function GetFileExt(const FileName:String):String;
{ Return extension of file }

function CreateZeroFile(const FileName:String) : boolean;
{===========================================================================}

implementation


function CreateZeroFile(const FileName:String) : boolean;
var
   F:File;

begin
     Assign(F,FileName);
     ReWrite(F);
     Close(F);
     CreateZeroFile := (IOResult=0); 
end;


procedure AddBackSlash(var St:String);
begin
     If not (St[Length(St)]='\') then St:=St+'\'
end;

function AddBackSlashF(const St:String):String;
begin
     If not (St[Length(St)]='\') then AddBackSlashF:=St+'\'
end;

procedure DelBackSlash(var St:String);
begin
     If St[Length(St)]='\' then St[0]:=Chr(Length(St)-1)
end;

function DelBackSlashF(const St:String):String;
begin
     If St[Length(St)]='\' then DelBackSlashF:=Copy(St,1,Length(St)-1)
end;

function ExistDir(const DirName:String):Boolean;
var
   Attr:Word;
   F:File;

begin
     Assign(F,DelBackSlashF(DirName));
     GetFAttr(F,Attr);
     ExistDir:=(DosError=0) and (Attr and (VolumeId+Directory)<>0);
end;

function ExistFile(const FileName:String):Boolean;
var
   Attr:Word;
   F:File;

begin
     Assign(F,FileName);
     GetFAttr(F,Attr);
     ExistFile:=(DosError=0) and (Attr and (VolumeId+Directory)=0);
end;

function ExistFileM(const FileName:String):Boolean;
var
   Sr:SearchRec;

begin
     FindFirst(FileName,Archive,Sr);
     ExistFileM:=(DosError=0)
end;

function MakeDir(Path:String):Boolean;
var
   Dir,Save:DirStr;
   Err:Integer;
   I:Byte;

begin
     Err:=0;
     MakeDir:=False;
     Path:=FExpand(Path);
     AddBackSlash(Path);
     GetDir(0,Save);

     ChDir(Copy(Path,1,3));
     If not (IOResult=0) then Exit;
     Delete(Path,1,3);

     Repeat

     I:=Pos('\',Path);
     Dir:=Copy(Path,1,I-1);
     Delete(Path,1,I);
     ChDir(Dir);

     If not (IOResult=0) then
        begin
             MkDir(Dir);
             Err:=IOResult;
             If Err=0 then ChDir(Dir)
        end;

     Until (not (Err=0)) or (Path='');

     MakeDir:=(Err=0);
     ChDir(Save)
end;

function MakeDir2(Dir:String):Boolean;
begin
     DelBackSlash(Dir);
     MkDir(Dir);
     MakeDir2:=(IOResult=0)
end;

function OpenFile(var F:File;const Name:String;const Mode:Byte):Boolean;
var
   Save:Byte;

begin
     Assign(F,Name);
     Save:=FileMode;
     FileMode:=Mode;
     Reset(F,1);
     FileMode:=Save;
     OpenFile:=(IOResult=0)
end;

function OpenText(var F:Text;const Name:String):Boolean;
begin
     Assign(F,Name);
     Reset(F);
     OpenText:=(IOResult=0)
end;

function CreateFile(var F:File;const Name:String):Boolean;
begin
     Assign(F,Name);
     ReWrite(F,1);
     CreateFile:=(IOResult=0)
end;

function CreateText(var F:Text;const Name:String):Boolean;
begin
     Assign(F,Name);
     ReWrite(F);
     CreateText:=(IOResult=0)
end;

function AppendText(var F:Text;const Name:String):Boolean;
begin
     Assign(F,Name);
     Append(F);
     AppendText:=(IOResult=0)
end;

function RenameFile(const CurrName,NewName:String):Boolean;
var
   F:File;

begin
     Assign(F,CurrName);
     Rename(F,NewName);
     RenameFile:=(IOResult=0)
end;

function DeleteFile(const FileName:String):Boolean;
var
   F:File;

begin
     Assign(F,FileName);
     Erase(F);
     DeleteFile:=(IOResult=0)
end;

function DeleteMaskFile(Dir:String;const Mask:String):Boolean;
var
   Search:SearchRec;

begin
     DeleteMaskFile:=False;
     AddBackSlash(Dir);

     FindFirst(Dir+Mask,Archive,Search);
     While DosError=0 do
           begin
                If not DeleteFile(Dir+Search.Name) then Exit;
                FindNext(Search)
           end;

     DeleteMaskFile:=True
end;

function CopyFile(const Src,Dest:String):Boolean;
var
   FIn,FOut:File;
   Result:Word;
   Buf:Pointer;

begin
     CopyFile:=False;

     If not ExistFile(Src) then Exit;

     GetMem(Buf,FileBufSize);
     If Buf=nil then Exit;

     If not OpenFile(FIn,Src,fmReadOnly) then
        begin
             FreeMem(Buf,FileBufSize);
             Exit
        end;

     If not CreateFile(FOut,Dest) then
        begin
             FreeMem(Buf,FileBufSize);
             Close(FIn);
             Exit
        end;

     While not Eof(FIn) do
           begin
                BlockRead(FIn,Buf^,FileBufSize,Result);
                BlockWrite(FOut,Buf^,Result);

                If not (IOResult=0) then
                   begin
                        Close(FIn);
                        Close(FOut);
                        Erase(FOut);
                        FreeMem(Buf,FileBufSize);
                        Exit
                   end
           end;

     Close(FIn);
     Close(FOut);

     FreeMem(Buf,FileBufSize);
     CopyFile:=True
end;

function CopyMaskFile(SrcDir,DestDir:String;const Mask:String):Boolean;
var
   Sr:SearchRec;

begin
     CopyMaskFile:=False;
     AddBackSlash(DestDir);
     AddBackSlash(SrcDir);

     FindFirst(SrcDir+Mask,Archive,Sr);
     While DosError=0 do
           begin
                If not CopyFile(SrcDir+Sr.Name,DestDir+Sr.Name) then Exit;
                FindNext(Sr)
           end;

     CopyMaskFile:=True
end;

function MoveFile(const Src,Dest:String):Boolean;
begin
     MoveFile:=False;
     If not ExistFile(Src) then Exit;
     If not CopyFile(Src,Dest) then Exit;
     MoveFile:=DeleteFile(Src)
end;

function MoveMaskFile(SrcDir,DestDir:String;const Mask:String):Boolean;
begin
     MoveMaskFile:=False;
     If not CopyMaskFile(SrcDir,DestDir,Mask) then Exit;
     MoveMaskFile:=DeleteMaskFile(SrcDir,Mask)
end;

function GetFileSize(const FileName:String):LongInt;
var
   Sr:SearchRec;

begin
     FindFirst(FileName,AnyFile,Sr);
     If not (DosError=0) then GetFileSize:=0
     else GetFileSize:=Sr.Size
end;

function GetFileDate(const FileName:String):LongInt;
var
   Sr:SearchRec;

begin
     FindFirst(FileName,AnyFile,Sr);
     If not (DosError=0) then GetFileDate:=0
     else GetFileDate:=Sr.Time
end;

function GetFileDir(const FileName:String):String;
var
   Dir:DirStr;
   Name:NameStr;
   Ext:ExtStr;

begin
     FSplit(FExpand(FileName),Dir,Name,Ext);
     GetFileDir:=Dir
end;

function GetFileDirName(const FileName:String):String;
var
   Dir:DirStr;
   Name:NameStr;
   Ext:ExtStr;

begin
     FSplit(FExpand(FileName),Dir,Name,Ext);
     GetFileDirName:=Dir+Name
end;

function GetFileName(const FileName:String):String;
var
   Dir:DirStr;
   Name:NameStr;
   Ext:ExtStr;

begin
     FSplit(FileName,Dir,Name,Ext);
     GetFileName:=Name
end;

function GetFileNameExt(const FileName:String):String;
var
   Dir:DirStr;
   Name:NameStr;
   Ext:ExtStr;

begin
     FSplit(FileName,Dir,Name,Ext);
     GetFileNameExt:=Name+Ext
end;

function GetFileExt(const FileName:String):String;
var
   Dir:DirStr;
   Name:NameStr;
   Ext:ExtStr;

begin
     FSplit(FileName,Dir,Name,Ext);
     GetFileExt:=Ext
end;

end.
