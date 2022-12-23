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


program html;

uses crt, dos;

var
  file_out, file_in : text;
  line : string;
  num_t : byte;


begin
  Assign(file_in, ParamStr(1));
  reset(file_in);
  Assign(file_out, ParamStr(2));
  rewrite(file_out);

  WriteLn(file_out, '<html><head><title>RSS to FidoNet, rss2fido by_Rain 27/09-2006g.</title>');
  WriteLn(file_out, '  <body bgcolor="#FFFFFF" text="#050000" leftmargin="5" alink="#050000" vlink="#050000">');
  WriteLn(file_out, '    <font face="Arial"> <font size="+1">');
  WriteLn(file_out, '    <a name="top"></a>');
  WriteLn(file_out);

  while (not eof(file_in)) do
  begin
    readLn(file_in, line);
    line := line + #0;
    if (line <> #0) then
    begin
      num_t := 1;
      while (line[num_t] <> #0) do
      begin
        if (line[num_t] = ' ') then
          Write(file_out, '&nbsp;') else
          Write(file_out, line[num_t]);
        inc(num_t);
      end;
      WriteLn(file_out, '<br>');

    end else
    begin
      if (UpCase(ParamStr(3)) <> 'N') then
        WriteLn(file_out, '<hr>') else
        WriteLn(file_out, '<br>');
    end;
  end;

  WriteLn(file_out);
  WriteLn(file_out, '<br><br><br>');
  WriteLn(file_out, '&nbsp;&nbsp;<a href="#top">Top</a>');
  WriteLn(file_out, '&nbsp;&nbsp;or&nbsp;&nbsp;<a href="http://rss2fido.sourceforge.net">HomeDir</a>');
  WriteLn(file_out, '<br><br><br>');
  WriteLn(file_out, '</font>');
  WriteLn(file_out, '  </body>');
  WriteLn(file_out, '</html>');
  WriteLn(file_out);

  close(file_out);
  close(file_in);
  WriteLn('Create ', ParamStr(2), ' Done.');
end.

