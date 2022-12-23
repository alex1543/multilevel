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

unit pro_files;

interface

  procedure file_erase(const put_file_erase : string);
  procedure p_file_rename (const rename_in, rename_out : string);
  function f_file_size(const put_file_size : string) : longint;
  procedure erase_ext_file(const erase_ext_file : string);
  procedure p_lock (const put_file_lock : string);
  procedure p_lock_file (const put_file_lock : string);

  procedure p_io_file(const put_in_io_file : string);
  function f_open_first_file (const foff_file, foff_lang_string : string) : string;
  procedure exist_error_file (const put_exist_error_file : string);
  function search_file (const dir_search_file, str_file_suf : string) : longint;

  function GetHyperLinkFile (const put_link_file : string) : string;

implementation

uses
  crt, dos,

  pro_util, pro_string, pro_const, pro_lang, pro_rss;

  function GetHyperLinkFile (const put_link_file : string) : string;
  var
    link_file : text;
    line, str_defa, str_all_link : string;
    bool_defa : boolean;

  begin
    GetHyperLinkFile := '';
    if (not (pos(':', put_link_file) = 0)) and (not f_nix_dir(put_link_file)) and (UpCase(f_file_ext(put_link_file)) = 'URL') then
    begin
      p_io_file(put_link_file);
      Assign(link_file, put_link_file);
      reset(link_file);
      str_defa := ''; str_all_link := '';
      bool_defa := false;
      repeat
        ReadLn(link_file, line);
        if not (pos('://', line) = 0) then
          if (pos('=', (Copy(line, 1, pos('://', line)))) = 0) then str_all_link := line;
        if (UpCase(line) = UpCase('[Default]')) then bool_defa := true;
        if (bool_defa) and (UpCase(Copy(line, 1, length('BASEURL='))) = UpCase('BASEURL=')) then
           str_defa := f_re_string_pos_end(line, 'BASEURL=');
        if (bool_defa) and ((not (UpCase(line) = UpCase('[Default]'))) and (not (pos('[', line) = 0)) and (not (pos(']', line) = 0))) then bool_defa := false;
        until eof(link_file) or (UpCase(line) = UpCase('[InternetShortcut]'));
      if (UpCase(line) = UpCase('[InternetShortcut]')) then
      begin
        repeat
          ReadLn(link_file, line);
        until eof(link_file) or (UpCase(Copy(line, 1, length('URL='))) = UpCase('URL='));
        if (UpCase(Copy(line, 1, length('URL='))) = UpCase('URL=')) then
          GetHyperLinkFile := f_re_string_pos_end(line, 'URL=');
      end;

      if (GetHyperLinkFile = '') then
      begin
        if not (str_defa = '') then
        GetHyperLinkFile := str_defa else
        GetHyperLinkFile := str_all_link;
      end;

      close(link_file);
    end;
    if (GetHyperLinkFile = '') then
      GetHyperLinkFile := put_link_file;
  end;

  function search_file (const dir_search_file, str_file_suf : string) : longint;
  var
    SR : SearchRec;

  begin
    search_file := 0;
    FindFirst(dir_search_file + str_file_suf, AnyFile, SR);
    while (DosError = 0) do
    begin
      inc(search_file);
      FindNext(SR);
    end;
    FindClose(SR);
  end;

  procedure exist_error_file (const put_exist_error_file : string);

  begin
    if not file_exist (put_exist_error_file) then
    begin
      put_file_error_exist := put_exist_error_file;
      p_lang('error_exist', false);
    end;

  end;

  procedure p_io_file(const put_in_io_file : string);
  var
    in_io_file : text;

  begin
    Assign(in_io_file, put_in_io_file);
    {$I-} reset(in_io_file); {$I+}
    if IOResult <> 0 then
    begin
      pro_const. put_file_error_open := put_in_io_file;
      p_lang('error_open', true);
    end;
    close(in_io_file);
  end;

  function f_open_first_file (const foff_file, foff_lang_string : string) : string;
  var
    SR : SearchRec;
    put_file_open_first : string;

  begin
    put_file_open_first := f_expand('/' + f_file_name_del_ext(f_prog_name) + '.' + foff_file);
    FindFirst(put_file_open_first, AnyFile, SR);
    if (DosError = 0) then
      f_open_first_file := put_file_open_first
    else begin
      FindClose(SR);
      FindFirst(f_expand('/' + '*' + '.' + foff_file), AnyFile, SR);
      if (DosError = 0) then
        f_open_first_file := f_expand(SR.Name) else
        p_lang(foff_lang_string, true);

    end;
    FindClose(SR);
    p_io_file(f_open_first_file);

  end;

  procedure p_lock_file (const put_file_lock : string);
  var
    file_lock : file of byte;

  begin
    Assign(file_lock, put_file_lock);
    reset(file_lock);

  end;

  procedure file_erase(const put_file_erase : string);
  var
    file_erase : text;

  begin
    p_io_file(put_file_erase);
    Assign(file_erase, put_file_erase);
    erase(file_erase);
  end;

  procedure p_file_rename (const rename_in, rename_out : string);
  var
    file_rename : text;

  begin
    if (UpCase(rename_in) <> UpCase(rename_out)) then
    begin
      p_io_file(rename_in);
      Assign(file_rename, rename_in);
      if file_exist(rename_out) then
        file_erase(rename_out);
      Rename(file_rename, rename_out);
    end;
  end;

  function f_file_size(const put_file_size : string) : longint;
  var
    file_size : file of byte;

  begin
    if file_exist(put_file_size) then
    begin
      p_io_file(put_file_size);
      Assign(file_size, put_file_size);
      reset(file_size);
      f_file_size := FileSize(file_size);
      close(file_size);
    end else
      f_file_size := 0;
  end;


  procedure erase_ext_file(const erase_ext_file : string);
  var
      SR : SearchRec;


  begin
    FindFirst('*' + erase_ext_file, AnyFile, SR);
    while (DosError = 0) do
    begin
      file_erase(f_expand(SR. Name));
      FindNext(SR);
    end;
    FindClose(SR);
  end;


  procedure p_lock (const put_file_lock : string);
  var
    file_lock : text;

    procedure doserror_ver;

    begin
      if not (IOResult = 0) then
      begin
        WriteLn('Error: another copy exist');
        delay(600);
        WriteLn;
        halt(2);
      end;

    end;

  begin
    Assign(file_lock, put_file_lock);
    {$I-} rewrite(file_lock); {$I+}
    doserror_ver;
    WriteLn(file_lock, 'You can run only one copy');
    WriteLn(file_lock, 'of the program that there were no mistakes');
    WriteLn(file_lock, 'write and read files of the programme.');
    close(file_lock);
    {$I-} reset(file_lock); {$I+}
    doserror_ver;

  end;

end.