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
{$MODE DELPHI}
unit pro_cfg;

interface

  function GetParConf (const num_rss, num_plus, num_tplus : longint) : string;
  procedure p_read_cfg(const ch_cfg : PChar);
  procedure load_simvol_global(const ch_cfg : PChar; const str_global : string; var char_global : Char);
  procedure p_cfg_file_expand(var put_cfg_file_expand : string; const num_const_cfg : longint);
  procedure p_all_cfg_file_expand(const num_rss_pacfe : longint);

var
  put_language_save, put_template_save : string;

  procedure load_file_save (var ch_sav : PChar; var put_file_save, put_file_new_save : string);
  procedure load_first_template (var put_file_save : string);
  procedure load_first_language (var put_file_save : string);

var
  ltest_dt : longint;
  stest_dt : string;

  procedure test (const test_fmt : string);

implementation

uses
  crt, dos,

  pro_const, pro_lang, pro_util, pro_string, pro_ch, pro_files,

  UnixDate, pro_dt;


  procedure test (const test_fmt : string);

  begin
    if (test_fmt = 'start') then
    begin
      ltest_dt := Dos2UnixDate(GetDateTime);
      stest_dt := date_and_time(2);
    end;

    if (test_fmt = 'end') then
    begin
      ltest_dt := Dos2UnixDate(GetDateTime) - ltest_dt;

      WriteLn('  Statistics processing configuration file:');
      WriteLn(' -------------------------------------------');
      WriteLn(' Period: ', stest_dt, ' to ', date_and_time(2));
      WriteLn(' Seconds and the systems:');
      WriteLn('   [16]  CPU: PI-MMX/166 MGz, RAM: 80 Mb, Windows XP Proff.');
      WriteLn('   [15]  CPU: PI-MMX/150 MGz, RAM: 48 Mb, Windows 2000 SP4 Proff.');
      WriteLn('    [2]  CPU: Celeron/800 MGz, RAM: 384 Mb, Windows XP Proff.');
      WriteLn(' Your system: ', ltest_dt, ' second.');
      WriteLn(' Pause 2 sec.');
      WriteLn;
      delay(1200);
    end;

  end;

  function GetParConf (const num_rss, num_plus, num_tplus : longint) : string;

  begin
    GetParConf := f_lang_re(par_cfg[num_rss][num_plus][num_tplus]);
  end;

  procedure load_first_template (var put_file_save : string);

  begin
    // если template не указан, то будет найден первый с расширением tpl.
    if (put_file_save = '') then
      put_file_save := f_open_first_file ('tpl', 'error_template');
  end;

  procedure load_first_language (var put_file_save : string);

  begin

    if (put_file_save = '') then
      put_file_save := put_first_lang_file;

  end;

  procedure load_file_save (var ch_sav : PChar; var put_file_save, put_file_new_save : string);

  begin
    if (put_file_save <> '') then
    begin
      put_file_save := f_expand(put_file_save);
      // если значение не изменилось, то не загружам в память
      if (put_file_new_save <> put_file_save) then
      begin
        p_io_lang_file(put_file_save);
        load_file_ch_fast(ch_sav, put_file_save, sim_comment, false);
      end;
      // сохранено предыдущее значение
      if (put_file_save <> '') then
        put_file_new_save := f_expand(put_file_save);
    end;
  end;

var
  num_t2, num_temp : longint;
  line : string;
  bool_start_rss, bool_start : boolean;

  procedure p_cfg_file_expand(var put_cfg_file_expand : string; const num_const_cfg : longint);

  begin
    if (put_cfg_ver[num_const_cfg]) and
       (put_cfg_file_expand <> '') then
      put_cfg_file_expand := f_expand(put_cfg_file_expand);
  end;

  procedure p_all_cfg_file_expand(const num_rss_pacfe : longint);
  var
    num_tpacfe_par, num_tpacfe_par_plus : byte;

  begin
    num_tpacfe_par := 1;
    while (const_cfg[num_tpacfe_par] <> '') do
    begin
      num_tpacfe_par_plus := 1;
      while (par_cfg[num_rss_pacfe][num_tpacfe_par][num_tpacfe_par_plus] <> '') do
      begin
        p_cfg_file_expand(par_cfg[num_rss_pacfe][num_tpacfe_par][num_tpacfe_par_plus], num_tpacfe_par);
        inc(num_tpacfe_par_plus);
      end;
      inc(num_tpacfe_par);
    end;
  end;

  procedure p_cfg_rss_init;

  begin
    bool_start := true;
  end;

  function f_cfg_rss_end (in_rss_line : string) : boolean;

  begin
    f_cfg_rss_end := false;
    if (not bool_start) then
    begin
      f_cfg_rss_end := (in_rss_line = '');
      if (((UpCase(Copy(in_rss_line, 1, length(const_cfg[1]))) = UpCase(const_cfg[1])) and (not bool_start_rss)) or
         (UpCase(Copy(in_rss_line, 1, length('[end_rss]'))) = UpCase('[end_rss]'))) then
      begin
        bool_start_rss := false;
        f_cfg_rss_end := true;
        bool_start := true;
      end;
      if (UpCase(Copy(in_rss_line, 1, length(const_cfg[1]))) = UpCase(const_cfg[1])) then
        bool_start_rss := false;
    end;
  end;

  function f_cfg_rss_start (in_rss_line : string) : boolean;

  begin
    f_cfg_rss_start := false;
    if (bool_start) then
    begin
      if (UpCase(Copy(in_rss_line, 1, length(const_cfg[1]))) = UpCase(const_cfg[1])) or
         (UpCase(Copy(in_rss_line, 1, length('[start_rss]'))) = UpCase('[start_rss]')) then
      begin
        if (UpCase(Copy(in_rss_line, 1, length('[start_rss]'))) = UpCase('[start_rss]')) then
          bool_start_rss := true else bool_start_rss := false;
        f_cfg_rss_start := true;
        bool_start := false;
      end;
    end;
  end;

  function f_cfg_const_start (in_const_line : string) : boolean;
  begin
    f_cfg_const_start := (UpCase(Copy(in_const_line, 1, length('[start_const]'))) = UpCase('[start_const]'));
  end;
  function f_cfg_const_end (in_const_line : string) : boolean;
  begin
    f_cfg_const_end := (UpCase(Copy(in_const_line, 1, length('[end_const]'))) = UpCase('[end_const]'));
  end;

  procedure load_simvol_global(const ch_cfg : PChar; const str_global : string; var char_global : Char);
  var
    num_str : longint;
    bool_load_simvol_global : boolean;

  begin
    num_str := 0;
    bool_load_simvol_global := false;
    while ((num_str <= read_ch_enter_all(ch_cfg)) and (not bool_load_simvol_global)) do
    begin
      line := readLn_ch_to_enter(ch_cfg, num_str);
      line := f_start_end_del_str_simvol(line, ' ');
      if (UpCase(copy(line, 1, length('global '))) = UpCase('global ')) then
      begin
        line := f_in_per_end(line, 'global ');
        if (UpCase(copy(line, 1, length(str_global + ' '))) = UpCase(str_global + ' ')) then
        begin
          char_global := f_in_per_end(line, str_global + ' ')[1];
          bool_load_simvol_global := true;
        end;
      end;
    end;

  end;

  function GetConstCfg : byte;
  var
    num_t : byte;

  begin
    num_t := 1;
    while not (const_cfg[num_t] = '') do
      inc(num_t);

    GetConstCfg := num_t;
  end;

  procedure new_const (const line : string);
  var
    num_new_const : byte;
    str_new_const : string;

  begin
    if not (pos(' ', line) = 0) then
    begin
      str_new_const := f_re_string_pos_start(line, ' ');
      num_new_const := f_str2num(str_new_const);
      str_new_const := f_in_per_end(line, str_new_const);
      if (not (num_new_const = 0)) and
         (num_new_const <= GetConstCfg) and (not (str_new_const = '')) then
        const_cfg[num_new_const] := str_new_const;
    end;
  end;

  procedure p_read_cfg(const ch_cfg : PChar);

  var
    num_str : longint;
    num_const_cfg : byte;
    str_def_cfg : string;
    num_def_cfg : byte;
    str_def_set : string;
    str_set_t : string;
    num_const_cfg_plus, num_def_cfg_plus_max : byte;
    default_cfg : Array of string;

  begin

    SetLength(default_cfg, GetConstCfg +1);
    for num_def_cfg := 1 to GetConstCfg do
      default_cfg[num_def_cfg] := '';

    num_str := 0;
    p_cfg_rss_init;
    pro_const. num_rss := 1;
    SetLength(par_cfg, pro_const. num_rss +1);
    repeat
      line := readLn_ch_to_enter(ch_cfg, num_str);
      line := f_start_end_del_str_simvol(line, ' ');

        // переименовываем переменные конфиг файла,
        // заключенные между [start_const] и [end_const]
        // и пропускаем все другие переменные
        if f_cfg_const_start(line) then
        begin
          // читаем следующую строку после [start_const]
          line := readLn_ch_to_enter(ch_cfg, num_str);
          line := f_start_end_del_str_simvol(line, ' ');
          while (not f_cfg_const_end(line)) and
          (not f_cfg_rss_start(line)) and (not f_cfg_rss_end(line)) do
          begin
            new_const(line);
            // читаем следующую строку
            line := readLn_ch_to_enter(ch_cfg, num_str);
            line := f_start_end_del_str_simvol(line, ' ');
          end;
        end;
        // А можно и не пропуская другие переменные
        new_const(line);

        if (UpCase(Copy(line, 1, length('default '))) = UpCase('default ')) then
        begin
          str_def_cfg := f_in_per_end(line, 'default ');
          num_def_cfg := 1;
          while (const_cfg[num_def_cfg] <> '') do
          begin
            if (UpCase(Copy(str_def_cfg, 1, length(const_cfg[num_def_cfg] + ' '))) = UpCase(const_cfg[num_def_cfg] + ' ')) then
              default_cfg[num_def_cfg] := f_in_per_end(str_def_cfg, const_cfg[num_def_cfg]);

            inc(num_def_cfg);
          end;
        end;

        if (UpCase(Copy(line, 1, length('set '))) = UpCase('set ')) then
        begin
          str_def_set := f_in_per_end(line, 'set ');
          if (pos(' ', str_def_set) <> 0) and
             (str_def_set[1] = sim_lang_id) then
          begin
            str_set_t := Copy(str_def_set, 2, pos(' ', str_def_set) -2);
            lang_re_set(str_set_t, f_in_per_end(str_def_set, sim_lang_id + str_set_t));
          end;
        end;

        f_cfg_rss_start(line);

        num_const_cfg := 1;
        while (const_cfg[num_const_cfg] <> '') do
        begin
          if (UpCase(Copy(line, 1, length(const_cfg[num_const_cfg] + ' '))) = UpCase(const_cfg[num_const_cfg] + ' ')) then
          begin
            num_const_cfg_plus := 1;
            while (par_cfg[pro_const. num_rss][num_const_cfg][num_const_cfg_plus] <> '') do
              inc(num_const_cfg_plus);
            par_cfg[pro_const. num_rss][num_const_cfg][num_const_cfg_plus] := f_lang_re(f_in_per_end(line, const_cfg[num_const_cfg]));
            p_cfg_file_expand(par_cfg[pro_const. num_rss][num_const_cfg][num_const_cfg_plus], num_const_cfg);

          end;
          inc(num_const_cfg);
        end;

        if f_cfg_rss_end(line) then
        begin
          num_const_cfg := 1;
          if (par_cfg[pro_const. num_rss][8][1] = '') and
             (par_cfg[pro_const. num_rss][3][1] = '') then
            // если post_base не задано, то post будет задано из default
            par_cfg[pro_const. num_rss][3][1] := default_cfg[3];
          num_def_cfg := 1;
          num_t2 := 2; num_def_cfg_plus_max := 1;
          while (const_cfg[num_def_cfg] <> '') do
          begin
             // Если параметр в группе не задан
            if (par_cfg[pro_const. num_rss][num_def_cfg][1] = '') and
               (default_cfg[num_def_cfg] <> '') then
              begin
                // если внутренний постер не задан, будет использоваться внешний
                if (UpCase(const_cfg[3]) <> UpCase(const_cfg[num_def_cfg])) then
                begin
                  par_cfg[pro_const. num_rss][num_def_cfg][1] := f_lang_re(default_cfg[num_def_cfg]);
                  p_cfg_file_expand(par_cfg[pro_const. num_rss][num_def_cfg][1], num_def_cfg);
                end;
              end;
            // если задано параметров для значения в группе больше, чем один
            while (par_cfg[pro_const. num_rss][num_def_cfg][num_t2] <> '') and
                  (pos('_', const_cfg[num_def_cfg]) <> 0) do
            begin
              // нашли максимальный
              if (num_def_cfg_plus_max < num_t2) then
                num_def_cfg_plus_max := num_t2;
              inc(num_t2);
            end;
            inc(num_def_cfg);
          end;
          num_def_cfg := 1;
          while (const_cfg[num_def_cfg] <> '') do
          begin
            // Если в переменных типа "post_" что-то недописано,
            // то будет дописано из default или предыдущего значения 
            if (pos('_', const_cfg[num_def_cfg]) <> 0) then
            begin
               // Если параметры в группе не заданы до максимального значения,
              num_t2 := 2;
              while (num_t2 <= num_def_cfg_plus_max) do
              begin
              // то присваиваются значения из default
                if (par_cfg[pro_const. num_rss][num_def_cfg][num_t2] = '') and
                   (default_cfg[num_def_cfg] <> '') then
                begin
                  if (UpCase(const_cfg[3]) <> UpCase(const_cfg[num_def_cfg])) then
                    par_cfg[pro_const. num_rss][num_def_cfg][num_t2] := f_lang_re(default_cfg[num_def_cfg]);
                end;
                // если default не задано, то присваивается последнее значение порядка
                if (par_cfg[pro_const. num_rss][num_def_cfg][num_t2] = '') and
                   (default_cfg[num_def_cfg] = '') then
                begin
                  num_temp := 1;
                  // нашли последнее заданное значение
                  while (par_cfg[pro_const. num_rss][num_def_cfg][num_temp] <> '') do
                    inc(num_temp);
                  num_temp := outc(num_temp);

                   // если пследнее значение все-таки есть
                  if (par_cfg[pro_const. num_rss][num_def_cfg][num_temp] <> '') then
                    par_cfg[pro_const. num_rss][num_def_cfg][num_t2] := par_cfg[pro_const. num_rss][num_def_cfg][num_temp];

                end;
                inc(num_t2);
              end;
            end;
            inc(num_def_cfg);
          end;
         // переходим к новой группе
          inc(pro_const. num_rss);
          SetLength(par_cfg, pro_const. num_rss +1);

        end;
    until (line = '');
    pro_const. num_rss_end := pro_const. num_rss -1;

  end;

end.