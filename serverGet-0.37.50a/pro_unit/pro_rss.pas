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

unit pro_rss;

interface

  procedure p_new_add_in_one_msg(const ch_rss, ch_tpl : PChar; var ch_out : PChar; const num_msg : byte);
  function teg_rss_ver (const ch_rss : PChar; const teg_id : string) : boolean;
  procedure p_rss_verif (const put_file_rss : string);
  procedure RSSAllVerAndGetURL;

implementation

uses
  crt, dos,

  pro_lang, pro_util, pro_const, pro_ch, pro_item, pro_string, pro_files;

  procedure RSSAllVerAndGetURL;
  var
    num_t : byte;

  begin
    num_t := 1;
    repeat
      par_cfg[pro_const. num_rss][2][num_t] := GetHyperLinkFile(par_cfg[pro_const. num_rss][2][num_t]);
      p_rss_verif(par_cfg[pro_const. num_rss][2][num_t]);
      inc(num_t);
    until (par_cfg[pro_const. num_rss][2][num_t] = '');
  end;

var
  temp_num, num_t2 : longint;
  mega_num_tpl_fix, mega_num_tpl_in_fix : byte;
  str_start_wr, str_end_wr : string;
  tpl_tstr : string;
  line : string;
  end_out : longint;

  procedure p_rss_verif (const put_file_rss : string);

  begin
    if (put_file_rss = '') or (pos('://', put_file_rss) = 0) then
      p_lang('error_RSS', true);
  end;



  function teg_rss_ver (const ch_rss : PChar; const teg_id : string) : boolean;
  var
    teg_id_t : string;

  begin
    teg_id_t := '<' + teg_id + '>';
    temp_num := 1;
    while (not f_pos_ch (ch_rss, teg_id_t, temp_num)) and
          (not eof_ch(ch_rss, temp_num + length(teg_id_t))) do
      inc (temp_num);
    if eof_ch(ch_rss, temp_num + length(teg_id_t)) then
    begin
      p_lang('error_item', false);
      teg_rss_ver := false;
    end else
      teg_rss_ver := true;
  end;


  procedure p_news_add(const ch_item, ch_tpl : PChar; var ch_out : PChar);
  var
    ch_fmt : PChar;
    num_fmt : longint;
    url_format : byte;


  function f_teg_ver(teg_in, teg_out : string) : boolean;

  begin
    f_teg_ver := false; temp_num := 0;
    while (not f_pos_ch(ch_item, teg_in, temp_num)) and 
          (not eof_ch(ch_item, temp_num)) do
      inc (temp_num);

    if (f_pos_ch (ch_item, teg_in, temp_num)) then
    begin
      while (not f_pos_ch(ch_item, teg_out, temp_num)) and
            (not eof_ch(ch_item, temp_num)) do
        inc (temp_num);
      if (f_pos_ch (ch_item, teg_out, temp_num)) then
        f_teg_ver := true;
    end;
  end;

  procedure p_news_add_append (str_pnaa1, str_pnaa2 : string; num_pnaa1 : byte);
  var
      temp_num_dec1 : longint;

      procedure p_re_sim_in_file_news (in_re_sim_in_file_news, out_re_sim_in_file_news : string);

      begin
        if (f_pos_ch(ch_item, in_re_sim_in_file_news, temp_num)) then
        begin
          p_add_ch_fast(ch_fmt, num_fmt, out_re_sim_in_file_news);
          temp_num := temp_num + length(in_re_sim_in_file_news);
        end;
      end;

  function f_start_comment (const num_ver : longint) : boolean;

  begin
    if (f_pos_ch (ch_item, '&lt;', num_ver)) or
    (f_pos_ch (ch_item, '&amp;lt;', num_ver)) then
      f_start_comment := true else
      f_start_comment := false;

  end;

  function f_end_comment (const num_ver : longint) : boolean;

  begin
    if f_pos_ch (ch_item, str_pnaa2, num_ver) or
      f_pos_ch (ch_item, '&gt;', num_ver) or
      f_pos_ch (ch_item, '&lt;', num_ver) then
      f_end_comment := true else
      f_end_comment := false;

  end;


type turl = Array of string;
var
  out_pos : longint;
  str_url, str_title : turl;
  num_url, num_title : byte;

  procedure add_sub_comment (var str_asc : turl; var num_asc : byte);

  begin
    inc(num_asc);
    setLength(str_asc, num_asc +1); str_asc[num_asc] := '';
    while (not f_pos_ch (ch_item, '&quot;', temp_num + temp_num_dec1)) and
          (not f_end_comment(temp_num + temp_num_dec1)) do
    begin
      str_asc[num_asc] := str_asc[num_asc] + ch_item[temp_num + temp_num_dec1];
      inc(temp_num_dec1);
    end;

  end;

  procedure write_sub_comment_two;
  var
    num_t : byte;
    str_plus : string;

  begin
    p_add_ch_fast(ch_fmt, num_fmt, f_enter_wr);
    for num_t := 1 to num_url do
    begin
      p_add_ch_fast(ch_fmt, num_fmt, f_enter_wr + '[' + f_num2str(num_t) + ']: ' + str_url[num_t]);
      if (str_title[num_t] = '') then
      begin
        str_plus := par_cfg[pro_const. num_rss][28][1];
      end else
        str_plus := f_enter_wr + '     (' + str_title[num_t] + ')';
      p_add_ch_fast(ch_fmt, num_fmt, str_plus);
    end;
  end;

  function ver_sub_comment (const str_vsc : string; const main_pos_vsc : longint; var pos_vsc : longint) : boolean;

  begin
    if f_pos_ch(ch_item, str_vsc, main_pos_vsc + pos_vsc) then
    begin
      pos_vsc := pos_vsc + length(str_vsc);
      ver_sub_comment := true;
    end else
      ver_sub_comment := false;

  end;

  function f_hr_wr : string;

  begin
    f_hr_wr := str_fix('', mega_num_tpl_fix - length(str_start_wr) - length(str_end_wr) -1, '-');
    f_hr_wr := f_enter_wr + f_hr_wr + f_enter_wr;
  end;

  begin
    num_url := 0; num_title := 0; temp_num := 0;
    while (not f_pos_ch(ch_item, str_pnaa1, temp_num)) do inc(temp_num);
    p_lang('news_add', false);

    num_fmt := 0; ch_fmt := nil;
    RealLocMem(ch_fmt, StrLen(ch_item));
    temp_num := temp_num + length (str_pnaa1);
    while (not f_pos_ch (ch_item, str_pnaa2, temp_num)) and
          (not eof_ch(ch_item, temp_num)) do
    begin

        // нашли Enter
      if (f_pos_ch (ch_item, '&lt;br /&gt;', temp_num)) then
      begin p_re_sim_in_file_news ('&lt;br /&gt;', f_enter_wr); continue; end;
      if (f_pos_ch (ch_item, '&lt;br&gt;', temp_num)) then
      begin p_re_sim_in_file_news ('&lt;br&gt;', f_enter_wr); continue; end;
      if (f_pos_ch (ch_item, '&lt;b&gt;', temp_num)) then
      begin p_re_sim_in_file_news ('&lt;b&gt;', f_enter_wr); continue; end;
      if (f_pos_ch (ch_item, '&lt;br', temp_num)) then
      begin p_re_sim_in_file_news ('&lt;br', f_enter_wr); continue; end;

        // вместо '&quot;' будут записаны кавычки
      p_re_sim_in_file_news ('&quot;', #34);
        // вместо '&amp;nbsp;' будет пробел
      p_re_sim_in_file_news ('&amp;nbsp;', ' ');
        // вместо '&apos;' будет #39 (')
      p_re_sim_in_file_news ('&apos;', #39);
      p_re_sim_in_file_news ('&amp;trade;', '(TM)');

        // нашли Line
      if (f_pos_ch (ch_item, '&lt;hr /&gt;', temp_num)) then
      begin p_re_sim_in_file_news ('&lt;hr /&gt;', f_hr_wr); continue; end;
      if (f_pos_ch (ch_item, '&lt;hr&gt;', temp_num)) then
      begin p_re_sim_in_file_news ('&lt;hr&gt;', f_hr_wr); continue; end;
      if (f_pos_ch (ch_item, '&lt;h&gt;', temp_num)) then
      begin p_re_sim_in_file_news ('&lt;h&gt;', f_hr_wr); continue; end;
      if (f_pos_ch (ch_item, '&lt;hr', temp_num)) then
      begin p_re_sim_in_file_news ('&lt;hr', f_hr_wr); continue; end;

      if (f_pos_ch (ch_item, '&lt;p&gt;', temp_num)) then
      begin p_re_sim_in_file_news ('&lt;p&gt;', f_enter_wr + f_enter_wr); continue; end;
      if (f_pos_ch (ch_item, '&lt;/p&gt;', temp_num)) then
      begin p_re_sim_in_file_news ('&lt;/p&gt;', f_enter_wr + f_enter_wr); continue; end;

      if (f_start_comment(temp_num)) then
      begin
        // не записываем в файл все то, что заключено между '&lt;' и '&gt;'
        temp_num_dec1 := 1;
        while not f_end_comment(temp_num + temp_num_dec1) do
        begin
          if (url_format = 1) or (url_format = 2) then
          begin
            if ver_sub_comment('title=&quot;', temp_num, temp_num_dec1) or
               ver_sub_comment('text=&quot;', temp_num, temp_num_dec1) then
                add_sub_comment(str_title, num_title);
            if ver_sub_comment('src=&quot;', temp_num, temp_num_dec1) or
               ver_sub_comment('href=&quot;', temp_num, temp_num_dec1) then
            begin
              if (url_format = 1) then
              begin
                p_add_ch_fast(ch_fmt, num_fmt, '[');
                while (not f_pos_ch (ch_item, '&quot;', temp_num + temp_num_dec1)) and
                      (not f_end_comment(temp_num + temp_num_dec1)) do
                begin
                  p_add_ch_fast(ch_fmt, num_fmt, ch_item[temp_num + temp_num_dec1]);
                  inc(temp_num_dec1);
                end;
                p_add_ch_fast(ch_fmt, num_fmt, ']');
              end;
              if (url_format = 2) then
              begin
                p_add_ch_fast(ch_fmt, num_fmt, '[' + f_num2str(num_url +1) + ']');
                add_sub_comment(str_url, num_url); // <- inc(num_url);
                num_title := num_url;
                SetLength(str_title, num_title +1);
              end;
            end;
          end;
          inc(temp_num_dec1);
        end;
        if (f_pos_ch (ch_item, '&gt;', temp_num + temp_num_dec1)) then
        begin temp_num := temp_num + temp_num_dec1 + length('&gt;'); continue; end;
      end;

      p_add_ch_fast(ch_fmt, num_fmt, ch_item[temp_num]);
      inc(temp_num);

    end;

    if (url_format = 2) then
      write_sub_comment_two;

    p_add_ch_fast(ch_fmt, num_fmt, ' ');
    p_ch_end_fast(ch_fmt, num_fmt);

 // format message
      num_fmt := 0; temp_num := 0;
      pro_ch. f_ver_ch(ch_fmt, num_fmt, mega_num_tpl_fix - length(str_start_wr) - length(str_end_wr) - temp_num, out_pos);
      p_add_ch_fast(ch_out, end_out, str_start_wr);
      while (not (num_pnaa1 = 0) and not eof_ch(ch_fmt, num_fmt)) or
            ((num_pnaa1 = 0) and not (temp_num > mega_num_tpl_fix - length(str_start_wr) - length(str_end_wr)) and (not eof_ch(ch_fmt, num_fmt))) do
      begin
        if (temp_num > mega_num_tpl_fix - length(str_start_wr) - length(str_end_wr)) or
           (ch_fmt[num_fmt] = f_enter_plus) or
           ((num_pnaa1 = 1) and (num_fmt = out_pos)) then
        begin
          while (not (temp_num > mega_num_tpl_fix - length(str_start_wr) - length(str_end_wr))) and
                (not f_ver_ch(str_end_wr, ' ')) do
          begin
            p_add_ch_fast(ch_out, end_out, ' ');
            inc(temp_num);
          end;
          temp_num := 0;
          pro_ch. f_ver_ch(ch_fmt, num_fmt, mega_num_tpl_fix - length(str_start_wr) - length(str_end_wr) - temp_num, out_pos);
          p_add_ch_fast(ch_out, end_out, str_end_wr);
          p_add_ch_fast(ch_out, end_out, str_start_wr);
        end;
        if (not f_enter_ver(ch_fmt[num_fmt])) then
        begin
          p_add_ch_fast(ch_out, end_out, ch_fmt[num_fmt]);
          inc(temp_num);
        end;
        inc(num_fmt);
      end;
      ch_fmt := nil;
      while (not (temp_num > mega_num_tpl_fix - length(str_start_wr) - length(str_end_wr))) and
            (not f_ver_ch(str_end_wr, ' ')) do
      begin
        p_add_ch_fast(ch_out, end_out, ' ');
        inc(temp_num);
      end;
      p_add_ch_fast(ch_out, end_out, str_end_wr);

  end;

var
  num_enter : longint;

  begin
    p_add_ch_fast(ch_out, end_out, #01 + 'PID: ' + by_Rain + f_enter_wr);
    num_t2 := 0;
    num_enter := read_ch_enter_all(ch_tpl);
    while (num_t2 <= num_enter) do
    begin
      line := readLn_ch_to_enter(ch_tpl, num_t2) + f_enter_wr;
      if (bool_template_macros) then
        line := f_lang_re(line);

      if (pos(sim_lang_id, (line)) <> 0) and
         (pos(',[', (line)) <> 0) and
         (pos(']', (line)) <> 0) and
         (pos(',', (line)) <> 0) then
      begin
        pro_const. str_teg := Copy(line, pos(sim_lang_id, (line)) +1, length(line) - (pos(sim_lang_id, (line))));
        pro_const. str_teg := Copy(pro_const. str_teg, 1, pos(',', pro_const. str_teg) -1);

        mega_num_tpl_in_fix := pos(UpCase(sim_lang_id + pro_const. str_teg + ','), UpCase(line)) -1;
        pro_const. num_re_str := f_str2num(Copy(line, pos(UpCase(sim_lang_id + pro_const. str_teg + ','), UpCase(line)) + length(sim_lang_id + pro_const. str_teg + ','), 1));
        tpl_tstr := Copy(line, pos(UpCase(sim_lang_id + pro_const. str_teg + ','), UpCase(line)) + length(sim_lang_id + pro_const. str_teg + ',') + 3, length((line)) - (pos(UpCase(sim_lang_id + pro_const. str_teg + ','), UpCase(line)) + length(sim_lang_id + pro_const. str_teg + ',') + 3) +1);
        tpl_tstr := Copy(tpl_tstr, 1, pos(']', tpl_tstr) -1);
        mega_num_tpl_fix := f_str2num(tpl_tstr) +1;
        if mega_num_tpl_fix < mega_num_tpl_in_fix then
          mega_num_tpl_fix := mega_num_tpl_in_fix;
        str_start_wr := Copy(line, 1, mega_num_tpl_in_fix);
        str_end_wr := Copy(line, pos(UpCase(sim_lang_id + pro_const. str_teg + ','), UpCase(line)) + length(sim_lang_id + pro_const. str_teg + ',') + 1 + length(tpl_tstr) + 3, length(line) - ( pos(UpCase(sim_lang_id + pro_const. str_teg + ','), UpCase(line)) + length(sim_lang_id + pro_const. str_teg + ',') + length(tpl_tstr) + 3));
        // url_format
        if (pos(']:', (line)) <> 0) then
        begin
          url_format := f_str2num(str_end_wr[pos(']:', str_end_wr) + length(']:')]);
          str_end_wr := Copy(str_end_wr, pos(']:', str_end_wr) + length(']:') +1, length(str_end_wr) - (pos(']:', str_end_wr) + length(']:')));
        end else
          url_format := 0;

        if f_teg_ver ('<' + pro_const. str_teg + '>', '</' + pro_const. str_teg + '>') then
          p_news_add_append ('<' + pro_const. str_teg + '>', '</' + pro_const. str_teg + '>', pro_const. num_re_str)
                                                                   else
        begin
          p_add_ch_fast(ch_out, end_out, f_string_fix(str_start_wr, mega_num_tpl_in_fix) + str_end_wr);
          p_lang('error_news', false);
        end;
      end else
        p_add_ch_fast(ch_out, end_out, line);

    end;

  end;

  procedure p_new_add_in_one_msg(const ch_rss, ch_tpl : PChar; var ch_out : PChar; const num_msg : byte);

  var
    num_msg_t : byte;
    ch_item : PChar;

  begin

    ch_out := nil;
    RealLocMem(ch_out, StrLen(ch_rss));

    num_msg_t := 1; end_out := 0;
     while (num_msg_t <= num_msg) and (num_msg_t <= q_item) do
    begin
      load_item(ch_rss, num_msg_t, ch_item, false);
      p_news_add(ch_item, ch_tpl, ch_out);
      inc(num_msg_t);
    end;
    ch_item := nil;
    p_ch_end_fast(ch_out, end_out);
  end;


end.