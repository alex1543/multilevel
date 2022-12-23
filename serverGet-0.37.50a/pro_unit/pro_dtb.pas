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

unit pro_dtb;

interface

  function rss_old (const ch_old : PChar; var num_item : longint) : boolean;
  function GetFileDtb : string;
  function StartDtb : PChar;
  function NewsDtb (const ch_old : PChar) : PChar;
  function VersionDtb : string;
  function GetStrPar (const ch_dtb : PChar; var num_ch_dtb : longint; const str_pos : string; var bool_load : boolean) : PChar;
  function ExistAndWr (const put_file_rss_dtb : string; var ch_dtb : PChar; const ch_old : PChar) : boolean;

  function GetFirstParCfgDtb (const num_plus : byte) : string;
  procedure SetFirstParCfgDtb (const num_plus : byte; const str_plus : string);

  function goto_to_name(const ch_dtb : PChar; var num_ch_dtb : longint) : boolean;
  procedure load_dtb_str(const ch_dtb : PChar; const str_ch_dtb_in : string; var str_ch_dtb : string);
  procedure load_dtb_ch(const ch_dtb : PChar; const str_ch_dtb_in : string; var ch_dtb_old : PChar);
  procedure ReDtb (const ch_dtb, ch_in_re : PChar; var ch_dtb_new : PChar; var re_pos : longint; const re_str : string);
  procedure ReStrDtb (const ch_dtb, ch_in_re : PChar; var ch_dtb_new : PChar; var re_pos : longint; const re_sv_pos : longint);
  function f_q_msg (const ch_dtb, ch_old : PChar; var num_item : longint) : boolean;
  procedure p_rss_write_new_dtb (const put_file_rss_dtb : string; var ch_dtb : PChar; const ch_old : PChar; var num_ch_dtb : longint);
  procedure GetPCharDtb (const put_file_rss_dtb : string; var ch_dtb : PChar);
  function StrFirstParCfgDtb (const num_plus : byte) : string;
  function GeterSeter(const str_gs : string; const bool_gs : boolean) : boolean;


implementation

uses
  crt, dos,

  pro_util, pro_string, pro_const, pro_ch, pro_files, pro_item, pro_dt;


  function GeterSeter(const str_gs : string; const bool_gs : boolean) : boolean;
  var
    num_t : byte;
    str_t : string;

  begin
    num_t := 1;
    while (const_cfg[num_t] <> '') and
          (UpCase(str_gs) <> UpCase(const_cfg[num_t])) do
      inc(num_t);
    if (UpCase(str_gs) = UpCase(const_cfg[num_t])) then
    begin
      if (bool_gs) then
      begin // Geter
        str_t := GetFirstParCfgDtb(num_t);
        par_cfg[pro_const. num_rss][num_t][pro_const. num_tplus] := str_t;
      end else
      begin // Seter
        str_t := par_cfg[pro_const. num_rss][num_t][pro_const. num_tplus];
        SetFirstParCfgDtb (num_t, str_t);
      end;
      GeterSeter := true;
    end else
      GeterSeter := false;
  end;

  function StrFirstParCfgDtb (const num_plus : byte) : string;

  begin
    StrFirstParCfgDtb := '[first/' + f_num2str(pro_const. num_rss) + '/' + f_num2str(num_plus) + '/' + f_num2str(pro_const. num_tplus) + ']=';

  end;

  function GetFirstParCfgDtb (const num_plus : byte) : string;
  var
    ch_dtb : PChar;
    num_ch_dtb : longint;
    bool_load : boolean;

  begin
    GetFirstParCfgDtb := '';
    if file_exist(GetFileDtb) then
    begin
      GetPCharDtb(GetFileDtb, ch_dtb);
      num_ch_dtb := 0;
      ch_dtb := GetStrPar(ch_dtb, num_ch_dtb, StrFirstParCfgDtb(num_plus), bool_load);
      if (bool_load) and (not (ch_dtb = nil)) then GetFirstParCfgDtb := chToStr(ch_dtb);
      ch_dtb := nil;
    end;
  end;

  procedure SetFirstParCfgDtb (const num_plus : byte; const str_plus : string);
  var
    ch_dtb : PChar;
    num_ch_dtb, num_t, num_start : longint;
    bool_load : boolean;
    str_t : string;

 begin
  if (not (str_plus = '')) then
  begin // Пустое значение не сохраняем
    ExistAndWr (GetFileDtb, ch_dtb, nil);
    GetPCharDtb(GetFileDtb, ch_dtb);
    GetStrPar (ch_dtb, num_ch_dtb, '[' + 'start_saver' + ']', bool_load);
    num_start := num_ch_dtb;
    str_t := chToStr(GetStrPar(ch_dtb, num_ch_dtb, StrFirstParCfgDtb(num_plus), bool_load));
    if (not (str_plus = str_t)) then
    begin
      if not bool_load then
      begin // Новое значение
        num_ch_dtb := num_start;
        GetStrPar (ch_dtb, num_ch_dtb, ';' + f_enter_wr + '[' + 'end_saver' + ']', bool_load);
        if bool_load then num_ch_dtb := num_ch_dtb - length(';' + f_enter_wr + '[' + 'end_saver' + ']');
        ReStrDtb(ch_dtb, strToch(StrFirstParCfgDtb(num_plus) + str_plus + f_enter_wr), ch_dtb, num_ch_dtb, num_ch_dtb);
      end else
      begin // значение изменилось
        num_t := num_ch_dtb - length(StrFirstParCfgDtb(num_plus) + str_t);
        ReStrDtb(ch_dtb, strToch(StrFirstParCfgDtb(num_plus) + str_plus), ch_dtb, num_t, num_ch_dtb);
      end;
      file_create(ch_dtb, GetFileDtb);
    end;
  end;
 end;

  function GetStrPar (const ch_dtb : PChar; var num_ch_dtb : longint; const str_pos : string; var bool_load : boolean) : PChar;
  var
    num_ch_dtb_old : longint;

  begin

    GetStrPar := nil;
    while (not eof_ch(ch_dtb, num_ch_dtb)) and
          (not f_pos_ch(ch_dtb, f_enter_wr + str_pos, num_ch_dtb)) do
          inc(num_ch_dtb);

    if f_pos_ch(ch_dtb, f_enter_wr + str_pos, num_ch_dtb) then
    begin
      num_ch_dtb := num_ch_dtb + length(f_enter_wr + str_pos);
      num_ch_dtb_old := 0;
      while (not f_pos_ch(ch_dtb, f_enter_wr, num_ch_dtb + num_ch_dtb_old)) and
            (not eof_ch(ch_dtb, num_ch_dtb + num_ch_dtb_old)) do
      begin
        ReallocMem(GetStrPar, num_ch_dtb_old +1);
        GetStrPar[num_ch_dtb_old] := ch_dtb[num_ch_dtb + num_ch_dtb_old];
        inc(num_ch_dtb_old);
      end;
      if not (num_ch_dtb_old = 0) then
      begin
        num_ch_dtb := num_ch_dtb + num_ch_dtb_old;
        p_ch_end_fast(GetStrPar, num_ch_dtb_old);
      end;
      bool_load := true;
    end else
      bool_load := false;

  end;

  function goto_to_name(const ch_dtb : PChar; var num_ch_dtb : longint) : boolean;
  var
    str_t : string;
    bool_load : boolean;

  begin
    num_ch_dtb := 0; goto_to_name := false;
    repeat
      str_t := GetStrPar(ch_dtb, num_ch_dtb, '[' + const_cfg[1] + ']=', bool_load);
      goto_to_name := (UpCase(str_t) = UpCase(par_cfg[num_rss][1][1]));
    until (eof_ch(ch_dtb, num_ch_dtb)) or (goto_to_name) or (str_t = '');

  end;

  procedure load_dtb_str(const ch_dtb : PChar; const str_ch_dtb_in : string; var str_ch_dtb : string);
  var
    num_ch_dtb : longint;
    bool_load : boolean;

  begin
    goto_to_name(ch_dtb, num_ch_dtb);
    str_ch_dtb := chToStr(GetStrPar(ch_dtb, num_ch_dtb, str_ch_dtb_in, bool_load));

  end;

  procedure load_dtb_ch(const ch_dtb : PChar; const str_ch_dtb_in : string; var ch_dtb_old : PChar);
  var
    num_ch_dtb : longint;
    bool_load : boolean;

  begin
    goto_to_name(ch_dtb, num_ch_dtb);
    ch_dtb_old := GetStrPar(ch_dtb, num_ch_dtb, str_ch_dtb_in, bool_load);

  end;

  function GetFileDtb : string;
  var
    str_t : string;

  begin
      str_t := f_file_name_del_ext(f_prog_name) + '.dtb';
      GetFileDtb := f_expand(str_t);

  end;

  function VersionDtb : string;

  begin
    VersionDtb := '[' + 'version' + ']=' + '>0.48';
  end;

  function StartDtb : PChar;
  var
    num_t : longint;

  begin

    num_t := 0; StartDtb := nil;
    p_add_ch(StartDtb, num_t, ';' + f_enter_wr);
    p_add_ch(StartDtb, num_t, '; This dynamic file of rss2fido. Please, dont edit this file.' + f_enter_wr);
    p_add_ch(StartDtb, num_t, ';' + f_enter_wr);
    p_add_ch(StartDtb, num_t, VersionDtb + f_enter_wr);
    p_add_ch(StartDtb, num_t, ';' + f_enter_wr);

    p_add_ch(StartDtb, num_t, '[' + 'start_saver' + ']' + f_enter_wr);
    p_add_ch(StartDtb, num_t, ';' + f_enter_wr);
    p_add_ch(StartDtb, num_t, '[' + 'end_saver' + ']' + f_enter_wr);
    p_add_ch(StartDtb, num_t, ';' + f_enter_wr);

    p_ch_end_fast(StartDtb, num_t);

  end;

  function NewsDtb (const ch_old : PChar) : PChar;
  var
    num_t : longint;
    ch_item : PChar;

  begin
    num_t := 0; NewsDtb := nil;
    p_add_ch(NewsDtb, num_t, '[' + 'size_rss' + ']=' + f_num2str(strLen(ch_old)) + f_enter_wr);
    p_add_ch(NewsDtb, num_t, '[' + 'news' + ']=');
    load_item(ch_old, 1, ch_item, true);
    p_add_ch_ch(NewsDtb, num_t, ch_item);
    p_add_ch(NewsDtb, num_t, f_enter_wr);
    p_add_ch(NewsDtb, num_t, '[' + 'write' + ']=' + date_and_time(2) + f_enter_wr);
    p_add_ch(NewsDtb, num_t, ';' + f_enter_wr);
    p_ch_end_fast(NewsDtb, num_t);
  end;

  procedure ReStrDtb (const ch_dtb, ch_in_re : PChar; var ch_dtb_new : PChar; var re_pos : longint; const re_sv_pos : longint);
  var
    num_t : longint;

  begin
    ch_dtb_new := nil;
    ReallocMem(ch_dtb_new, re_pos);
    for num_t := 0 to re_pos do
      ch_dtb_new[num_t] := ch_dtb[num_t];

    p_add_ch_ch(ch_dtb_new, num_t, ch_in_re);

    re_pos := re_sv_pos;
    while (not eof_ch(ch_dtb, re_pos)) do
    begin
      ReallocMem(ch_dtb_new, num_t +1);
      ch_dtb_new[num_t] := ch_dtb[re_pos];
      inc(re_pos); inc(num_t);
    end;
    p_ch_end_fast(ch_dtb_new, num_t);

  end;

  procedure ReDtb (const ch_dtb, ch_in_re : PChar; var ch_dtb_new : PChar; var re_pos : longint; const re_str : string);
  var
    num_t : longint;

  begin
    ch_dtb_new := nil;
    ReallocMem(ch_dtb_new, re_pos);
    for num_t := 0 to re_pos do
      ch_dtb_new[num_t] := ch_dtb[num_t];

    p_add_ch_ch(ch_dtb_new, num_t, ch_in_re);

    while (not eof_ch(ch_dtb, re_pos)) and
          (not (f_pos_ch(ch_dtb, re_str, re_pos) or (re_str = ''))) do
      inc(re_pos);
    if f_pos_ch(ch_dtb, re_str, re_pos) or (re_str = '') then
    begin
      while (not eof_ch(ch_dtb, re_pos)) do
      begin
        ReallocMem(ch_dtb_new, num_t +1);
        ch_dtb_new[num_t] := ch_dtb[re_pos];
        inc(re_pos); inc(num_t);
      end;
    end;
    p_ch_end_fast(ch_dtb_new, num_t);

  end;

  function f_q_msg (const ch_dtb, ch_old : PChar; var num_item : longint) : boolean;
  var
    ch_item, ch_item_old : PChar;
    num_ch_dtb : longint;

  begin
    load_dtb_ch(ch_dtb, '[' + 'news' + ']=', ch_item_old);
    num_ch_dtb := 0;
    repeat
      inc(num_ch_dtb);
      load_item(ch_old, num_ch_dtb, ch_item, true);
    until (num_ch_dtb >= q_item) or (f_ch(ch_item, ch_item_old));
    if (f_ch(ch_item, ch_item_old)) then
      num_item := num_ch_dtb;
    if (num_ch_dtb = 1) and (f_ch(ch_item, ch_item_old)) then
      f_q_msg := true else f_q_msg := false;
  end;

  procedure p_rss_write_new_dtb (const put_file_rss_dtb : string; var ch_dtb : PChar; const ch_old : PChar; var num_ch_dtb : longint);

  begin
    if not (ch_old = nil) then
    begin
      p_add_ch(ch_dtb, num_ch_dtb, '[' + const_cfg[1] + ']=' + par_cfg[num_rss][1][1] + f_enter_wr);
      p_add_ch_ch(ch_dtb, num_ch_dtb, NewsDtb(ch_old));
    end;
    p_ch_end_fast(ch_dtb, num_ch_dtb);
    file_create(ch_dtb, put_file_rss_dtb);

  end;

  function ExistAndWr (const put_file_rss_dtb : string; var ch_dtb : PChar; const ch_old : PChar) : boolean;
  var
    num_t : longint;

  begin
    if (not file_exist(put_file_rss_dtb)) then
    begin
      num_t := 0; ch_dtb := nil;
      p_add_ch_ch(ch_dtb, num_t, StartDtb);
      p_rss_write_new_dtb (put_file_rss_dtb, ch_dtb, ch_old, num_t);
      ExistAndWr := true;
    end else
      ExistAndWr := false;
  end;

  procedure GetPCharDtb (const put_file_rss_dtb : string; var ch_dtb : PChar);

  begin
    p_io_file(put_file_rss_dtb);
    p_load_file_ch_all(ch_dtb, put_file_rss_dtb);
  end;

  function rss_old (const ch_old : PChar; var num_item : longint) : boolean;
  var
    num_size_old, num_size_next : longint;
    ch_dtb : PChar;
    num_ch_dtb : longint;
    str_ch_dtb : string;


    procedure p_rewrite_rss_dtb;

    begin
      num_ch_dtb := 0;
      goto_to_name(ch_dtb, num_ch_dtb);
      num_ch_dtb := num_ch_dtb + length(f_enter_wr);
      ReDtb(ch_dtb, NewsDtb(ch_old), ch_dtb, num_ch_dtb, '[' + const_cfg[1] + ']=');

      file_create(ch_dtb, GetFileDtb);

    end;

  begin
    rss_old := false; num_item := 1;
    q_item := func_q_item(ch_old);

    num_size_next := strLen(ch_old);

    if (not ExistAndWr(GetFileDtb, ch_dtb, ch_old)) then
    begin
      GetPCharDtb (GetFileDtb, ch_dtb);

      if goto_to_name(ch_dtb, num_ch_dtb) then
      begin
        load_dtb_str(ch_dtb, '[' + 'write' + ']=', pro_const. writetime);

        load_dtb_str(ch_dtb, '[' + 'size_rss' + ']=', str_ch_dtb);
        num_size_old := f_str2num(str_ch_dtb);

        // если равен размер и первое сообщение равно сохраненному
        if (num_size_next = num_size_old) and (f_q_msg(ch_dtb, ch_old, num_item)) then
          rss_old := true else
          p_rewrite_rss_dtb;

      end else p_rss_write_new_dtb (GetFileDtb, ch_dtb, ch_old, num_ch_dtb);
    end;
  end;


end.