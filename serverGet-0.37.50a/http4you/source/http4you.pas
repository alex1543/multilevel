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


program http4you;

uses crt, dos,

  pro_master, pro_util;

  procedure p_help_par;
  var
    help_par : string;

  begin
    help_par := ParamStr(1);
    if (UpCase(help_par) = '') or
       (f_help(help_par)) then
    begin
      WriteLn;
      WriteLn('Example: http4you.exe http://domain.ru/dowmload.file d:\util\http4you\save.file d:\util\http4you\log.file');
      WriteLn;
      halt(3);
    end;
  end;

var
  put_http, put_save_file, put_log_file : string;

begin
  WriteLn;
  WriteLn('                                                       by_Rain 19/12-2006g.');
  p_help_par;
  WriteLn;

  put_http := ParamStr(1);
  put_save_file := ParamStr(2);
  put_log_file := ParamStr(3);
  p_get_inet_file(put_http, put_save_file, put_log_file);
  WriteLn('Done.');

end.

