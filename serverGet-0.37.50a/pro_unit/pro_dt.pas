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

unit pro_dt;

interface
uses dos;
  function GetDateTime : DateTime;

  function hour : string;
  function minute : string;
  function second : string;
  Function time : string;

  function year : string;
  function month : string;
  function day : string;
  Function date : string;

  function month_const : string;
  function month_const_cut : string;
  function week_const : string;
  function year_cut : string;

  function date_and_time (const mode_dt : byte) : string;

implementation

uses
  pro_util, pro_const;

  function GetDateTime : DateTime;
  var
    q_hour, q_minute, q_second, q_ssec : Word;
    q_year, q_month, q_day, q_week: Word;

  begin
    GetTime (q_hour, q_minute, q_second, q_ssec);
    GetDate (q_year, q_month, q_day, q_week);

    GetDateTime. year := q_year;
    GetDateTime. month := q_month;
    GetDateTime. day := q_day;
    GetDateTime. hour := q_hour;
    GetDateTime. min := q_minute;
    GetDateTime. sec := q_second;
  end;

  function hour : string;
  var
    q_hour, q_minute, q_second, q_ssec : Word;

  begin
    GetTime (q_hour, q_minute, q_second, q_ssec);
    hour := f_nol2(f_num2str(q_hour));
  end;

  function minute : string;
  var
    q_hour, q_minute, q_second, q_ssec : Word;

  begin
    GetTime (q_hour, q_minute, q_second, q_ssec);
    minute := f_nol2(f_num2str(q_minute));
  end;

  function second : string;
  var
    q_hour, q_minute, q_second, q_ssec : Word;

  begin
    GetTime (q_hour, q_minute, q_second, q_ssec);
    second := f_nol2(f_num2str(q_second));
  end;


  Function time : string;
  begin
    time := hour + ':' + minute + ':' + second;
  end;

  function year : string;
  var
    q_year, q_month, q_day, q_week: Word;

  begin
    GetDate(q_year, q_month, q_day, q_week);
    year := f_num2str(q_year);
  end;

  function year_cut : string;

  begin
    year_cut := Copy(year, 3, 2);
  end;

  function month : string;
  var
    q_year, q_month, q_day, q_week: Word;

  begin
    GetDate(q_year, q_month, q_day, q_week);
    month := f_nol2(f_num2str(q_month));
  end;

  function month_const : string;
  var
    q_year, q_month, q_day, q_week: Word;

  begin
    GetDate(q_year, q_month, q_day, q_week);
    month_const := month_const_str[q_month];
  end;

  function month_const_cut : string;

  begin
    month_const_cut := Copy(month_const, 1, 3);
  end;

  function week_const : string;
  var
    q_year, q_month, q_day, q_week: Word;

  begin
    GetDate(q_year, q_month, q_day, q_week);
    week_const := week_const_str[q_week];
  end;

  function day : string;
  var
    q_year, q_month, q_day, q_week: Word;

  begin
    GetDate(q_year, q_month, q_day, q_week);
    day := f_nol2(f_num2str(q_day));
  end;



  Function date : string;

  begin
    date := day + '-' + month + '-' + year;

  end;


  function date_and_time (const mode_dt : byte) : string;

  begin
    if mode_dt = 0 then
      date_and_time := date + ' ' + time;
    if mode_dt = 1 then
      date_and_time := Copy(date, 1, 2) + ' ' + month_const_cut + ' ' + time;
    if mode_dt = 2 then // log format
      date_and_time := Copy(date, 1, 2) + '-' + month_const_cut + '-' + year + ' ' + time;
    if mode_dt = 3 then  // pkt format
      date_and_time := Copy(date, 1, 2) + ' ' + month_const_cut + ' ' + year_cut + '  ' + time;

 //   writeLn(date_and_time);
  end;

end.