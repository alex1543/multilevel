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
unit pro_par;

interface

  procedure p_wr_copyright(const bool_par : boolean);
  procedure p_par(const mode_par : string; const bool_par : boolean);
  procedure p_parse_str_in_prog;
  procedure SetWindowSt (const str_WindowSt : string);
  procedure set_code_page (const code_page : longint);
  function put_cfg_ver_cp_conv (const str_cp_conv : string; const cp_conv, num_cp_conv : longint) : string;
  procedure SetCtrlHandler;

implementation

uses
  crt, dos,
  {$ifdef Win32} windows, {$endif}
  pro_util, pro_const, pro_string, pro_cp, pro_files, pro_ch, pro_lang;

  function Ctrl_Handler(Ctrl: Longword): LongBool;StdCall;
  begin
  {$ifdef Win32}
    if (Ctrl in [CTRL_CLOSE_EVENT, CTRL_LOGOFF_EVENT, CTRL_SHUTDOWN_EVENT]) then 
      bool_exit := true;
    Result := true; 
  {$endif}
  end;

  procedure SetCtrlHandler;

  begin
  {$ifdef Win32}
    // добавляем обработчик особой ситуации
    SetConsoleCtrlHandler(Ctrl_Handler, TRUE);
  {$endif}
  end;

  function put_cfg_ver_cp_conv (const str_cp_conv : string; const cp_conv, num_cp_conv : longint) : string;
  var
    str_t : string;

  begin
    str_t := str_cp_conv;
    // под другими ОС выводим пути как есть
    {$ifdef Win32}
    if (pro_const. put_cfg_ver[num_cp_conv]) then
    begin
      if (cp_conv = 866) then
        WinToDos(str_t);
      if (cp_conv = 1251) then
        DosToWin(str_t);
    end;
    {$endif}
    put_cfg_ver_cp_conv := str_t;
  end;

  procedure set_code_page (const code_page : longint);

  begin
  {$ifdef Win32}
    SetConsoleCP(code_page);
    SetConsoleOutputCP(code_page);
  {$endif}
  end;

  procedure SetWindowSt (const str_WindowSt : string);
  {$ifdef Win32}
  var
    str_WindowSt_t : string;
  {$endif}

  begin
  {$ifdef Win32}
    str_WindowSt_t := str_WindowSt;
    DosToWin(str_WindowSt_t);
    // сменить заголовок своего окна
    SetConsoleTitle(strToch(str_WindowSt_t));
    // активного окна
    // SetWindowText(GetForegroundWindow, strToch(str_WindowSt_t));
    // чужого окна
    // SetWindowText(FindWindow(nil, 'Text'),'reText');
  {$endif}

  end;

  procedure p_wr_copyright(const bool_par : boolean);

  begin
    WriteLn;
    WriteLn (' ----------------------------------------------------');
    WriteLn ('  RSS to FidoNet');
    WriteLn ('  The rss2fido author Alexey Subbotin,');
    WriteLn ('  the date of the assembly on '+ assembly);
    WriteLn ('  Copyright (C) 2006-2007');
    WriteLn (' ----------------------------------------------------');
    WriteLn;
    if (bool_par) then
      halt(0);
  end;

  procedure p_par(const mode_par : string; const bool_par : boolean);
  var
    put_file_inc : string;

  begin
    put_file_inc := f_expand(mode_par + '.txt');
    if (file_exist(put_file_inc)) then
    begin
      p_io_file(put_file_inc);
      view_file(put_file_inc);
    end else
    begin
      if (UpCase(mode_par) = 'HELP') then
      begin
        {$I help.inc}
      end;
      if (UpCase(mode_par) = 'INFO') then
      begin
        {$I info.inc}
      end;
    end;
    if (bool_par) then
      halt(3);

  end;

  procedure p_parse_str_in_prog;
  var
    num_pr_str, num_t : byte;

    procedure p_ver_aset_par(const str_in_ver_aset_par : string);

    begin
      if (UpCase(str_in_ver_aset_par) = UpCase(Copy(ParamStr(num_t), 1, length(str_in_ver_aset_par)))) then
      begin
        par_cfg[1][num_pr_str][1] := f_re_string_pos_end(ParamStr(num_t), str_in_ver_aset_par);
        WinToDos(par_cfg[1][num_pr_str][1]);
        par_cfg[1][num_pr_str][1] := f_lang_re(par_cfg[1][num_pr_str][1]);
        inc(num_t);
      end;
    end;

  begin

    num_t := 1;
    while (ParamStr(num_t) <> '') do
    begin
      num_pr_str := 1;
      while (const_cfg[num_pr_str] <> '') do
      begin
        if (UpCase(Copy(f_start_end_del_str_simvol(const_cfg[num_pr_str], '=-'), 1, length(f_start_end_del_str_simvol(ParamStr(num_t), '=-')))) = UpCase(f_start_end_del_str_simvol(ParamStr(num_t), '=-'))) and
           (ParamStr(num_t +1) <> '') then
        begin
          par_cfg[1][num_pr_str][1] := ParamStr(num_t +1);
          WinToDos(par_cfg[1][num_pr_str][1]);
          par_cfg[1][num_pr_str][1] := f_lang_re(par_cfg[1][num_pr_str][1]);
          inc(num_t); inc(num_t);
        end else
        begin
          p_ver_aset_par('-' + const_cfg[num_pr_str] + '=');
          p_ver_aset_par('--' + const_cfg[num_pr_str] + '=');
          p_ver_aset_par('-' + const_cfg[num_pr_str]);
          p_ver_aset_par('--' + const_cfg[num_pr_str]);

        end;
        inc(num_pr_str);
      end;
      inc(num_t);
    end;
  end;

end.