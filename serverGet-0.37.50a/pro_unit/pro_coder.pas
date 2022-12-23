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
unit pro_coder;

interface

  procedure convert_ch (var ch_convert : PChar; const ch_mode : string; const bool_back : boolean);

implementation


uses
  crt, dos,

  pro_util, pro_cp, pro_const;

  procedure convert_ch (var ch_convert : PChar; const ch_mode : string; const bool_back : boolean);
  var
    num_t_fc : longint;
    str_convert : string;
    mode_convert_ch : byte;

  begin
    num_t_fc := 1; mode_convert_ch := 0;
    while (UpCase(ch_code[num_t_fc]) <> UpCase(ch_mode)) and
      (ch_code[num_t_fc] <> '') do inc(num_t_fc);
    if (UpCase(ch_code[num_t_fc]) = UpCase(ch_mode)) then
      mode_convert_ch := num_t_fc;

  if not (mode_convert_ch = 0) then
  begin
    num_t_fc := 0;
    while (ch_convert[num_t_fc] <> #0) do
    begin
      str_convert := ch_convert[num_t_fc];

    if (not bool_back) then
    begin
      if (mode_convert_ch = 1) then
        WinToDos (str_convert);
      if (mode_convert_ch = 2) then
        IsoToDos (str_convert);
      if (mode_convert_ch = 3) then
        KoiToDos (str_convert);
      if (mode_convert_ch = 4) then
        MacToDos (str_convert);
      if (mode_convert_ch = 5) then
        UnicodeToDos (str_convert);
    end else
    begin
      if (mode_convert_ch = 1) then
        DosToWin (str_convert);
      if (mode_convert_ch = 2) then
        DosToIso (str_convert);
      if (mode_convert_ch = 3) then
        DosToKoi (str_convert);
      if (mode_convert_ch = 4) then
        DosToMac (str_convert);
      if (mode_convert_ch = 5) then
        DosToUnicode (str_convert);
    end;

      ch_convert[num_t_fc] := str_convert[1];
      inc(num_t_fc);
    end;
  end;
  end;


end.