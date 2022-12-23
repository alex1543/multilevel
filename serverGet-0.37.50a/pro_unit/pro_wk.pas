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

unit pro_wk;

interface

var
  ch_out : PChar = nil;
  ch_rss : PChar = nil;

  function par_cfg_macros (const name_par_cfg_macros, put_par_cfg_macros : string) : boolean;

  function par_cfg_address (const put_par_cfg_address : string) : boolean;
  function par_cfg_out (const put_par_cfg_out : string) : boolean;
  function par_cfg_exec (const put_par_cfg_exec : string) : boolean;
  function par_cfg_post (const put_par_cfg_post : string) : boolean;
  function par_cfg_delete (const put_par_cfg_delete : string) : boolean;
  function par_cfg_create (const put_par_cfg_create : string) : boolean;
  function par_cfg_view (const put_par_cfg_view : string) : boolean;
  function par_cfg_message (const put_par_cfg_message : string) : boolean;
  function par_cfg_convert (const put_par_cfg_convert, format_convert : string) : boolean;
  function par_cfg_convert_file (const put_par_cfg_convert, format_convert : string) : boolean;

  function par_cfg_all_macros (const num_macros : byte) : boolean;

implementation

uses
  crt, dos,

  pro_string, pro_ch, pro_const, pro_files,
  pro_util, pro_pkt, pro_msg, pro_bso,
  pro_lang, pro_loader, pro_uue, pro_cfg, pro_coder, pro_dtb;

  function par_macros_cfg_wr (const num_macros : byte; const put_par_cfg_macros : string) : boolean;

  begin
    par_macros_cfg_wr := false;

    if (num_macros = 2) then
      par_macros_cfg_wr := par_cfg_address(put_par_cfg_macros);
    if (num_macros = 3) then
      par_macros_cfg_wr := par_cfg_post(put_par_cfg_macros);
    if (num_macros = 4) then
      par_macros_cfg_wr := par_cfg_out(put_par_cfg_macros);
    if (num_macros = 8) then
      par_macros_cfg_wr := par_cfg_message(put_par_cfg_macros);
    if (num_macros = 18) then
      par_macros_cfg_wr := par_cfg_exec(put_par_cfg_macros);
    if (num_macros = 19) then
      par_macros_cfg_wr := par_cfg_create(put_par_cfg_macros);
    if (num_macros = 25) then
      par_macros_cfg_wr := par_cfg_delete(put_par_cfg_macros);
    if (num_macros = 26) then
      par_macros_cfg_wr := par_cfg_view(put_par_cfg_macros);
    if (num_macros = 37) then
      par_macros_cfg_wr := par_cfg_convert('', put_par_cfg_macros);
    if (num_macros = 41) then
      par_macros_cfg_wr := par_cfg_convert_file(put_par_cfg_macros, '');

  end;

  function par_cfg_all_macros (const num_macros : byte) : boolean;

  begin
    par_cfg_all_macros := false;
    pro_const. num_tplus := 1;
    while (par_cfg[pro_const. num_rss][num_macros][pro_const. num_tplus] <> '') do
    begin
      par_cfg_all_macros := par_macros_cfg_wr(num_macros, par_cfg[pro_const. num_rss][num_macros][pro_const. num_tplus]);
      inc(pro_const. num_tplus);
    end;
    pro_const. num_tplus := 1;

  end;

  function par_cfg_macros (const name_par_cfg_macros, put_par_cfg_macros : string) : boolean;
  var
    num_t : byte;

  begin
    num_t := 1; par_cfg_macros := false;

    while (const_cfg[num_t] <> '') and (not par_cfg_macros) do
    begin
      if (UpCase(name_par_cfg_macros) = sim_lang_id + UpCase(const_cfg[num_t]) + sim_exec) then
        par_cfg_macros := par_macros_cfg_wr(num_t, put_par_cfg_macros);

      if (UpCase(name_par_cfg_macros) = sim_lang_id + UpCase(const_cfg[num_t] + '_all')) then
        par_cfg_macros := par_cfg_all_macros(num_t);

      inc(num_t);
    end;
  end;

  function par_cfg_convert_file (const put_par_cfg_convert, format_convert : string) : boolean;

  begin
    par_cfg_convert_file := par_cfg_convert(put_par_cfg_convert, GetParConf(pro_const. num_rss, 37, num_tplus));

  end;

  function par_cfg_convert (const put_par_cfg_convert, format_convert : string) : boolean;
  var
    ch_t : PChar;
    path_file : string;

  begin
    path_file := put_par_cfg_convert;

    if (path_file = '') then
       path_file := GetParConf(pro_const. num_rss, 41, num_tplus);

    if not (path_file = '') then
       p_load_file_ch_all(ch_t, path_file) else
       ch_t := ch_out;

    if (UpCase(format_convert) = 'UUE') then
       UUEncodeCh(ch_t, ch_t) else
       convert_ch(ch_t, format_convert, true);

    if not (path_file = '') then
       file_create(ch_t, path_file) else
       ch_out := ch_t;

    par_cfg_convert := true;
  end;

  function par_cfg_view (const put_par_cfg_view : string) : boolean;

  begin
    p_io_file(put_par_cfg_view);
    view_file(put_par_cfg_view);
    par_cfg_view := true;
  end;

  function par_cfg_out (const put_par_cfg_out : string) : boolean;

  begin
    // создаем out файлы, заданные переменной "out"
    file_create(ch_out, put_par_cfg_out);
    par_cfg_out := true;
  end;

  function par_cfg_exec (const put_par_cfg_exec : string) : boolean;

  begin
    // запускаем приложения, определённые макросом "exec"
    exec(put_par_cfg_exec, '');
    par_cfg_exec := true;
  end;

  function par_cfg_delete (const put_par_cfg_delete : string) : boolean;

  begin
    // удаляем файлы, определённые макросом "delete"
    file_erase(put_par_cfg_delete);
    par_cfg_delete := true;
  end;

  function par_cfg_post (const put_par_cfg_post : string) : boolean;
  var
    str_t : string;

  begin
    // по-любому создаем out файл при параметре post
    if (par_cfg[pro_const. num_rss][4][pro_const. num_tplus] = '') then
    begin
      str_t := get_file_cp_out('');
      par_cfg_out (f_expand(str_t));
      exec(put_par_cfg_post, f_expand(str_t));
    end else
    begin
   //   par_cfg_out (par_cfg[pro_const. num_rss][4][pro_const. num_tplus]);
      exec(put_par_cfg_post, par_cfg[pro_const. num_rss][4][pro_const. num_tplus]);
    end;
    // удаляем out файл, если он не был задан
    if (par_cfg[pro_const. num_rss][4][pro_const. num_tplus] = '') then
      file_erase(f_expand(str_t));

    par_cfg_post := true;
  end;

  function par_cfg_create (const put_par_cfg_create : string) : boolean;
  var
    num_t : byte;
    file_post_create_file : text;

  begin
    par_cfg_create := false;
    Assign(file_post_create_file, put_par_cfg_create);
    // Создаем флаги и записываем туда имена почтовых баз
    {$I-} rewrite(file_post_create_file); {$I+}
    if (IOResult = 0) then
      begin
      num_t := 1;
      while (par_cfg[pro_const. num_rss][8][num_t] <> '') do
      begin
        {$I-} writeLn(file_post_create_file, f_file_name(par_cfg[pro_const. num_rss][8][num_t])); {$I+}
        inc(num_t);
      end;
      {$I-} close(file_post_create_file); {$I+}
      par_cfg_create := true;
    end;
  end;

  function par_cfg_message (const put_par_cfg_message : string) : boolean;
  var
    put_post_message_base : string;

  begin
    par_cfg_message := false;
    // если это pkt
    if (Upcase(par_cfg[pro_const. num_rss][9][pro_const. num_tplus]) = UpCase(def_base[4])) then
    begin
      p_pkt_create(ch_out, put_par_cfg_message);
      par_cfg_message := true;
    end;
    // если это text
    if (Upcase(par_cfg[pro_const. num_rss][9][pro_const. num_tplus]) = UpCase(def_base[5])) then
    begin
      par_cfg_out(get_file_cp_out(put_par_cfg_message));
      par_cfg_message := true;
    end;
    // если это bso
    if (Upcase(par_cfg[pro_const. num_rss][9][pro_const. num_tplus]) = UpCase(def_base[6])) then
    begin
      send_bso_file(put_par_cfg_message);
      par_cfg_message := true;
    end;

    //  почтовая база сообщений
    if (not par_cfg_message) then
    begin
      put_post_message_base := put_par_cfg_message;
      send_message_base(ch_out, put_post_message_base);
    end;
    par_cfg_message := true;
  end;

  function par_cfg_address (const put_par_cfg_address : string) : boolean;
  var
    put_file_rss_out : string;

  begin
    if (par_cfg[pro_const. num_rss][31][pro_const. num_tplus] <> '') then
      put_file_rss_out := par_cfg[pro_const. num_rss][31][pro_const. num_tplus] else
      put_file_rss_out := put_rss_out;

    if (par_cfg[pro_const. num_rss][5][pro_const. num_tplus] <> '') and
       (UpCase(f_file_ext(f_expand(par_cfg[pro_const. num_rss][5][pro_const. num_tplus]))) <> 'LOG') then
    begin
      par_cfg[pro_const. num_rss][5][pro_const. num_tplus] := f_expand(par_cfg[pro_const. num_rss][5][pro_const. num_tplus]);
      if (UpCase(f_file_ext(par_cfg[pro_const. num_rss][5][pro_const. num_tplus])) = 'EXE') then
        exec(par_cfg[pro_const. num_rss][5][pro_const. num_tplus], put_par_cfg_address + ' --output-document=' + put_file_rss_out)
                                                       else
        exec(par_cfg[pro_const. num_rss][5][pro_const. num_tplus], put_par_cfg_address + ' ' + put_file_rss_out);
    end else
    begin
      p_lang('master', false);
      get_inet_file(put_par_cfg_address, put_file_rss_out, par_cfg[pro_const. num_rss][5][pro_const. num_tplus]);
    end;

    if (not file_exist(put_file_rss_out)) or
       (f_file_size(put_file_rss_out) = 0) then
      par_cfg_address := false else
    begin
      p_load_file_ch_all(ch_rss, put_file_rss_out);

      if not (par_cfg[pro_const. num_rss][31][1] <> '') then
        file_erase(put_file_rss_out);

      par_cfg_address := true;
    end;

    if not (par_cfg_address) then
      p_lang('error_url', false);

  end;

end.