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


program utf2dos;

uses crt, dos,

  pro_utf, pro_util;

  procedure p_help_par;
  var
    help_par : string;

  begin
    help_par := ParamStr(1);
    if (UpCase(help_par) = '') or
       (f_help(help_par)) then
    begin
      WriteLn;
      WriteLn('Example: utf2dos.exe d:\util\utf2dos\convert_file.html');
      WriteLn;
      halt(3);
    end;
  end;

var
  put_file_convert : string;

begin
  WriteLn;
  WriteLn('                                                       by_Rain 14/12-2006g.');
  p_help_par;
  WriteLn;
  if (file_exist(ParamStr(1))) then
  begin
    put_file_convert := ParamStr(1);
    file_convert_utf2dos(put_file_convert);
    WriteLn('Done.');
  end else
    WriteLn('Error: dont exist file: ', ParamStr(1));

end.

