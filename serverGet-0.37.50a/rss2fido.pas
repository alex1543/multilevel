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


program rss2fido;

uses crt, dos,

     pro_coder, pro_util, pro_files, pro_dt, pro_string,
     pro_lang, pro_ch, pro_par, pro_dtb, pro_rss, pro_cfg,
     pro_const, pro_utf, pro_wk;

var
  ch_tpl, ch_cfg : PChar;


begin
  {$ifdef Win32}
  {$R ico/new.res} // Иконка
  // Выход из программы
  // (по крестику, клавишам, etc)
  SetCtrlHandler;
  // Кодовая стр. отобр. на экране
  set_code_page(866);
  {$endif}

  put_rss_out := f_expand(put_rss_out);

  if f_help(ParamStr(1)) then p_par('help', true);
  if f_info(ParamStr(1)) then p_par('info', true);
  if (f_copyright(ParamStr(1))) then p_wr_copyright(true);

  if (file_exist(f_expand(put_file_lock))) then
  begin
    WriteLn(' ... to view copyright type --copyright');
    WriteLn('     for example: ' + f_prog_name + ' --copyright');
    WriteLn('     just use: --help, --info for more information');
    delay(1200);
  end;
  p_lock (f_expand(put_file_lock));

  setLength(par_cfg, 2);
  load_first_language(par_cfg[1][7][1]);
  load_file_save(ch_lng, par_cfg[1][7][1], put_language_save);

  if (f_config(ParamStr(1))) then
  begin
    put_file_cfg := ParamStr(2);
    if (put_file_cfg <> '') then
      put_file_cfg := f_expand(f_lang_re(put_file_cfg));
    if (put_file_cfg = '') then
      put_file_cfg := f_open_first_file ('cfg', 'error_cfg')
    else
      p_io_file(put_file_cfg);
    if file_exist(put_file_cfg) then
    begin
      multi := true;
      p_lang('config', false);

      if not (f_distest(ParamStr(3))) then test('start');
      p_load_file_ch_all(ch_cfg, put_file_cfg);

      load_simvol_global(ch_cfg, 'comment', sim_comment);
      load_simvol_global(ch_cfg, 'macros', sim_lang_id);
      load_simvol_global(ch_cfg, 'action', sim_exec);

      load_file_ch_fast(ch_cfg, put_file_cfg, sim_comment, true); // ch_cfg := nil;
      load_file_ch_include_fast(ch_cfg, 'include', sim_comment);
      p_read_cfg(ch_cfg);
      ch_cfg := nil;
      if not (f_distest(ParamStr(3))) then test('end');

      load_file_save(ch_lng, par_cfg[1][7][1], put_language_save);
    end else
      p_lang('error_cfg', true);
  end else
    p_parse_str_in_prog;

  pro_const. num_tplus := 1;
  pro_const. num_rss := 1;
  pro_const. num_cycle := 1;

repeat

  if (not multi) then
  begin
    // если post и post_base не указан, то присваиваем значение post
    if (par_cfg[pro_const. num_rss][3][1] = '') and (par_cfg[pro_const. num_rss][8][1] = '') then
      par_cfg[pro_const. num_rss][3][1] := 'post.bat';
    p_all_cfg_file_expand(pro_const. num_rss);

    if (ParamStr(1) = '') and (par_cfg[pro_const. num_rss][2][1] = '') then
    begin // при запуске без параметров
      par_cfg[pro_const. num_rss][2][1] := GetFirstParCfgDtb(2);
      par_cfg[pro_const. num_rss][4][1] := GetFirstParCfgDtb(4);
      if (par_cfg[pro_const. num_rss][4][1] = '') then
        par_cfg[pro_const. num_rss][4][1] := f_expand('CP866_out.txt');
      p_lang('enter', false);
      SetFirstParCfgDtb(2, par_cfg[pro_const. num_rss][2][1]);
      if not (par_cfg[pro_const. num_rss][4][1] = f_expand('CP866_out.txt')) then
        SetFirstParCfgDtb(4, par_cfg[pro_const. num_rss][4][1]);
    end else
    begin // при запуске с address, как единст. параметр к программе
      if (par_cfg[pro_const. num_rss][2][1] = '') and (ParamStr(1) <> '') then
        par_cfg[pro_const. num_rss][2][1] := f_expand(f_lang_re(ParamStr(1)));
      if (par_cfg[pro_const. num_rss][4][1] = '') and (ParamStr(2) <> '') then
        par_cfg[pro_const. num_rss][4][1] := f_expand(f_lang_re(ParamStr(2)));
      // если в ParamStr(2) пусто, то присваиваем по умолчанию
      if (par_cfg[pro_const. num_rss][4][1] = '') and (ParamStr(2) = '') then
        par_cfg[pro_const. num_rss][4][1] := f_expand('CP866_out.txt');
      p_lang('string', false);
    end;
  end;
  // если новое значение равно предыдущему, то загрузки PChar не происходит
  load_file_save(ch_lng, par_cfg[pro_const. num_rss][7][1], put_language_save);
  load_first_template(par_cfg[pro_const. num_rss][6][1]);
  load_file_save(ch_tpl, par_cfg[pro_const. num_rss][6][1], put_template_save);

  bool_template_macros := f_boolean(par_cfg[pro_const. num_rss][24][1]);

  if (par_cfg[pro_const. num_rss][23][1] = '') then
    par_cfg[pro_const. num_rss][23][1] := 'item';

  if (par_cfg[pro_const. num_rss][1][1] = '') then
    par_cfg[pro_const. num_rss][1][1] := rss_none_name + par_cfg[pro_const. num_rss][2][1];

  RSSAllVerAndGetURL;

  if (pro_const. num_cycle = 1) then
    p_lang('start', false);

  if file_exist(put_rss_out) and (par_cfg[pro_const. num_rss][31][1] = '') then
    file_erase(put_rss_out);

  if par_cfg_all_macros( 2) then // address
  begin

  auto_code(ch_rss, pro_lang. convert_code);
  p_lang('code', false);
  if (pro_lang. convert_code = 'UTF-8') then
    convert_ch_utf2dos(ch_rss);
  if (pro_lang. convert_code = 'WINDOWS-1251') or
     (pro_lang. convert_code = 'NONE_CODE') then
    convert_ch(ch_rss, 'win', false);
  if (pro_lang. convert_code = 'ISO-8859-1') then
    convert_ch(ch_rss, 'iso', false);
  if (pro_lang. convert_code = 'KOI8-R') then
    convert_ch(ch_rss, 'koi', false);
  if (pro_lang. convert_code = 'KOI8-U') then
    convert_ch(ch_rss, 'uni', false);

  if teg_rss_ver(ch_rss, par_cfg[pro_const. num_rss][23][1]) then
  begin
    if (not rss_old(ch_rss, q_news)) then
    begin
      p_lang ('news', false);
      p_new_add_in_one_msg (ch_rss, ch_tpl, ch_out, q_news);

      par_cfg_all_macros(37); // convert
      par_cfg_all_macros( 4); // out
      par_cfg_all_macros( 3); // sender
      par_cfg_all_macros( 8); // send_path
      par_cfg_all_macros(19); // create
      par_cfg_all_macros(18); // exec
      par_cfg_all_macros(26); // view
      par_cfg_all_macros(25); // delete

    end else
      p_lang('size', false);
  end;
    ch_rss := nil;
  end;

  if (multi) then
  begin
    // без конфиг файла RSS не считаем
    if (pro_const. num_rss < pro_const. num_rss_end) then
      inc(pro_const. num_rss) else
      pro_const. num_rss := 1;

    p_lang('multi', false);
  end else
    p_lang('unit', false);

  inc(pro_const. num_cycle);

  until (pro_const. num_rss > pro_const. num_rss_end);

end.