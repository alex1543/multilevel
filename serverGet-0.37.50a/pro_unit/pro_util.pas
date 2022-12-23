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

unit pro_util;

interface

  function f_distest (const str_distest : string) : boolean;
  function f_boolean (const str_boolean : string) : boolean;
  function f_config (const str_config : string) : boolean;
  function f_copyright (const str_copyright : string) : boolean;
  function f_info (const str_in_info : string) : boolean;
  function f_help (const str_in_help : string) : boolean;
  function file_exist (put_file_exist : string) : boolean;
  function dir_exist (put_dir_exist : string) : boolean;
  function file_exist_io (put_file_exist : string) : boolean;
  function f_num2str (num_tmp_fns : Longint) : string;
  function f_str2num (str_tmp_fsn : string) : Longint;
  function outc (in_outc : longint) : longint;
  function f_nol2(string_plus_nol : string) : string;
  function str_fix(const in_str_fix : string; const fix : byte; const ch_fix : Char) : string;
  function f_string_fix(str_fix : string; fix : byte) : string;
  function f_string_fix_str_plus(fix : byte; str_plus_sum : string) : string;
  function f_string_fix_left(str_fix : string; fix : byte) : string;

  function f_enter_plus : Char;
  function f_enter_wr : string;
  function f_enter_ver (const enter_ver : Char) : boolean;

  procedure WriteLnX (num_wr_ln : byte; str_wr_ln : string);
  procedure ReadLnSt (var str_in_ReadLnSt : string; const num_in_ReadLnSt : byte);
  function length_copy (const str_in_ReadLnSt : string; const num_in_ReadLnSt : byte) : string;

  procedure ok;

implementation

uses
  crt, dos,

  pro_string, pro_lang;

  procedure ok;

  begin
    while (keypressed) do
      readkey;
    write('Ok!');
    readkey;
  end;

  function length_copy (const str_in_ReadLnSt : string; const num_in_ReadLnSt : byte) : string;

  begin
    if (length(str_in_ReadLnSt) > num_in_ReadLnSt) then
      length_copy := '...' + Copy(str_in_ReadLnSt, length(str_in_ReadLnSt) - (num_in_ReadLnSt - length('...')) +1, num_in_ReadLnSt - length('...')) else
      length_copy := str_in_ReadLnSt;
  end;

  procedure ReadLnSt (var str_in_ReadLnSt : string; const num_in_ReadLnSt : byte);
  var
    key_sv : Char;

    procedure str_del_moni (const str_in_ReadLnSt : string);

    begin
      write(f_string_fix_str_plus(length(length_copy(str_in_ReadLnSt, num_in_ReadLnSt)) -1, #8));
      write(f_string_fix_str_plus(length(length_copy(str_in_ReadLnSt, num_in_ReadLnSt)) -1, ' '));
      write(f_string_fix_str_plus(length(length_copy(str_in_ReadLnSt, num_in_ReadLnSt)) -1, #8));
    end;

  begin
    Write(length_copy(str_in_ReadLnSt, num_in_ReadLnSt));
    key_sv := #0;
    while keypressed do readkey;
    while (key_sv <> #13) and (key_sv <> #27) and (not bool_exit) do
    begin
      if (key_sv <> #8) then
      begin
        if (key_sv <> #0) then
        begin
          str_in_ReadLnSt := str_in_ReadLnSt + key_sv;
          if (length(str_in_ReadLnSt) > num_in_ReadLnSt) then
          begin
            str_del_moni(str_in_ReadLnSt);
            write(length_copy(str_in_ReadLnSt, num_in_ReadLnSt));
          end else write(key_sv);
        end;
      end else
      begin
        if (str_in_ReadLnSt <> '') then
        begin
          str_in_ReadLnSt := Copy(str_in_ReadLnSt, 1, length(str_in_ReadLnSt) -1);
          if (length(str_in_ReadLnSt) >= num_in_ReadLnSt) then
          begin
            str_del_moni(str_in_ReadLnSt);
            write(length_copy(str_in_ReadLnSt, num_in_ReadLnSt));
          end else write(#8, ' ', #8);
        end;
      end;
      while (not keypressed) and (not bool_exit) do delay(10);
      if not bool_exit then key_sv := readkey;
      while (key_sv = #0) do
      begin
        key_sv := readkey; // второй символ после #0
        if (key_sv = #45) then bool_exit := true else // Alt+X = Exit
        key_sv := readkey;
      end;
      if (key_sv = #27) and (str_in_ReadLnSt <> '') then
      begin
        // в первый раз стираем строку по Esc,
        // второй раз выходим из процедуры
        str_del_moni (str_in_ReadLnSt);
        str_in_ReadLnSt := '';
        key_sv := #0;
      end;
    end;
  end;


  function f_distest (const str_distest : string) : boolean;

  begin
    if (UpCase(f_start_end_del_str_simvol(str_distest, '-/\')) = 'TEST') then
      f_distest := true else f_distest := false;
  end;

  function f_copyright (const str_copyright : string) : boolean;

  begin
    if (UpCase(f_start_end_del_str_simvol(str_copyright, '-/\')) = 'COPYLEFT') or
       (UpCase(f_start_end_del_str_simvol(str_copyright, '-/\')) = 'COPYRIGHT') or
       (UpCase(f_start_end_del_str_simvol(str_copyright, '-/\')) = 'VERSION') then
      f_copyright := true else f_copyright := false;
  end;

  function f_boolean (const str_boolean : string) : boolean;

  begin
    if (UpCase(str_boolean) = 'TRUE') or
       (UpCase(str_boolean) = 'YES') or
       (str_boolean = '1') then
      f_boolean := true else
      f_boolean := false;
  end;

  function f_config (const str_config : string) : boolean;

  begin
    if (UpCase(f_start_end_del_str_simvol(str_config, '-/\=')) = 'C') or
       (UpCase(f_start_end_del_str_simvol(str_config, '-/\=')) = 'CONFIG') then
      f_config := true else f_config := false;
  end;

  function f_info (const str_in_info : string) : boolean;

  begin
    if (UpCase(f_start_end_del_str_simvol(str_in_info, '-/\')) = 'I') or
       (UpCase(f_start_end_del_str_simvol(str_in_info, '-/\')) = 'INFO') or
       (UpCase(f_start_end_del_str_simvol(str_in_info, '-/\')) = 'INFORMATION') then
       f_info := true else f_info := false;

  end;

  function f_help (const str_in_help : string) : boolean;

  begin
    if (UpCase(f_start_end_del_str_simvol(str_in_help, '-/\')) = 'H') or
       (UpCase(f_start_end_del_str_simvol(str_in_help, '-/\')) = '?') or
       (UpCase(f_start_end_del_str_simvol(str_in_help, '-/\')) = 'HELP') then
       f_help := true else f_help := false;

  end;

  function file_exist (put_file_exist : string) : boolean;
  var
    SR_file_exit : SearchRec;

  begin
    FindFirst(put_file_exist, AnyFile, SR_file_exit);

    if (DosError <> 0) then
    begin
      FindClose(SR_file_exit);
      file_exist := false; //  не файл, не область
    end
    else
    begin
      FindClose(SR_file_exit);
      FindFirst(put_file_exist + '/*', AnyFile, SR_file_exit);
      if (DosError <> 0) then
      begin
        file_exist := true; // файл
      end
      else
      begin
        file_exist := false; // область
      end;
    end;

  end;


  function dir_exist (put_dir_exist : string) : boolean;
  var
    SR_dir_exist : SearchRec;

  begin

    FindFirst(f_end_del_simvol(put_dir_exist, '/'), AnyFile, SR_dir_exist);

    if (DosError <> 0) then
    begin
      FindClose(SR_dir_exist);
      dir_exist := false; //  не файл, не область
    end
    else
    begin
      FindClose(SR_dir_exist);
      FindFirst(f_end_del_simvol(put_dir_exist, '/') + '/*', AnyFile, SR_dir_exist);
      if (DosError <> 0) then
      begin
        dir_exist := false; // файл
      end
      else
      begin
        dir_exist := true; // область
      end;
    end;

  end;

  function file_exist_io (put_file_exist : string) : boolean;
  var
    file_exist_file : text;

  begin

    assign (file_exist_file, put_file_exist);
{$I-}
    reset (file_exist_file);
    close (file_exist_file);
{$I+}
    if IOResult <> 0 then
      file_exist_io := false
                     else
      file_exist_io := true;

  end;

  function f_num2str (num_tmp_fns : Longint) : string;
  begin
    str (num_tmp_fns, f_num2str);
  end;
  function f_str2num (str_tmp_fsn : string) : Longint;
  begin
    val (str_tmp_fsn, f_str2num);
  end;
  function outc (in_outc : longint) : longint;
  begin
    outc := in_outc - 1;
  end;

  function f_nol2(string_plus_nol : string) : string;

  begin
    while Length (string_plus_nol) < 2 do
      string_plus_nol := '0' + string_plus_nol;

    f_nol2 := string_plus_nol;
  end;

  function str_fix(const in_str_fix : string; const fix : byte; const ch_fix : Char) : string;

  begin
    str_fix := in_str_fix;
    while length(str_fix) <= fix do
      str_fix := str_fix + ch_fix;
    if length(str_fix) > fix then
      str_fix := copy(str_fix, 1, fix);
  end;

  function f_string_fix(str_fix : string; fix : byte) : string;

  begin
    while length(str_fix) <= fix do
      str_fix := str_fix + ' ';

    if length(str_fix) > fix then
      str_fix := copy(str_fix, 1, fix);

    f_string_fix := str_fix;
  end;

  function f_string_fix_str_plus(fix : byte; str_plus_sum : string) : string;
  var
    str_fix_str_plus : string;

  begin
    str_fix_str_plus := '';
    while length(str_fix_str_plus) <= fix do
      str_fix_str_plus := str_fix_str_plus + str_plus_sum;

    f_string_fix_str_plus := str_fix_str_plus;
  end;

  function f_string_fix_left(str_fix : string; fix : byte) : string;

  begin
    if  fix < length(str_fix) then
    begin
      str_fix := copy(str_fix, length(str_fix) - fix,  fix);
    end
    else
    begin
      while length(str_fix) < fix do
      begin
        str_fix := ' ' + str_fix;
      end;
    end;
    f_string_fix_left := str_fix;
  end;


  function f_enter_plus : Char;

  begin
    f_enter_plus := Chr($0D);
  end;

  function f_enter_wr : string;

  begin
    f_enter_wr := Chr($0D) + Chr($0A);
  end;


  function f_enter_ver (const enter_ver : Char) : boolean;

  begin
    if (enter_ver = chr($0D)) or (enter_ver = chr($0A)) then
      f_enter_ver := true else f_enter_ver := false;

  end;


  procedure WriteLnX (num_wr_ln : byte; str_wr_ln : string);
  var
    num_wr_ln_t : byte;

  begin
    num_wr_ln_t := 1;
    while (num_wr_ln_t <= num_wr_ln) do
    begin
      WriteLn(str_wr_ln);
      inc(num_wr_ln_t);
    end;
  end;


end.