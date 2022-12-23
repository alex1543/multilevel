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

unit pro_lang;

interface
var
  convert_code : string = ('Unknown');


  function f_lang_re (in_lang_re : string) : string;
  function lang_re_set(const in_str_set, in_str_reset : string) : boolean;

var
  bool_exit : boolean = (false);
  procedure p_lang (const str_p_lang : string; const bool_error_exit : boolean);

  function put_first_lang_file : string;
  procedure p_io_lang_file(const put_io_lang_file : string);


implementation

uses
  crt, dos,

  pro_util, pro_string, pro_dt, pro_const,
  pro_ch, pro_files, pro_par, pro_wk, pro_dtb;

  function par_cfg_in_str_macros (const str_par_cfg_in_str_macros : string; const num_par_cfg_in_str_macros : byte) : boolean;
  var
    num_t : byte;

  begin
    num_t := 1;
    while (UpCase(par_cfg[pro_const. num_rss][num_par_cfg_in_str_macros][num_t]) <> UpCase(str_par_cfg_in_str_macros)) and
          (par_cfg[pro_const. num_rss][num_par_cfg_in_str_macros][num_t] <> '') do inc(num_t);
    if (UpCase(par_cfg[pro_const. num_rss][num_par_cfg_in_str_macros][num_t]) = UpCase(str_par_cfg_in_str_macros)) then
      par_cfg_in_str_macros := true else par_cfg_in_str_macros := false;

  end;

var
// длинна строки в макросе @read: по дефолту
  length_read_string : byte = 60;
  bool_read : boolean = false;

    function f_lang_re (in_lang_re : string) : string;
    var
      num_t_lang : byte;

      procedure p_re_string(in_re_string, out_re_string : string);
      var
        str_lang_out, str_t, str_out : string;

      begin
        if (bool_read) then // при макросе @read: не обрезаем
           str_out := out_re_string else
           str_out := length_copy(out_re_string, length_read_string);
        if (pos(sim_lang_id + UpCase(in_re_string), UpCase(in_lang_re)) <> 0) then
        begin
          str_t := f_re_string_pos_start(in_lang_re, sim_lang_id + in_re_string);
          str_lang_out := f_re_string_pos_end(in_lang_re, sim_lang_id + in_re_string);
          // Если id макроса удвоен, то макрос не выполняется
          if (str_t[length(str_t)] <> sim_lang_id) and (not par_cfg_in_str_macros(in_re_string, 29)) then
          begin
            if (str_lang_out[1] <> '_') and (str_lang_out[1] <> sim_exec) then
            begin
              // при символе "#" макросы обрабатываются только тогда, когда чему-то равны
              if not (((str_lang_out[1] = sim_view) or par_cfg_in_str_macros(in_re_string, 30)) and (str_out = '')) then
              begin
                if (str_lang_out[1] = sim_view) then
                  in_lang_re := f_re_string_pos(in_lang_re, sim_lang_id + in_re_string + sim_view, str_out) else
                  in_lang_re := f_re_string_pos(in_lang_re, sim_lang_id + in_re_string, str_out);
              end;
            end;
          end else
          begin
            // если задать переменную daseble в конфиге, то макрос тоже будет не выполнен
            if (not par_cfg_in_str_macros(in_re_string, 29)) then
              in_lang_re := str_t + in_re_string + str_lang_out else
              in_lang_re := str_t + sim_lang_id + in_re_string + str_lang_out;
          end;
        end;
      end;

    var
      lang_in, lang_out : Array[1..22] of string[150];
      lang_in_dt, lang_out_dt : Array[1..7] of string[10];

    begin
      lang_in_dt[ 1] := 'hour';   lang_out_dt[ 1] := hour;
      lang_in_dt[ 2] := 'minute'; lang_out_dt[ 2] := minute;
      lang_in_dt[ 3] := 'second'; lang_out_dt[ 3] := second;
      lang_in_dt[ 4] := 'year';   lang_out_dt[ 4] := year;
      lang_in_dt[ 5] := 'month'; lang_out_dt[ 5] := month_const;
      lang_in_dt[ 6] := 'day';    lang_out_dt[ 6] := day;
      lang_in_dt[ 7] := 'week';   lang_out_dt[ 7] := week_const;

      num_t_lang := 1;
      while (lang_in_dt[num_t_lang] <> '') do
      begin
        p_re_string(lang_in_dt[num_t_lang], lang_out_dt[num_t_lang]);
        inc(num_t_lang);
      end;

      lang_in[ 1] := 'logtime';    lang_out[ 1] := date_and_time(2);
      lang_in[ 2] := 'code';       lang_out[ 2] := pro_lang. convert_code;
      lang_in[ 3] := 'news';       lang_out[ 3] := pro_const. str_teg;
      lang_in[ 4] := 'mode_news';  lang_out[ 4] := f_num2str(pro_const. num_re_str);
      lang_in[ 5] := 'version';    lang_out[ 5] := by_Rain;
      lang_in[ 6] := 'open';       lang_out[ 6] := pro_const. put_file_error_open;
      lang_in[ 7] := 'cycle';      lang_out[ 7] := f_num2str(pro_const. num_cycle);
      lang_in[ 8] := 'number';     lang_out[ 8] := f_num2str(pro_const. num_rss);
      lang_in[ 9] := 'file';       lang_out[ 9] := pro_const. file_ex;
      lang_in[10] := 'msg';        lang_out[10] := f_num2str(pro_const. num_msg);
      lang_in[11] := 'cfg';        lang_out[11] := pro_const. put_file_cfg;
      lang_in[12] := 'program';    lang_out[12] := f_file_name_del_ext(f_prog_name);
      lang_in[13] := 'multi';      if (multi) then lang_out[13] := 'TRUE' else lang_out[13] := 'FALSE';
      lang_in[14] := 'home';       lang_out[14] := f_expand('');
      lang_in[15] := 'assembly';   lang_out[15] := assembly;
      lang_in[16] := 'br';         lang_out[16] := f_enter_wr;
      lang_in[17] := 'q_news';     lang_out[17] := f_num2str(q_news);
      lang_in[18] := 'q_item';     lang_out[18] := f_num2str(q_item);
      lang_in[19] := 'writetime';  lang_out[19] := pro_const. writetime;
      lang_in[20] := 'exist';      lang_out[20] := pro_const. put_file_error_exist;
      lang_in[21] := 'path';       lang_out[21] := pro_const. put_file_error_path;
      lang_in[22] := 'pkt';        lang_out[22] := pro_const. put_file_pkt;

      num_t_lang := 1;
      while (lang_in[num_t_lang] <> '') do
      begin
        p_re_string(lang_in[num_t_lang], lang_out[num_t_lang]);
        inc(num_t_lang);
      end;
      // так же работают макросы из config файла
      num_t_lang := 1;
      while (const_cfg[num_t_lang] <> '') do
      begin
        p_re_string(const_cfg[num_t_lang], put_cfg_ver_cp_conv(par_cfg[pro_const. num_rss][num_t_lang][pro_const. num_tplus], 866, num_t_lang));
        inc(num_t_lang);
      end;
      // так же работают макросы, установленные в config файле
      num_t_lang := 1;
      while (pro_const. str_set[num_t_lang] <> '') do
      begin
        p_re_string(pro_const. str_set[num_t_lang], pro_const. str_reset[num_t_lang]);
        inc(num_t_lang);
      end;

      f_lang_re := in_lang_re;
    end;


    function lang_re_set(const in_str_set, in_str_reset : string) : boolean;
    var
      num_set_t : byte;

    begin

      lang_re_set := false;

      // зарезервированные макросы в качестве переменных конфиг. файла
      if (not lang_re_set) then
      begin
        num_set_t := 1;
        while (const_cfg[num_set_t] <> '') and
              (UpCase(in_str_set) <> UpCase(const_cfg[num_set_t])) do
          inc(num_set_t);
        if (UpCase(in_str_set) = UpCase(const_cfg[num_set_t])) then
        begin
          par_cfg[pro_const. num_rss][num_set_t][pro_const. num_tplus] := put_cfg_ver_cp_conv(in_str_reset, 1251, num_set_t);
          lang_re_set := true;
        end;
      end;

      // установленные макросы в процессе работы программы (@read: или @set)
      if (not lang_re_set) then
      begin
        num_set_t := 1;
        while (pro_const. str_set[num_set_t] <> '') and
              (UpCase(in_str_set) <> UpCase(pro_const. str_set[num_set_t])) do
          inc(num_set_t);
        pro_const. str_reset[num_set_t] := in_str_reset;
        pro_const. str_set[num_set_t] := in_str_set;
        lang_re_set := true;
      end;
    end;

  procedure p_lang (const str_p_lang : string; const bool_error_exit : boolean);

  var
    line, line_read : string;
    lang_end : string;
    put_file_lang_wr : string;
    file_lang_wr : text;
    lang_arg1, lang_arg2 : longint;
    lang_arg_str : string;
    pre_line : string;
    num_str, num_enter : longint;
    exit_code : longint;
    str_lang_in : string;


    function f_lang_wr (line_wr, lang_wr : string) : string;
    var
      num_t : byte;
      str_t : string;


    begin
      str_t := f_in_per_end (line_wr, lang_wr);
      num_t := 2;
      while (str_t[num_t] <> '') and
            (str_t[num_t] <> ' ') and
            (str_t[num_t] <> ',') and
            (str_t[num_t] <> sim_lang_id) and
            (str_t[num_t] <> sim_exec) do
        inc(num_t);
      num_t := outc(num_t);
      f_lang_wr := Copy(str_t, 1, num_t);

    end;


    procedure p_sec_enter(num_sec_enter : longint);
    var
      num_t_sec_enter : longint;
      sw_key : string;

    begin
      while keypressed do
        sw_key := readkey;

      num_t_sec_enter := 1; sw_key := '';
      repeat
        if keypressed then
          sw_key := readkey;

        delay(60);

        pro_const. file_ex := 'exit.ok';
        if file_exist(pro_const. file_ex) then
        begin
          p_lang('file', false);
          sw_key := #27;
        end;
        pro_const. file_ex := 'next.ok';
        if file_exist(pro_const. file_ex) then
        begin
          p_lang('file', false);
          sw_key := #13;
        end;

        if (sw_key <> '') then
        begin
          if (sw_key = #0) then
          begin
            sw_key := readkey;
            if not (sw_key = #45) then // Alt+X = Esc
              p_lang('key#F' + rf1f12(sw_key[1]), false) else
              sw_key := #27;
          end else
            p_lang('key#' + sw_key, false);

          if ((sw_key = #27) or (UpCase(sw_key) = 'N')) or
             ((sw_key = #13) or (UpCase(sw_key) = 'Y') or (sw_key = ' ')) then
            bool_exit := true else
          begin
            sw_key := '';
            p_lang(str_p_lang, false);
          end;

        end;

        inc(num_t_sec_enter);
      until (num_t_sec_enter > num_sec_enter*10) or (bool_exit);

      if ((sw_key = #13) or (UpCase(sw_key) = 'Y') or (sw_key = ' ')) then
        bool_exit := false;

    end;

    procedure beep (const freq_beep, delay_beep : longint);

    begin
      Sound(freq_beep);
      delay(delay_beep);
      NoSound;
    end;

    procedure color (const text_color, back_color : longint);

    begin
      TextColor(text_color);
      TextBackGround(back_color);
    end;

    function f_lang_re_str (var line : string; const str_pos : string; var lang_arg1, lang_arg2 : longint) : boolean;

    begin
      if (pos(UpCase(str_pos), UpCase(line)) <> 0) then
      begin
        lang_arg1 := f_str2num(f_lang_wr(line, str_pos));
        lang_arg_str := f_in_per_end(line, str_pos);
        if (pos(',', line) <> 0) then
          lang_arg2 := f_str2num(f_lang_wr(lang_arg_str, ',')) else
          lang_arg2 := 0;

        line := readLn_ch_to_enter(ch_lng, num_str);
        f_lang_re_str := true;
      end else
        f_lang_re_str := false;
    end;

    function ver_lang_teg (const line, teg_ver : string) : boolean;

    begin

    if (UpCase(f_sim_del(line, ' ')) = UpCase('[' + teg_ver + ']')) then
      ver_lang_teg := true else
      ver_lang_teg := false;

    end;

  begin
    lang_end := 'END';
    num_str := 0; // с первой строки читаем ch_lng
    num_enter := read_ch_enter_all(ch_lng);
    line := readLn_ch_to_enter(ch_lng, num_str);
    while (num_str < num_enter) and (not ver_lang_teg(line, str_p_lang)) do
      line := readLn_ch_to_enter(ch_lng, num_str);

    if (ver_lang_teg(line, str_p_lang)) then
    begin
      line := readLn_ch_to_enter(ch_lng, num_str);
      while (num_str < num_enter) and (not ver_lang_teg(line, lang_end)) do
      begin
        if (f_lang_re_str(line, sim_lang_id + 'delay' + sim_exec, lang_arg1, lang_arg2)) and
           (UpCase(str_p_lang) <> UpCase('delay')) and (not bool_exit) then
        begin
          p_lang('delay', false);
          p_sec_enter(lang_arg1);
          if bool_exit then
            p_lang('exit', false);
          continue;
        end;
        if (pos(sim_lang_id + UpCase('exit'), UpCase(line)) <> 0) and
           (UpCase(str_p_lang) <> UpCase('macros')) and (not bool_exit) then
        begin
          p_re_str(line, sim_lang_id + 'exit', pre_line, line);
          bool_exit := true;
          p_lang('macros', false);
        end;

        if (pos(sim_lang_id + UpCase('clear'), UpCase(line)) <> 0) then
        begin
          p_re_str(line, sim_lang_id + 'clear', pre_line, line);
          ClrScr;
          line := readLn_ch_to_enter(ch_lng, num_str);
          continue;
        end;
        if (pos(sim_lang_id + UpCase('key'), UpCase(line)) <> 0) and
           (UpCase(str_p_lang) <> UpCase('key')) then
        begin
          p_lang('key', false);
          p_re_str(line, sim_lang_id + 'key', pre_line, line);
          readkey;
          continue;
        end;

        if (pos(sim_lang_id + UpCase('help'), UpCase(line)) <> 0) then
        begin
          p_par('help', false);
          line := readLn_ch_to_enter(ch_lng, num_str);
          continue;
        end;
        if (pos(sim_lang_id + UpCase('info'), UpCase(line)) <> 0) then
        begin
          p_par('info', false);
          line := readLn_ch_to_enter(ch_lng, num_str);
          continue;
        end;
        if (pos(sim_lang_id + UpCase('copyright'), UpCase(line)) <> 0) then
        begin
          p_wr_copyright(false);
          line := readLn_ch_to_enter(ch_lng, num_str);
          continue;
        end;

        if (f_lang_re_str(line, sim_lang_id + 'level' + sim_exec, lang_arg1, lang_arg2)) or
           (f_lang_re_str(line, sim_lang_id + 'errorlevel' + sim_exec, lang_arg1, lang_arg2)) then
        begin
          exit_code := lang_arg1;
          continue;
        end;
        if (f_lang_re_str(line, sim_lang_id + 'error' + sim_exec, lang_arg1, lang_arg2)) then
          halt(lang_arg1);

        if (f_lang_re_str(line, sim_lang_id + 'length' + sim_exec, lang_arg1, lang_arg2)) then
        begin
          length_read_string := lang_arg1;
          continue;
        end;

        if (f_lang_re_str(line, sim_lang_id + 'beep' + sim_exec, lang_arg1, lang_arg2)) then
        begin
          beep(lang_arg1, lang_arg2);
          continue;
        end;
        if (f_lang_re_str(line, sim_lang_id + 'goto' + sim_exec, lang_arg1, lang_arg2)) then
        begin
          gotoXY(lang_arg1, lang_arg2);
          continue;
        end;
        if (f_lang_re_str(line, sim_lang_id + 'color' + sim_exec, lang_arg1, lang_arg2)) then
        begin
          color(lang_arg1, lang_arg2);
          continue;
        end;

        lang_arg_str := sim_exec;
        if (pos(UpCase(sim_lang_id), UpCase(line)) <> 0) and
           (pos(UpCase(lang_arg_str), UpCase(line)) <> 0) and
           (not bool_error_exit) and (not bool_exit) then
        begin
          str_lang_in := Copy(line, pos(sim_lang_id, line), pos(lang_arg_str, line) - pos(sim_lang_id, line) + length(lang_arg_str));
          str_lang_in := f_lang_re(str_lang_in);
          lang_arg_str := f_in_per_end(line, str_lang_in);
          lang_arg_str := f_lang_re(lang_arg_str);
          if par_cfg_macros(str_lang_in, lang_arg_str) then
          begin
            line := readLn_ch_to_enter(ch_lng, num_str);
            continue;
          end;
        end;
        lang_arg_str := '_all';
        if (pos(UpCase(sim_lang_id), UpCase(line)) <> 0) and
           (pos(UpCase(lang_arg_str), UpCase(line)) <> 0) and
           (not bool_error_exit) and (not bool_exit) then
        begin
          str_lang_in := Copy(line, pos(sim_lang_id, line), pos(lang_arg_str, line) - pos(sim_lang_id, line) + length(lang_arg_str));
          str_lang_in := f_lang_re(str_lang_in);
          lang_arg_str := f_in_per_end(line, str_lang_in);
          lang_arg_str := f_lang_re(lang_arg_str);
          if par_cfg_macros(str_lang_in, '') then
          begin
            line := readLn_ch_to_enter(ch_lng, num_str);
            continue;
          end;
        end;

        lang_arg_str := 'geter' + sim_exec;
        if (pos(sim_lang_id + UpCase(lang_arg_str), UpCase(line)) <> 0) then
        begin
          lang_arg_str := f_lang_wr(line, lang_arg_str);
          if (lang_arg_str[1] = sim_lang_id) then
          begin
            lang_arg_str := Copy(lang_arg_str, 2, length(lang_arg_str) -1);
            if GeterSeter(lang_arg_str, true) then
            begin
              line := readLn_ch_to_enter(ch_lng, num_str);
              continue;
            end;
          end;
        end;
        lang_arg_str := 'seter' + sim_exec;
        if (pos(sim_lang_id + UpCase(lang_arg_str), UpCase(line)) <> 0) then
        begin
          lang_arg_str := f_lang_wr(line, lang_arg_str);
          if (lang_arg_str[1] = sim_lang_id) then
          begin
            lang_arg_str := Copy(lang_arg_str, 2, length(lang_arg_str) -1);
            if GeterSeter(lang_arg_str, false) then
            begin
              line := readLn_ch_to_enter(ch_lng, num_str);
              continue;
            end;
          end;
        end;

        lang_arg_str := 'line' + sim_exec;
        if (pos(sim_lang_id + UpCase(lang_arg_str), UpCase(line)) <> 0) then
        begin
          lang_arg1 := f_str2num(f_lang_wr(line, lang_arg_str));
          lang_arg_str := f_lang_wr(Copy(line, pos(',', line) +1, length(line) - pos(',', line)), '');

          WriteLnX(lang_arg1, lang_arg_str);
          line := readLn_ch_to_enter(ch_lng, num_str);
          continue;
        end;
        lang_arg_str := 'read' + sim_exec;
        if (pos(sim_lang_id + UpCase(lang_arg_str), UpCase(line)) <> 0) then
        begin
          lang_arg_str := f_lang_wr(line, lang_arg_str);
          if (pos(sim_lang_id, lang_arg_str) <> 0) then
          begin
            bool_read := true;
            line_read := f_lang_re(lang_arg_str);
            bool_read := false;
            ReadLnSt(line_read, length_read_string);
            lang_arg_str := f_in_per_end(lang_arg_str, sim_lang_id);
            line_read := f_in_per_end(line_read, '');
            lang_re_set(lang_arg_str, f_lang_re(line_read));
            line := readLn_ch_to_enter(ch_lng, num_str);
            continue;
          end;
        end;
        lang_arg_str := 'set' + sim_exec;
        if (pos(sim_lang_id + UpCase(lang_arg_str), UpCase(line)) <> 0) then
        begin
          lang_arg_str := f_lang_wr(line, lang_arg_str);
          if (pos(sim_lang_id, lang_arg_str) <> 0) then
          begin
            line_read := f_lang_re(f_in_per_end(line, lang_arg_str));
            lang_arg_str := f_in_per_end(lang_arg_str, sim_lang_id);
            lang_re_set(lang_arg_str, line_read);
            line := readLn_ch_to_enter(ch_lng, num_str);
            continue;
          end;
        end;
        lang_arg_str := 'window' + sim_exec;
        if (pos(sim_lang_id + UpCase(lang_arg_str), UpCase(line)) <> 0) then
        begin
          SetWindowSt(f_lang_re(f_in_per_end(line, lang_arg_str)));
          line := readLn_ch_to_enter(ch_lng, num_str);
          continue;
        end;

        if (pos(sim_lang_id + UpCase('file' + sim_exec), UpCase(line)) <> 0) then
        begin
          put_file_lang_wr := f_lang_wr(line, sim_lang_id + 'file' + sim_exec);
          line := f_lang_re(f_in_per_end(line, put_file_lang_wr));
          put_file_lang_wr := f_expand(put_file_lang_wr);

          Assign(file_lang_wr, put_file_lang_wr);
          if not file_exist(put_file_lang_wr) then
          begin
            rewrite(file_lang_wr);
            if (UpCase(f_file_ext(put_file_lang_wr)) = 'LOG') then
              WriteLn(file_lang_wr, f_lang_re('@logtime Logfile created ' + by_Rain));
          end else
          begin
            p_io_file(put_file_lang_wr);
            append(file_lang_wr);
          end;
          WriteLn(file_lang_wr, line);
          close(file_lang_wr);

          line := readLn_ch_to_enter(ch_lng, num_str);
          continue;
        end;

        WriteLn(f_lang_re(line));
        line := readLn_ch_to_enter(ch_lng, num_str);
      end;
      if (bool_exit) then halt(exit_code); // exit prog.
    end;
    if (bool_error_exit) then
    begin
      bool_exit := true;
      p_lang('error_exit', false);
    end;

  end;

  function put_first_lang_file : string;
  const

    const_lang_name : Array[1..5] of string[50] =
('*.lng', '*.lang', 'language/*.lng', 'language/*.lang', '');

  var
    SR : SearchRec;
    num_temp : longint;

  begin
    num_temp := 0;
    repeat
      inc(num_temp);
      FindFirst(f_expand('') + '/' + const_lang_name[num_temp], AnyFile, SR);
      FindClose(SR);
    until (DosError = 0) or (const_lang_name[num_temp] = '');
    if (DosError = 0) then
      put_first_lang_file := f_expand(SR.Name)
                      else
    begin
      WriteLn('Error search *.lng file in the directory');
      delay(600);
      WriteLn;
      halt(11);
    end;
  end;


  procedure p_io_lang_file(const put_io_lang_file : string);
  var 
    io_lang_file : text; 

  begin
    Assign(io_lang_file, put_io_lang_file);
    {$I-} reset(io_lang_file); {$I+}
    if IOResult <> 0 then
    begin
      WriteLn('Error opening language file: ', put_io_lang_file);
      delay(600);
      WriteLn;
      halt(12);
    end;
    close(io_lang_file);
  end;


end.