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

unit pro_msg;

interface

uses
  pro_const;

  procedure send_message_base (const ch_in_base : PChar; var put_in_base : string);
  procedure p_re_atr(const re_atr : string; var re_atr_msg : tmsg);


implementation

uses
  crt, dos,

  pro_lang, pro_string, pro_util,

  skMHL, skmhlsq, skmhljam, skmhlmsg,
  skCommon;

var

  atr_in_msg : Array[1..16] of longint =
(maPrivate, maReceived, maAttach,
maOrphan, maLocal, maFRq,
maRRc, maURq, maCrash, maSent, maTransit,
maKill, maHold, maRRq, maARq, maScanned);

  num_t, num_temp : longint;

  procedure p_re_atr(const re_atr : string; var re_atr_msg : tmsg);
  var
    re_atr_t : string;

  begin
    re_atr_t := re_atr;
    num_t := 1;
    while (pos(',', re_atr_t) <> 0) do
    begin
      re_atr_msg[num_t] := f_start_end_del_str_simvol(Copy(re_atr_t, 1, pos(',', re_atr_t) -1), ' ');
      re_atr_t := Copy(re_atr_t, pos(',', re_atr_t) +1, length(re_atr_t) - pos(',', re_atr_t));
      re_atr_t := f_start_end_del_str_simvol(re_atr_t, ' ');
      inc(num_t);
    end;
    re_atr_msg[num_t] := re_atr_t;
    re_atr_msg[num_t +1] := '';
  end;

  procedure send_message_base (const ch_in_base : PChar; var put_in_base : string);
  var
    Base : PMessageBase;
    address_wk : TAddress;
    time_in_base : TMessageBaseDateTime;
    atr_re_msg : tmsg;


  procedure p_ver_base (in_ver_base : string);

  begin
    num_t := 1;
    while (UpCase(in_ver_base) <> UpCase(def_base[num_t])) and
      (def_base[num_t] <> '') do
      inc(num_t);
    if (def_base[num_t] = '') then
      p_lang('error_format', true);

  end;

  procedure p_set_atr (const in_re_atr_msg, in_set_atr_msg : tmsg);

  begin
    num_t := 1;
    while (atr_msg[num_t] <> '') do
    begin
      num_temp := 1;
      while (in_re_atr_msg[num_temp] <> '') do
      begin
        if (UpCase(in_re_atr_msg[num_temp]) = UpCase(in_set_atr_msg[num_t])) then
          Base^. SetAttribute(atr_in_msg[num_t], True);
        inc(num_temp);
      end;
      inc(num_t);
    end;
  end;

  begin

    if (par_cfg[pro_const. num_rss][9][pro_const. num_tplus] = '') then
    // если формат почтовой базы не указан, то пытаемся сами определить
    begin
      Base := New(PSquishMessageBase, Init);
      par_cfg[pro_const. num_rss][9][pro_const. num_tplus] := def_base[1];
      if (not Base^. Exist(put_in_base)) then
      begin
        Dispose(Base, Done);
        Base := New(PJamMessageBase, Init);
        par_cfg[pro_const. num_rss][9][pro_const. num_tplus] := def_base[2];
        if (not Base^. Exist(put_in_base)) then
        begin
          Dispose(Base, Done);
          Base := New(PFidoMessageBase, Init);
          par_cfg[pro_const. num_rss][9][pro_const. num_tplus] := def_base[3];
          if (not Base^. Exist(put_in_base)) then
            Dispose(Base, Done);
            par_cfg[pro_const. num_rss][9][pro_const. num_tplus] := 'unknown';

        end;
      end;
    end;

    p_ver_base(par_cfg[pro_const. num_rss][9][pro_const. num_tplus]);

    if (UpCase(par_cfg[pro_const. num_rss][9][pro_const. num_tplus]) = UpCase(def_base[1])) then
      Base := New(PSquishMessageBase, Init);
    if (UpCase(par_cfg[pro_const. num_rss][9][pro_const. num_tplus]) = UpCase(def_base[2])) then
      Base := New(PJamMessageBase, Init);
    if (UpCase(par_cfg[pro_const. num_rss][9][pro_const. num_tplus]) = UpCase(def_base[3])) then
      Base := New(PFidoMessageBase, Init);

    Base^. SetFlag(afEchomail, True);
    put_in_base := f_re_sim_sl(put_in_base);
    if not Base^. Open(put_in_base) then
    begin
      repeat
      p_lang('error_msgbase', false);
      until Base^. Open(put_in_base);
    end;

    num_msg := Base^. GetCount +1; // +1 - тек. сообщение

    if not (Base^. CreateNewMessage) then
    begin
      repeat
        p_lang('error_msgbase', false);
      until (Base^. CreateNewMessage);
    end else
    begin
      if (par_cfg[pro_const. num_rss][13][pro_const. num_tplus] <> '') then
      begin // send_to
        if (StrToAddress(par_cfg[pro_const. num_rss][13][pro_const. num_tplus], address_wk)) then
          Base^. SetToAddress(address_wk) else
          p_lang('error_address', true);
      end;

      if (StrToAddress(par_cfg[pro_const. num_rss][12][pro_const. num_tplus], address_wk)) then
        Base^. SetFromAddress(address_wk, True) else
        p_lang('error_address', true); // send_from


      Base^. SetFrom(par_cfg[pro_const. num_rss][10][pro_const. num_tplus]);
      Base^. SetTo(par_cfg[pro_const. num_rss][11][pro_const. num_tplus]);
      Base^. SetSubject(par_cfg[pro_const. num_rss][14][pro_const. num_tplus]);
      GetCurrentMessageBaseDateTime(time_in_base);
      Base^. SetWrittenDateTime(time_in_base);
      Base^. SetArrivedDateTime(time_in_base);

      p_re_atr(par_cfg[pro_const. num_rss][17][pro_const. num_tplus], atr_re_msg);
      p_set_atr(atr_re_msg, atr_msg);
      p_set_atr(atr_re_msg, atr_msg_del);

      Base^. PutStringPChar(ch_in_base);
      Base^. PutString('--- ' + par_cfg[pro_const. num_rss][15][pro_const. num_tplus]);
      Base^. PutOrigin(address_wk, par_cfg[pro_const. num_rss][16][pro_const. num_tplus]);

      if not Base^. WriteMessage then
      begin
        repeat
          p_lang('error_msgbase', false);
        until (Base^. WriteMessage);
      end;
      Base^. CloseMessage;
    end;
    Dispose(Base, Done);
    p_lang('msgbase', false);

  end;

end.