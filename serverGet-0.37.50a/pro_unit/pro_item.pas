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

unit pro_item;

interface

  function func_q_item (const ch_rss : PChar) : longint;
  procedure load_item (const ch_rss : PChar; const num_item : longint; var ch_item : PChar; const bool_enter : boolean);


implementation

uses
  crt, dos,

  pro_ch, pro_const, pro_util;

  procedure load_item (const ch_rss : PChar; const num_item : longint; var ch_item : PChar; const bool_enter : boolean);
  var
    num_ch_rss, num_item_t, num_ch_item : longint;


  begin
    num_ch_rss := 0; num_item_t := 0;
    while (not (eof_ch(ch_rss, num_ch_rss))) and (num_item_t <> num_item) do
    begin
      if (f_pos_ch(ch_rss, '<' + par_cfg[pro_const. num_rss][23][1] + '>', num_ch_rss)) then
        inc(num_item_t);

      inc(num_ch_rss);
    end;
    if (num_item_t = num_item) then
    begin
      num_ch_rss := outc(num_ch_rss);
      ch_item := nil; num_ch_item := 0;
      while (not (eof_ch(ch_rss, num_ch_rss))) and 
            (not f_pos_ch(ch_rss, '</' + par_cfg[pro_const. num_rss][23][1] + '>', num_ch_rss)) do
      begin
        if (not bool_enter) or ((bool_enter) and (not f_enter_ver(ch_rss[num_ch_rss]))) then
        begin
          ReallocMem(ch_item, num_ch_item +1);
          ch_item[num_ch_item] := ch_rss[num_ch_rss];
          inc(num_ch_item);
        end;
        inc(num_ch_rss);
      end;
      p_add_ch(ch_item, num_ch_item, '</' + par_cfg[pro_const. num_rss][23][1] + '>');
      p_ch_end_fast(ch_item, num_ch_item);
    end;

  end;

  function func_q_item (const ch_rss : PChar) : longint;
  var
    num_ch_rss : longint;


  begin
    num_ch_rss := 0; func_q_item := 0;
    while not (eof_ch(ch_rss, num_ch_rss)) do
    begin
      if (f_pos_ch(ch_rss, '<' + par_cfg[pro_const. num_rss][23][1] + '>', num_ch_rss)) then
        inc(func_q_item);

      inc(num_ch_rss);
    end;
  end;

end.