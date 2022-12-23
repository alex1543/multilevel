(*
 * Copyright (c) 2006
 *      Alexey Subbotin. All rights reserved.
 * Copyright (c) Andrew V. Sichevoi, Vitaly Siman

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

unit pro_uue;

 interface

  procedure UUEncodeCh (const chIn : PChar; var chOut : PChar); 
 
 implementation

uses pro_util, pro_const, pro_ch, pro_cfg;


type
    TTriplet = Array[0..2] of Byte;
    TKwartet = Array[0..3] of Byte;
 
{=============================================================================} 
procedure Triplet2Kwartet(Triplet: TTriplet; var Kwartet: TKwartet);
var
   i : Integer;
begin
 Kwartet[0] := (Triplet[0] SHR 2);
 Kwartet[1] := ((Triplet[0] SHL 4) AND $30) +
               ((Triplet[1] SHR 4) AND $0F);
 Kwartet[2] := ((Triplet[1] SHL 2) AND $3C) +
               ((Triplet[2] SHR 6) AND $03);
 Kwartet[3] := (Triplet[2] AND $3F);
 
 for i:=0 to 3 do begin
  if Kwartet[i] = 0 then Kwartet[i] := $40;
  inc(Kwartet[i],ord(' '))
 end;
end; {Triplet2Kwartet}

  procedure UUEncodeCh (const chIn : PChar; var chOut : PChar); 
  var
    str_t : String;
    Kwar : TKwartet;
    Trip : TTriplet;
    I, J, J2     : longint;
    ch_t : PChar;
    num_pos : longint;
    str_begin, str_end, str_length : string;
    length_uue : longint;

  begin
    str_length := GetParConf(pro_const. num_rss, 40, num_tplus);
    if (str_length = '') then str_length := '45';
    length_uue := f_str2num(str_length);

    num_pos := 0; chOut := nil;

    str_begin := GetParConf(pro_const. num_rss, 38, num_tplus);
    if (str_begin = '') then str_begin := f_enter_wr + 'section 1 of 1 of file feed.rss ' + by_Rain + f_enter_wr + 'begin 644 feed.rss';
    p_add_ch(chOut, num_pos, str_begin + f_enter_wr);

    I := 0;
    repeat
      ReadChBlock(chIn, ch_t, length_uue, I);
      I := I -1;
      str_t := Char(ord(' ') + strLen(ch_t) -1);

      J2 := 0;
      for J:=1 to (strLen(ch_t) div 3) do
      begin

        Trip[0] := ord(ch_t[J2]); inc(J2);
        Trip[1] := ord(ch_t[J2]); inc(J2);
        Trip[2] := ord(ch_t[J2]); inc(J2);

        Triplet2Kwartet(Trip, Kwar);
        str_t := str_t + Char(Kwar[0]) + Char(Kwar[1]) + Char(Kwar[2]) + Char(Kwar[3]);
      end;
      p_add_ch(chOut, num_pos, str_t + f_enter_wr);

    until (strLen(ch_t) < length_uue);

    str_end := GetParConf(pro_const. num_rss, 39, num_tplus);
    if (str_end = '') then str_end := '`' + f_enter_wr + 'end' + f_enter_wr;
    p_add_ch(chOut, num_pos, str_end);
    p_ch_end_fast(chOut, num_pos);

  end;

end.