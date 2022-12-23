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


program copyright;

uses crt, dos,

  pro_dt, pro_util;
var
  file_out : text;

begin
  Assign(file_out, ParamStr(1));
  rewrite(file_out);
  WriteLn (file_out, '(' + #39 + date_and_time(f_str2num(ParamStr(2))) + #39 + ');');

  //  WriteLn (file_out, '  assembly := ' + #39 + f_date_time(f_str2num(ParamStr(2))) + #39 + ';');
{
  WriteLn (file_out, '  WriteLn;');
  WriteLn (file_out, '  WriteLn (' + #39 + ' ----------------------------------------------------' + #39 + ');');
  WriteLn (file_out, '  WriteLn (' + #39 + '  RSS to FidoNet' + #39 + ');');
  WriteLn (file_out, '  WriteLn (' + #39 + '  The rss2fido author Alexey Subbotin,' + #39 + ');');
  WriteLn (file_out, '  WriteLn (' + #39 + '  the date of the assembly on ' + #39 + '+ assembly);'); //generate
  WriteLn (file_out, '  WriteLn (' + #39 + '  Copyright (C) 2006' + #39 + ');');
  WriteLn (file_out, '  WriteLn (' + #39 + ' ----------------------------------------------------' + #39 + ');');
  WriteLn (file_out, '  WriteLn;');
}
  close(file_out);
  WriteLn('Create ', ParamStr(1), ' Done.');
end.

