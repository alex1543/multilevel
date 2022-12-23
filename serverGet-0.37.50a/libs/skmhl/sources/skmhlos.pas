{
===============================================================================

 skMHLos.pas - part of skMHL Library by sergey korowkin (2:6033/27@fidonet),
               port to *nix based OS by Andrew V. Sichevoi (2:6028/9@fidonet)

 Unit for correct work skMHL Library under *nix based OS.
 Version : v0.1beta24-avs2
 License : GNU GPL v2.0
 Compiler: FreePascal Compiler v1.0.10
 Author  : Andrew V. Sichevoi
 
===============================================================================
}

unit skMHLos;

 interface

const
    
     {$IFDEF UNIX}
      Mask   = '*';
      Slash  = '/';
      ExtMSG = '.msg';  
     {$ELSE}
      Mask   = '*.*';
      Slash  = '\'  ;
      ExtMSG = '.MSG';
     {$ENDIF}
     
      Dot    = '.';
     
      ejJHR  = 'jhr';
      ejJDX  = 'jdx';
      ejJDT  = 'jdt';
      ejJLR  = 'jlr';     
      
      esSQD  = 'sqd';
      esSQI  = 'sqi';
     
  function ParsePath (sPath    : String) : String;
 {$IFDEF FPC}
  function CreateFile(FileName : String) : Boolean;
 {$ENDIF}
      
 implementation
 
{$IFDEF UNIX}
 uses 
     Dos;
{$ENDIF} 
 
{===========================================================================}
function GetCurrentDir : String;   
var
   S : String;
   I : Byte;
begin

 S:=ParamStr(0);
 for I:=Length(S) downto 1 do 
  if (S[I] = Slash) then begin
   S:=Copy(S, 1, I-1);
   Break;
  end;
  
 GetCurrentDir:=S;
 
end;    
{===========================================================================}
function ParsePath(sPath : String) : String; 
begin

{$IFDEF UNIX}
 if ((sPath[1] = '~') and (sPath[2] = Slash)) then begin
  Delete(sPath, 1, 2);
  sPath:=GetEnv('HOME')+Slash+sPath;
 end;
 if ((sPath[1] = '.') and (sPath[2] = Slash)) then begin
  Delete(sPath, 1, 2);
  sPath:=GetCurrentDir+Slash+sPath;
 end;
{$ENDIF}

 ParsePath:=sPath;
 
end; 
{===========================================================================}
{$IFDEF FPC}
function CreateFile(FileName : String) : Boolean;
var
   F : Text;
begin

 CreateFile:= false;
 
 Assign(F, FileName);
 {$I-}Rewrite(F){$I+};
 if (IOResult = 0) then begin
  Close(F);
  CreateFile:= true;
 end;
 
end;    
{===========================================================================}
{$ENDIF} 
 
end. 
