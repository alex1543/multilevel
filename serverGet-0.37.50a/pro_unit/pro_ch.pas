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

unit pro_ch;

interface

  procedure ReadChBlock (const ChIn : PChar; var ChOut : PChar; const length_pos : longint; var num_pos : longint);
  function strLen(const in_strLen : PChar) : longint;
  function f_pos_ch(const ch_pos : PChar; const str_verif : string; const num_ch : longint) : boolean;
  procedure file_add(var file_create_out : file of byte; const str_add : string);
  procedure file_add_ch(var file_create_out : file of byte; const ch_add : PChar);
  procedure file_create(const ch_create : PChar; const put_file_create : string);
  procedure load_file_ch_fast(var ch_load : PChar; const put_file_in_read : string; str_sim_comment : string; const bool_null_str : boolean);
  procedure p_load_file_ch_all(var ch_load : PChar; const put_file_in_read : string);
  function readLn_ch(const ch_readLn : PChar; const in_rlnch, out_rlnch : word) : string;
  function readLn_ch_to_enter(const ch_readLn : PChar; var in_rlnch : longint) : string;
  function read_ch_enter_all(const ch_readLn : PChar) : longint;
  procedure load_file_ch_include_fast (var ch_inc : PChar; const str_include, str_sim_comment : string);
  function auto_code(const ch_auto_code : PChar; var str_auto_code : string) : boolean;

  function f_read_fb(var file_in_read : file of byte; num_read_fb : longint) : byte;
  procedure p_add_ch (var ch_add : PChar; var num_ch : longint; const str_add : string);
  procedure p_add_ch_fast (var ch_add : PChar; var num_ch : longint; const str_add : string);
  procedure p_add_ch_ch (var ch_add : PChar; var num_ch : longint; const ch_add_ch : PChar);
  procedure chToch_fast (var ch_add : PChar; var num_ch : longint; const ch_add_ch : PChar);

  procedure p_ch_end_fast (var ch_end : PChar; const num_ch_end : longint);
  function eof_ch (const ch_eof : PChar; num_eof : longint) : boolean;
  function f_ch (const ch_in1, ch_in2 : PChar) : boolean;
  function f_ver_ch (const ch_ver : PChar; const pos_ch_ver, length_ch_ver : longint; var out_pos : longint) : boolean;
  function ch_get_str (const chToStr : PChar; const num_in, num_out : longint) : string;

  function strToch (const in_str : string) : PChar;
  function chToStr (const in_ch : PChar) : string;

  procedure view_file (const str_view_file : string);

implementation

uses
  crt, dos,

  pro_util, pro_files, pro_string;


  procedure view_file (const str_view_file : string);
  var
    ch_t : PChar;

  begin
    p_load_file_ch_all(ch_t, str_view_file);
    Write(ch_t);
    ch_t := nil;
  end;

  procedure ReadChBlock (const ChIn : PChar; var ChOut : PChar; const length_pos : longint; var num_pos : longint);
  var
    num_t : longint;

  begin
    num_t := 0; ChOut := nil;
    ReallocMem(ChOut, length_pos);
    while (not eof_ch(ChIn, num_pos)) and (num_t <= length_pos) do
    begin
     ChOut[num_t] := ChIn[num_pos];
     inc(num_pos); inc(num_t);
    end;
    p_ch_end_fast(ChOut, num_t);
  end;

  function strToch (const in_str : string) : PChar;
  var
    num_t : longint;

  begin
    num_t := 0; strToch := nil;
    ReallocMem(strToch, length(in_str));
    p_add_ch_fast(strToch, num_t, in_str);
    p_ch_end_fast(strToch, num_t);

  end;

  function chToStr (const in_ch : PChar) : string;
  var
    num_t : longint;

  begin
    num_t := 0; chToStr := '';
    while (not (eof_ch(in_ch, num_t))) and (num_t < SizeOf(string)) do
    begin
      chToStr := chToStr + in_ch[num_t];
      inc(num_t);
    end;

  end;

  function strLen(const in_strLen : PChar) : longint;

  begin
    strLen := 0;
    if (in_strLen <> nil) then
    begin
      while (in_strLen[strLen] <> #0) do
        inc(strLen);
    end;
  end;

  function ch_get_str (const chToStr : PChar; const num_in, num_out : longint) : string;
  var
    num_t : byte;

  begin
    ch_get_str := ''; num_t := 1;
    while (num_in + num_t <= num_out) and (not eof_ch(chToStr, num_in + num_t)) do
    begin
      ch_get_str := ch_get_str + chToStr[num_in + num_t];
      inc(num_t);
    end;

  end;

  function f_ver_ch (const ch_ver : PChar; const pos_ch_ver, length_ch_ver : longint; var out_pos : longint) : boolean;
  var
    str_re_simvl : string;

    procedure p_ver_ch_new_str_re_simvl (const num_plus_re_simvl : byte);
    var
      num_t, num_t2 : byte;

    begin
      num_t := 0;
      while (num_t -1 < length_ch_ver) and
            (not eof_ch(ch_ver, pos_ch_ver + num_t)) do
      begin
        num_t2 := 1;
        while (str_re_simvl[num_t2] <> #0) do
        begin
          if (ch_ver[pos_ch_ver + num_t] = str_re_simvl[num_t2]) and
             (out_pos < pos_ch_ver + num_t + num_plus_re_simvl) then
          begin
            out_pos := pos_ch_ver + num_t + num_plus_re_simvl;
            f_ver_ch := true;
          end;
          inc(num_t2);
        end;
        inc(num_t);
      end;

    end;

  begin
    f_ver_ch := false; out_pos := 0;
    str_re_simvl := #34 + #39 + '([{<' + #0;
    p_ver_ch_new_str_re_simvl(0); // до символа
    str_re_simvl := ' -_*+=?/\^&$#@!~`%)]}>,.' + f_enter_wr + #0;
    p_ver_ch_new_str_re_simvl(1); // переносить строку после символа в строке str_re_simvl

  end;

  function f_ch (const ch_in1, ch_in2 : PChar) : boolean;
  var
    num_ch_in : longint;


  begin
    f_ch := true; num_ch_in := 0;
    while (not eof_ch(ch_in1, num_ch_in)) and (not eof_ch(ch_in2, num_ch_in)) do
    begin
      if (ch_in1[num_ch_in] <> ch_in2[num_ch_in]) then
        f_ch := false;
      inc(num_ch_in);
    end;
  end;

  procedure p_ch_end_fast (var ch_end : PChar; const num_ch_end : longint);

  begin
    ReallocMem(ch_end, num_ch_end);
    ch_end[num_ch_end] := #0;
  end;

  function eof_ch (const ch_eof : PChar; num_eof : longint) : boolean;

  begin
    if (ch_eof = nil) then
      eof_ch := true else
      eof_ch := (ch_eof[num_eof] = #0);
  end;

  function f_pos_ch(const ch_pos : PChar; const str_verif : string; const num_ch : longint) : boolean;
  var
    num_ch_t : byte;
    temp_str_verif : string;

  begin
    temp_str_verif := '';
    num_ch_t := 0;
    while (num_ch_t < length (str_verif)) and
          (not eof_ch(ch_pos, num_ch + num_ch_t)) do
    begin
      temp_str_verif := temp_str_verif + ch_pos[num_ch + num_ch_t];
      inc (num_ch_t);
    end;

    if UpCase(temp_str_verif) = UpCase(str_verif) then
      f_pos_ch := true else
      f_pos_ch := false;
  end;


  procedure file_create(const ch_create : PChar; const put_file_create : string);
  var
    file_create_out : file of byte;
    num_tfco : longint;

  begin
    Assign(file_create_out, put_file_create);
    rewrite(file_create_out);
    num_tfco := 0;
    while (ch_create[num_tfco] <> #0) do
    begin
      write(file_create_out, ord(ch_create[num_tfco]));
      inc(num_tfco);
    end;
    close(file_create_out);
  end;

  procedure file_add(var file_create_out : file of byte; const str_add : string);
  var
    num_tfco : longint;

  begin

    num_tfco := 1;
    while (num_tfco <= length(str_add)) do
    begin
      write(file_create_out, ord(str_add[num_tfco]));
      inc (num_tfco);
    end;

  end;

  procedure file_add_ch(var file_create_out : file of byte; const ch_add : PChar);
  var
    num_tfco : longint;

  begin

    num_tfco := 0;
    while (ch_add[num_tfco] <> #0) do
    begin
      write(file_create_out, ord(ch_add[num_tfco]));
      inc (num_tfco);
    end;

  end;

  function f_read_fb(var file_in_read : file of byte; num_read_fb : longint) : byte;
  var
    fb : byte;

  begin
    seek(file_in_read, num_read_fb);
    read (file_in_read, fb);
    f_read_fb := fb;
  end;

  procedure p_add_ch (var ch_add : PChar; var num_ch : longint; const str_add : string);
  var
    num_t : byte;

  begin
    if (str_add <> '') then
    begin
      ReallocMem(ch_add, num_ch + length(str_add));
      num_t := 1;
      while (num_t <= length(str_add)) do
      begin
        ch_add[num_ch] := str_add[num_t];
        inc(num_ch);
        inc (num_t);
      end;
    end;
  end;

  procedure p_add_ch_fast (var ch_add : PChar; var num_ch : longint; const str_add : string);
  var
    num_t : byte;

  begin
    if (str_add <> '') then
    begin
      num_t := 1;
      while (num_t <= length(str_add)) do
      begin
        ch_add[num_ch] := str_add[num_t];
        inc(num_ch);
        inc (num_t);
      end;
    end;
  end;

  procedure p_add_ch_ch (var ch_add : PChar; var num_ch : longint; const ch_add_ch : PChar);
  var
    ch_add_size_save, ch_size_save : longint;

  begin
    ch_size_save := StrLen(ch_add_ch);
    ReallocMem(ch_add, num_ch + ch_size_save);

    ch_add_size_save := 0;
    while (ch_add_size_save < ch_size_save) do
    begin
      ch_add[num_ch] := ch_add_ch[ch_add_size_save];
      inc(num_ch);
      inc (ch_add_size_save);
    end;

  end;

  procedure chToch_fast (var ch_add : PChar; var num_ch : longint; const ch_add_ch : PChar);
  var
    num_t : longint;

  begin

    num_t := 0;
    while (not eof_ch(ch_add_ch, num_t)) do
    begin
      ch_add[num_ch] := ch_add_ch[num_t];
      inc(num_ch);
      inc (num_t);
    end;

  end;

  procedure load_file_ch_fast(var ch_load : PChar; const put_file_in_read : string; str_sim_comment : string; const bool_null_str : boolean);

  var
    file_in_read : text;
    real_byte : longint;
    line : string;

  begin
    ch_load := nil; real_byte := 0;
    RealLocMem(ch_load, f_file_size(put_file_in_read));
    Assign (file_in_read, put_file_in_read);
    reset(file_in_read);

    repeat
      readLn(file_in_read, line);
      if ((pos(line[1], str_sim_comment) = 0) and (not bool_null_str)) or
         ((pos(line[1], str_sim_comment) = 0) and (bool_null_str) and (f_sim_del(line, ' ') <> '')) then
        p_add_ch_fast(ch_load, real_byte, line + f_enter_wr);
    until (eof(file_in_read));

    close(file_in_read);

    p_ch_end_fast(ch_load, real_byte);
  end;

  procedure load_file_ch_include_fast (var ch_inc : PChar; const str_include, str_sim_comment : string);
  var
    num_str_inc, num_inc, num_str_inc_add : longint;
    line : string;
    put_include : Array of string;
    ch_inc_new, ch_t : PChar;
    num_str_inc_add_size : longint;
    include : boolean;

  begin
    setlength(put_include, 1);
    put_include[1] := '';

  repeat
    num_str_inc := 0;
    repeat
      line := readLn_ch_to_enter(ch_inc, num_str_inc);
      if (UpCase(Copy(line, 1, length(str_include))) = UpCase(str_include)) then
      begin
        line := f_in_per_end(line, str_include);
        line := f_expand(line);
        num_inc := 1;
        while (UpCase(put_include[num_inc]) <> UpCase(line)) and
              (put_include[num_inc] <> '') do
          inc(num_inc);
        if (put_include[num_inc] = '') then
        begin
          setlength(put_include, num_inc +1);
          put_include[num_inc +1] := '';
          put_include[num_inc] := line;
          p_io_file(put_include[num_inc]);
          load_file_ch_fast(ch_t, put_include[num_inc], str_sim_comment, true);

          num_str_inc_add := 0; line := ''; num_str_inc_add_size := 0;
          RealLocMem(ch_inc_new, StrLen(ch_t) + StrLen(ch_inc));
          line := readLn_ch_to_enter(ch_inc, num_str_inc_add);
          while (UpCase(Copy(line, 1, length(str_include))) <> UpCase(str_include)) do
          begin
            p_add_ch_fast(ch_inc_new, num_str_inc_add_size, line + f_enter_wr);
            line := readLn_ch_to_enter(ch_inc, num_str_inc_add);
          end;
          chToch_fast(ch_inc_new, num_str_inc_add_size, ch_t);
          ch_t := nil;
          line := readLn_ch_to_enter(ch_inc, num_str_inc_add); // this include
          repeat
            p_add_ch_fast(ch_inc_new, num_str_inc_add_size, line + f_enter_wr);
            line := readLn_ch_to_enter(ch_inc, num_str_inc_add);
          until (line = '');
          p_ch_end_fast(ch_inc_new, num_str_inc_add_size);
          ch_inc := nil;
          RealLocMem(ch_inc, num_str_inc_add_size);
          num_str_inc_add_size := 0;
          chToch_fast(ch_inc, num_str_inc_add_size, ch_inc_new);
          p_ch_end_fast(ch_inc, num_str_inc_add_size);
          ch_inc_new := nil;
        end;
        include := true;
      end else
        include := false;
    until (line = '');
  until (not include);
  end;

  procedure p_load_file_ch_all(var ch_load : PChar; const put_file_in_read : string);

  var
    file_in_read : file of byte;
    num_t : longint;
    Buff : Pointer;

  begin
    num_t := f_file_size(put_file_in_read);
    if (num_t <> 0) then
    begin
      Assign (file_in_read, put_file_in_read);
      reset(file_in_read);
      Buff := nil;
      RealLocMem(Buff, num_t);
      BlockRead(file_in_read, Buff^, num_t);
      close(file_in_read);

      ch_load := nil;
      RealLocMem(ch_load, num_t);
      ch_load := Buff;
      Buff := nil;
    end else
    begin
      ch_load := nil;
      p_add_ch(ch_load, num_t, 'Attention! Zero file.');
      p_add_ch(ch_load, num_t, 'Path: ' + put_file_in_read);
    end;
    p_ch_end_fast(ch_load, num_t);
  end;

  function readLn_ch(const ch_readLn : PChar; const in_rlnch, out_rlnch : word) : string;
  var
    num_ch_readLn_t, num_enter : longint;

  begin
    readLn_ch := ''; num_ch_readLn_t := 0; num_enter := 0;
    while (not eof_ch(ch_readLn, num_ch_readLn_t)) and (num_enter < out_rlnch) do
    begin
      if (ch_readLn[num_ch_readLn_t] = f_enter_plus) then
        inc(num_enter);
      if (num_enter >= in_rlnch) and (num_enter < out_rlnch) and
         (not f_enter_ver(ch_readLn[num_ch_readLn_t])) then
          readLn_ch := readLn_ch + ch_readLn[num_ch_readLn_t];
      inc(num_ch_readLn_t);
    end;
  end;

  function read_ch_enter_all(const ch_readLn : PChar) : longint;
  var
    num_ch_readLn_t, num_enter : longint;

  begin
    num_ch_readLn_t := 0; num_enter := 0;
    while (not eof_ch(ch_readLn, num_ch_readLn_t)) do
    begin
      if (ch_readLn[num_ch_readLn_t] = f_enter_plus) then
        inc(num_enter);
      inc(num_ch_readLn_t);
    end;
    read_ch_enter_all := num_enter;
  end;

  function readLn_ch_to_enter(const ch_readLn : PChar; var in_rlnch : longint) : string;

  begin
    readLn_ch_to_enter := readLn_ch(ch_readLn, in_rlnch, in_rlnch +1);
    inc(in_rlnch);
  end;

  function auto_code(const ch_auto_code : PChar; var str_auto_code : string) : boolean;
  var
    num_ac_t : longint;
    num_ac_t_c : longint;

    procedure p_get_code(const str_get_code : string);

    begin
      num_ac_t := num_ac_t_c + length(str_get_code);
      num_ac_t_c := num_ac_t;
      repeat
        inc(num_ac_t_c);
      until (ch_auto_code[num_ac_t_c] = #39) or (ch_auto_code[num_ac_t_c] = #34) or
            (eof_ch(ch_auto_code, num_ac_t)) or (ch_auto_code[num_ac_t_c] = '>');
      str_auto_code := UpCase(ch_get_str(ch_auto_code, num_ac_t -1, num_ac_t_c -1));
      auto_code := true;
    end;

  begin
    num_ac_t_c := 0; auto_code := false;
    while (not eof_ch(ch_auto_code, num_ac_t_c)) and (not auto_code) do
    begin
      if (f_pos_ch(ch_auto_code, 'encoding=' + #39, num_ac_t_c)) or
         (f_pos_ch(ch_auto_code, 'encoding=' + #34, num_ac_t_c)) then
        p_get_code('encoding=' + #34);
      if (f_pos_ch(ch_auto_code, 'charset=', num_ac_t_c)) then
        p_get_code('charset=');
      inc(num_ac_t_c);
    end;

    if not (auto_code) then
      str_auto_code := 'NONE_CODE';

  end;

end.