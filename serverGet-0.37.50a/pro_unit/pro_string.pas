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

unit pro_string;

interface
  function f_nol2(const string_plus_nol : string) : string;
  function f_re_sim_sl (const re_sim_sl : string) : string;
  function f_nix_dir (in_dir : string) : boolean;
  function f_prog_name : string;
  function f_prog_dir : string;
  function f_file_name_del_ext (const prog_name_del_ext : string) : string;
  function f_expand(const in_put_file_expand : string) : string;
  function f_dir (const path_sp : string) : string;
  function f_file_ext (const path_sp : string) : string;
  function f_sim_del(const in_sim_del : string; const sim_del : Char) : string;
  function f_col_sim_str(const col_sim_str : string; const col_sim_str_char : char) : byte;
  function f_sim_in_out_del (const sim_in_out_del : string; const sim_in_out : Char) : string;
  function f_file_name(const file_name : string) : string;
  function f_re_string_pos (const str_re_string_in, str_re_string_out, str_re_string_new : string) : string;
  function f_re_string_pos_start (const str_re_string_in, str_re_string_out : string) : string;
  function f_re_string_pos_end (const str_re_string_in, str_re_string_out : string) : string;
  procedure p_re_str (const in_re_str, in_re_str_pos : string; var in_re_str_in, in_re_str_out : string);
  function f_start_del_simvol (const str_in : string; const char_in : Char) : string;
  function f_end_del_simvol (const str_in : string; const char_in : Char) : string;
  function f_start_end_del_simvol (const str_in : string; const char_in : Char) : string;
  function f_start_end_del_str_simvol (const str_in : string; const str_char_in : string) : string;
  function f_in_per_end(in_per_end, out_per_and : string) : string;
  function f_ver_ch (const str_ver : string; const ch_ver : Char) : boolean;
  function rf1f12 (const ch_in : Char) : string;
  function get_file_cp_out (const path_file_cp_out : string) : string;
  function cat_ver (const str_cat_ver : string) : boolean;

implementation

uses
  crt, dos,

  pro_util, pro_const, pro_lang;

var
  num_t : byte;

  function get_file_cp_out (const path_file_cp_out : string) : string;
  var
    num_t : longint;
    str_t : string;

  begin
    num_t := 1;
    repeat
      str_t := f_expand(path_file_cp_out + '/outrss#' + f_num2str(num_t) + '.txt');
      inc(num_t);
    until (not file_exist(str_t));
    get_file_cp_out := str_t;
  end;

  function rf1f12 (const ch_in : Char) : string;

  begin
    rf1f12 := ch_in;
    if (Ord(ch_in) >= 59) and (Ord(ch_in) <= 68) then
      rf1f12 := Chr(Ord(ch_in) -10);
    if (Ord(ch_in) = 133) then
      rf1f12 := '11';
    if (Ord(ch_in) = 134) then
      rf1f12 := '12';

  end;

  function f_ver_ch (const str_ver : string; const ch_ver : Char) : boolean;
  var
    num_ver : byte;

  begin
    num_ver := 1; f_ver_ch := true;
    while (str_ver[num_ver] <> '') and
          (f_ver_ch) do
    begin
      if (str_ver[num_ver] <> ch_ver) then
        f_ver_ch := false;
      inc(num_ver);
    end;

  end;


  function f_start_del_simvol (const str_in : string; const char_in : Char) : string;
  var
    str_t : string;
    num_t : byte;

  begin
    str_t := str_in;

    // start
    num_t := 1;
    while (str_t[num_t] = char_in) do
      inc(num_t);
    if (num_t <> 1) then
      str_t := copy(str_t, num_t, length(str_t) - num_t +1);

    f_start_del_simvol := str_t;
  end;

  function f_end_del_simvol (const str_in : string; const char_in : Char) : string;
  var
    str_t : string;
    num_t : byte;

  begin
    str_t := str_in;

    // end
    num_t := length(str_t);
    while (str_t[num_t] = char_in) do
      num_t := outc(num_t);
    if (num_t <> length(str_t)) then
      str_t := copy(str_t, 1, num_t);

    f_end_del_simvol := str_t;
  end;

  function f_start_end_del_simvol (const str_in : string; const char_in : Char) : string;
  var
    str_t : string;

  begin
    str_t := str_in;
    str_t := f_end_del_simvol(str_t, char_in);
    str_t := f_start_del_simvol(str_t, char_in);

    f_start_end_del_simvol := str_t;

  end;

  function f_start_end_del_str_simvol (const str_in : string; const str_char_in : string) : string;
  var
    num_t, num_t2 : byte;

  begin
    f_start_end_del_str_simvol := str_in;
    for num_t2 := 1 to length(str_char_in) do
    begin
      for num_t := 1 to length(str_char_in) do
        f_start_end_del_str_simvol := f_start_end_del_simvol(f_start_end_del_str_simvol, str_char_in[num_t]);
    end;

  end;

  function f_in_per_end(in_per_end, out_per_and : string) : string;

  begin
    in_per_end := f_re_string_pos_end(in_per_end, out_per_and);
    in_per_end := f_re_string_pos_start(in_per_end, f_enter_wr);
    in_per_end := f_start_end_del_str_simvol(in_per_end, ' ' + #34 + #39);
{
    if (pos('"', in_per_end) <> 0) then
    begin
      if f_col_sim_str(in_per_end, '"') = 2 then
        in_per_end := f_sim_in_out_del(in_per_end, '"') else
        in_per_end := f_sim_del(in_per_end, '"');
     end;
}
    f_in_per_end := in_per_end;
  end;

  procedure p_re_str (const in_re_str, in_re_str_pos : string; var in_re_str_in, in_re_str_out : string);

  begin
    if (pos(UpCase(in_re_str_pos), UpCase(in_re_str)) <> 0) then
    begin
      in_re_str_in := Copy(in_re_str, 1, pos(UpCase(in_re_str_pos), UpCase(in_re_str)) -1);
      in_re_str_out := Copy(in_re_str, pos(UpCase(in_re_str_pos), UpCase(in_re_str)) + length(UpCase(in_re_str_pos)), length(UpCase(in_re_str)) - (pos(UpCase(in_re_str_pos), UpCase(in_re_str)) + length(UpCase(in_re_str_pos))) +1);
    end else
    begin
      in_re_str_in := '';
      in_re_str_out := '';
    end;
  end;

  function f_re_string_pos (const str_re_string_in, str_re_string_out, str_re_string_new : string) : string;

  begin
    f_re_string_pos := str_re_string_in;
    while (pos(UpCase(str_re_string_out), UpCase(f_re_string_pos)) <> 0) do
      f_re_string_pos := Copy(f_re_string_pos, 1, pos(UpCase(str_re_string_out), UpCase(f_re_string_pos)) -1) + str_re_string_new + Copy(f_re_string_pos, pos(UpCase(str_re_string_out), UpCase(f_re_string_pos)) + length(UpCase(str_re_string_out)), length(UpCase(f_re_string_pos)) - (pos(UpCase(str_re_string_out), UpCase(f_re_string_pos)) + length(UpCase(str_re_string_out))) +1);
  end;

  function f_re_string_pos_end (const str_re_string_in, str_re_string_out : string) : string;

  begin
    f_re_string_pos_end := str_re_string_in;
    if (pos(UpCase(str_re_string_out), UpCase(str_re_string_in)) <> 0) and (str_re_string_out <> '') then
      f_re_string_pos_end := Copy(str_re_string_in, pos(UpCase(str_re_string_out), UpCase(str_re_string_in)) + length(UpCase(str_re_string_out)), length(UpCase(str_re_string_in)) - (pos(UpCase(str_re_string_out), UpCase(str_re_string_in)) + length(UpCase(str_re_string_out))) +1);
  end;

  function f_re_string_pos_start (const str_re_string_in, str_re_string_out : string) : string;

  begin
    f_re_string_pos_start := str_re_string_in;
    if (pos(UpCase(str_re_string_out), UpCase(str_re_string_in)) <> 0) and (str_re_string_out <> '') then
      f_re_string_pos_start := Copy(str_re_string_in, 1, pos(UpCase(str_re_string_out), UpCase(str_re_string_in)) -1);
  end;

  function f_nol2(const string_plus_nol : string) : string;
  var
    str_t : string;

  begin
    str_t := string_plus_nol;
    while Length (str_t) < 2 do
      str_t := '0' + str_t;
    f_nol2 := str_t;
  end;

  function f_re_sim_sl (const re_sim_sl : string) : string;
    {$ifdef Win32}
  var
    str_t : string;
    {$endif}

  begin
    f_re_sim_sl := re_sim_sl;
    {$ifdef Win32}
    str_t := re_sim_sl + '\';
    while (pos('\', str_t) <> 0) do
      str_t := Copy(str_t, 1, pos('\', str_t) -1) + '/' + Copy(str_t, pos('\', str_t) +1, length(str_t) - pos('\', str_t));
    f_re_sim_sl := f_end_del_simvol(str_t, '/');
    {$endif}

  end;

  function f_dir (const path_sp : string) : string;

  begin
    num_t := length(path_sp);
    while ((path_sp[num_t] <> '/') and (path_sp[num_t] <> '\')) and
          (path_sp[num_t] <> '') and
          (num_t > 0) do
      num_t := outc(num_t);

    if (num_t > 0) and (path_sp[num_t] <> '') and
       ((path_sp[num_t] = '/') or (path_sp[num_t] = '\')) then
      f_dir := Copy(path_sp, 1, num_t) else f_dir := '';
  end;

  function f_nix_dir (in_dir : string) : boolean;

  begin
    if (pos('://', in_dir) <> 0) then
      f_nix_dir := true else f_nix_dir := false;

  end;

  function f_prog_name : string;
  var
    put_prog_file : string;

  begin
    put_prog_file := ParamStr(0);
    num_t := length(put_prog_file);
    while (put_prog_file[num_t] <> '/') and (put_prog_file[num_t] <> '\') do
      num_t := outc(num_t);
    f_prog_name := Copy(put_prog_file, num_t +1, length(put_prog_file) - num_t);

  end;

  function f_prog_dir : string;

  begin
    f_prog_dir := f_dir(ParamStr(0));
  end;

  function f_file_name_del_ext (const prog_name_del_ext : string) : string;
  var
    put_prog_file : string;

  begin
    put_prog_file := prog_name_del_ext;
    if (pos('.', put_prog_file) <> 0) then
    begin
      num_t := length(put_prog_file);
      while (copy(put_prog_file, num_t, 1) <> '.') do
        num_t := outc(num_t);
      f_file_name_del_ext := Copy(put_prog_file, 1, num_t -1);
    end else
      f_file_name_del_ext := put_prog_file;

  end;

  function cat_ver (const str_cat_ver : string) : boolean;

  begin
     cat_ver := (str_cat_ver[length(str_cat_ver) -1] = ':');
  end;

  function f_expand(const in_put_file_expand : string) : string;

  begin
    f_expand := f_re_sim_sl(in_put_file_expand);
    // d:/ home:/
    if (pos(':', f_expand) = 0) then
      f_expand := f_re_sim_sl(f_prog_dir + f_start_del_simvol(f_expand, '/'));

    if (not dir_exist(f_dir(f_expand))) and (not f_nix_dir(f_dir(f_expand))) and
       (not cat_ver(f_dir(f_expand))) then
    begin
      {$I-} mkDir(f_dir(f_expand)); {$I+}
      if not (IOResult = 0) then
      begin
        pro_const. put_file_error_path := f_expand;
        p_lang('error_path', true);
      end;
    end;
  end;

  function f_file_ext (const path_sp : string) : string;

  begin
    num_t := length(path_sp);
    while (path_sp[num_t] <> '.') and
          (path_sp[num_t] <> '') and
          (num_t > 0) do
      num_t := outc(num_t);

    if (num_t > 0) and (path_sp[num_t] <> '') and
       (path_sp[num_t] = '.') then
      f_file_ext := Copy(path_sp, num_t +1, length(path_sp) - num_t)
                                      else
      f_file_ext := '';
  end;


  function f_sim_del(const in_sim_del : string; const sim_del : Char) : string;
  var
    in_sim_del_t : string;

  begin
    in_sim_del_t := in_sim_del;
    while (pos(sim_del, in_sim_del_t) <> 0) do
      in_sim_del_t := Copy(in_sim_del_t, 1, pos(sim_del, in_sim_del_t) -1) + Copy(in_sim_del_t, pos(sim_del, in_sim_del_t) +1, length(in_sim_del_t) - pos(sim_del, in_sim_del_t));

    f_sim_del := in_sim_del_t;
  end;

  function f_col_sim_str(const col_sim_str : string; const col_sim_str_char : char) : byte;
  var
    col_sim, col_sim_t : byte;
    col_sim_str_t : string;

  begin
    col_sim_t := 1; col_sim := 0;
    col_sim_str_t := Copy(col_sim_str, col_sim_t, 1);
    while col_sim_str_t <> '' do
    begin
      if col_sim_str_t = col_sim_str_char then
        inc(col_sim);
      inc(col_sim_t);
      col_sim_str_t := Copy(col_sim_str, col_sim_t, 1);
    end;
    f_col_sim_str := col_sim;
  end;

  // вырезать то, что между двумя символами "sim_in_out"
  function f_sim_in_out_del (const sim_in_out_del : string; const sim_in_out : Char) : string;
  var
    sim_in_out_del_t : string;
    pos_sim_in_out_del : byte;

  begin
    sim_in_out_del_t := sim_in_out_del;
    pos_sim_in_out_del := pos(sim_in_out, sim_in_out_del_t);
    sim_in_out_del_t := Copy(sim_in_out_del_t, pos_sim_in_out_del +1, length(sim_in_out_del_t) - pos_sim_in_out_del);
    pos_sim_in_out_del := pos(sim_in_out, sim_in_out_del_t);
    sim_in_out_del_t := Copy(sim_in_out_del_t, 1, pos_sim_in_out_del -1);

    f_sim_in_out_del := sim_in_out_del_t;
  end;

  function f_file_name(const file_name : string) : string;
  var
    num_file_name_t : byte;
  begin
    num_file_name_t := length(file_name);
    while (file_name[num_file_name_t] <> '/') and
          (file_name[num_file_name_t] <> '\') and
          (file_name[num_file_name_t] <> '') do
    num_file_name_t := outc(num_file_name_t);

    if (file_name[num_file_name_t] <> '') then
      f_file_name := Copy(file_name, num_file_name_t +1, length(file_name) - num_file_name_t)
    else
      f_file_name := file_name;

  end;


end.