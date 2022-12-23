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

unit pro_utf;

interface

  function utf2dos (in_str_utf : string) : string;
  procedure convert_ch_utf2dos (var ch_convert : PChar);
  procedure file_convert_utf2dos (put_file_convert : string);


implementation

uses
  pro_ch;

  function utf2dos (in_str_utf : string) : string;
  var
    num_tutf, num_tutf_t : byte;
    utf_sim, new_utf_sim : string;
    new_str : string;
    str_utf, str_dos : string;

  begin
    str_utf := '–ô–¶–£–ö–ï–ù–ì–®–©–ó–•–™–≠–ñ–î–õ–û–†–ü–ê–í–´–§–Ø–ß–°–ú–ò–¢–¨–ë–Æ–π—Ü—É–∫–µ–Ω–≥—à—â–∑—Ö—ä—ç–∂–¥–ª–æ—Ä–ø–∞–≤—ã—Ñ—è—á—Å–º–∏—Ç—å–±—é¬†—ë';
    str_dos := 'âñìäÖçÉòôáïöùÜÑãéêèÄÇõîüóëåàíúÅû©Ê„™•≠£ËÈßÂÍÌ¶§´Æ‡Ø†¢Î‰ÔÁ·¨®‚Ï°Ó-Ò';

    num_tutf := 1; new_str := '';
    while num_tutf <= length(in_str_utf) do
    begin
      utf_sim := Copy(in_str_utf, num_tutf, 1);
      if (utf_sim = '–') or (utf_sim = '—') or (utf_sim = '¬') then
      begin
        utf_sim := Copy(in_str_utf, num_tutf, 2);
        num_tutf_t := 1;
        while (Copy(str_utf, num_tutf_t, 2) <> utf_sim) and (num_tutf_t <= length(str_utf)) do
          num_tutf_t := num_tutf_t +2;

        if (Copy(str_utf, num_tutf_t, 2) = utf_sim) then
          new_utf_sim := Copy(str_dos, Round((1 + num_tutf_t)/2), 1);

        inc(num_tutf); inc(num_tutf);
      end
      else
      begin
        new_utf_sim := utf_sim;
        inc(num_tutf);
      end;

      new_str := new_str + new_utf_sim;
    end;
    utf2dos := new_str;
  end;


  procedure convert_ch_utf2dos (var ch_convert : PChar);

  var
    num_t_fc, conv_del : longint;
    str_t_fc : string;

  begin
    num_t_fc := 0; conv_del := 0;
    while (not eof_ch(ch_convert, num_t_fc)) do
    begin
      if (ch_convert[num_t_fc] = '–') or (ch_convert[num_t_fc] = '—') or (ch_convert[num_t_fc] = '¬') then
      begin
        str_t_fc := ch_convert[num_t_fc] + ch_convert[num_t_fc +1];
        ch_convert[num_t_fc - conv_del] := utf2dos(str_t_fc)[1];
        inc(num_t_fc);
        inc(conv_del);
      end else
        ch_convert[num_t_fc - conv_del] := ch_convert[num_t_fc];

      inc(num_t_fc);
    end;
    p_ch_end_fast (ch_convert, num_t_fc - conv_del);

  end;


  procedure file_convert_utf2dos (put_file_convert : string);
  var
    file_convert, file_convert_t : file of byte;
    num_t_fc, num_t_fc_size : longint;
    sim_2_fc, sim_1_fc : byte;
    str_t_fc : string;

  begin
    Assign(file_convert, put_file_convert);
    reset(file_convert);
    Assign(file_convert_t, put_file_convert + '_t');
    rewrite(file_convert_t);

    num_t_fc := 0; num_t_fc_size := FileSize(file_convert);
    while (num_t_fc < num_t_fc_size) do
    begin
      seek(file_convert, num_t_fc);
      read(file_convert, sim_2_fc);
      if (chr(sim_2_fc) = '–') or (chr(sim_2_fc) = '—') or (chr(sim_2_fc) = '¬') then
      begin
        inc(num_t_fc);
        read(file_convert, sim_1_fc);
        str_t_fc := chr(sim_2_fc) + chr(sim_1_fc);
        write(file_convert_t, ord(utf2dos(str_t_fc)[1]));
      end
      else
      begin

        write(file_convert_t, sim_2_fc);
      end;
      inc(num_t_fc);
    end;
    close(file_convert);
    close(file_convert_t);
    erase(file_convert);
    rename (file_convert_t, put_file_convert);

  end;

end.