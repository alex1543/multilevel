(*
 * Copyright (c) 2006
 *      Alexey Subbotin. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the author nor the names of contributors may
 *    be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY AUTHOR AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 *)
unit pro_bso;

interface

  procedure send_bso_file (const put_otbound : string);

implementation

uses
  crt, dos,
  tic_hex, tic_files,
  pro_const, pro_lang, pro_util, pro_string, pro_msg,
  skCommon;

var
   OutboundPath : String;
   LocalZone : Word;
   OutDir, LoName : String;

procedure GetLoName(const Adr:TAddress);
begin
     OutDir:=OutboundPath;

     If not (Adr.Zone=LocalZone) then
        begin
             DelBackSlash(OutDir);
             OutDir:=OutDir+'.'+Copy(Word2Hex(Adr.Zone),2,3)
        end;

     AddBackSlash(OutDir);

     If not ExistDir(OutDir) then MakeDir(OutDir);

     LoName:=Word2Hex(Adr.Net)+Word2Hex(Adr.Node);
     If not (Adr.Point=0) then
        begin
             OutDir:=OutDir+LoName+'.PNT';
             AddBackSlash(OutDir);
             If not ExistDir(OutDir) then MakeDir(OutDir);
             LoName:='0000'+Word2Hex(Adr.Point)
        end
end;

function CheckForBusy(const Adr:TAddress):Boolean;

begin
     GetLoName(Adr);
     CheckForBusy:=ExistFileM(OutDir+LoName+'.?sy')
end;

procedure CreateBusyFlag(const Adr:TAddress);

begin
     GetLoName(Adr);
     CreateZeroFile(OutDir+LoName+'.bsy')
end;

procedure RemoveBusyFlag(const Adr:TAddress);

begin
     GetLoName(Adr);
     DeleteFile(OutDir+LoName+'.bsy')
end;

function MakePoll(const Adr:TAddress;Flavor:Char):Boolean;

begin
     MakePoll:=False;
     GetLoName(Adr);
     LoName:=OutDir+LoName;

     If ExistFileM(LoName+'.?sy') then Exit;
     CreateZeroFile(LoName+'.bsy');

     If not ExistFile(LoName+'.'+Flavor+'lo') then
     CreateZeroFile(LoName+'.'+Flavor+'lo');

     DeleteFile(LoName+'.bsy');
     MakePoll:=True
end;

function AttachFiles(const Adr:TAddress;List:string;Flavor:Char):Boolean;
var
   F:Text;

begin
     AttachFiles:=False;
     GetLoName(Adr);
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

     WriteLn(F,List);

     Close(F);
     DeleteFile(LoName+'.bsy');
     AttachFiles:=True
end;


  procedure send_bso_file (const put_otbound : string);
  var
    put_file_otbound : string;
    fAdr, tAdr : TAddress;
    atr_re_msg : tmsg;
    num_t, num_t2 : byte;
    flavor : Char;
    str_delete : string;

  begin
    str_delete := '';
    flavor := 'f';

    // проверяем адреса
    if not (StrToAddress(par_cfg[pro_const. num_rss][12][pro_const. num_tplus], fAdr)) then
      p_lang('error_address', true);
    if not (StrToAddress(par_cfg[pro_const. num_rss][13][pro_const. num_tplus], tAdr)) then
      p_lang('error_address', true);

    // устанавливаем локальную зону
    LocalZone := fAdr. Zone;
    // и путь в Bink Style Outbound
    OutboundPath := put_otbound;

    p_re_atr(par_cfg[pro_const. num_rss][17][pro_const. num_tplus], atr_re_msg);
    num_t := 1;
    while (atr_re_msg[num_t] <> '') do
    begin
      // устанавливаем флаг "Delete"
      if not (UpCase(atr_re_msg[num_t]) = UpCase(art_bso_lo[2])) then
      begin
        // устанавливаем флаг "Normal"
        if (UpCase(atr_re_msg[num_t]) = UpCase(art_bso_lo[1])) then
          atr_re_msg[num_t] := 'f';
        num_t2 := 1;
        // если флаг есть в массиве "art_bso_lo"
        while (not (art_bso_lo[num_t2] = '')) and (not (UpCase(art_bso_lo[num_t2]) = UpCase(atr_re_msg[num_t]))) do
          inc(num_t2);
        // устанавливаем все остальные флаги
        if (UpCase(art_bso_lo[num_t2]) = UpCase(atr_re_msg[num_t])) then
          MakePoll(tAdr, atr_re_msg[num_t][1]);
      end else str_delete := '^';

      inc(num_t);
    end;

    put_file_otbound := f_lang_re(par_cfg[pro_const. num_rss][27][pro_const. num_tplus]);
    if (put_file_otbound = '') then
      put_file_otbound := f_lang_re(par_cfg[pro_const. num_rss][4][pro_const. num_tplus]);

    if not (put_file_otbound = '') then
      AttachFiles(tAdr, str_delete + put_file_otbound, flavor);

  end;

end.