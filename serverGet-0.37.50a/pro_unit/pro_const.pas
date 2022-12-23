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
unit pro_const;

interface

const
week_const_str : Array [0..6] Of String[10] =
  ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');
month_const_str : Array [1..12] Of String[10] =
  ('January', 'February', 'March', 'April', 'May', 'June', 
  'July', 'August', 'September', 'October', 'November', 'December');

var
  writetime : string[20] = ('00-Unk-0000 00:00:00');
var
  ch_lng : PChar = nil;

  num_rss : longint = 1;
  num_cycle : longint = 1;
  num_tplus : longint = 1;

  q_news, q_item : longint;

  str_teg : string; //
  num_re_str : byte; //

  put_file_error_open,
  put_file_error_exist,
  put_file_error_path : string;

  put_file_pkt : string;
  file_ex : string; //
  num_msg : longint;
  str_set, str_reset : Array[1..255] of string;
  multi : boolean = false;
  bool_template_macros : boolean;
  num_rss_end : longint = 1;

  re_atr_msg : Array[1..20] of string[10];

  put_file_cfg : string;

var
  par_cfg : Array of Array[1..41] of Array[1..5] of string;

  const_cfg : Array[1..41] of string[15] =
('name', 'address', 'sender', 'out', 'loader', 'template',
'language', 'send_path', 'send_format', 'send_from',
'send_to', 'send_faddress', 'send_taddress', 'send_subj',
'send_tearline', 'send_origin', 'send_flag',
'exec', 'create', 'pkt_password', 'pkt_area',
'pkt_format', 'item', 'boolean', 'delete', 'view',
'bso_file', 'comment', 'disable', 'unknown', 'rss',
'ProxyHost', 'ProxyPort', 'ProxyUser', 'ProxyPass', 'UserAgent',
'convert', 'uue_begin', 'uue_end', 'uue_length', 'convert_file');

const
  put_cfg_ver : Array[1..41] of boolean =
(false, true, true, true, true, true,
true, true, false, false,
false, false, false, false,
false, false, false,
true, true, false, false,
false, false, false, true, true,
false, false, false, false, true,
false, false, false, false, false,
false, false, false, false, true);

var
// default "macros" and "comment"
  sim_lang_id : Char = ('@');
  sim_comment : Char = (';');
  sim_exec : Char = (':');
  sim_view : Char = ('#');

const
  assembly : string[20] = {$I assembly.inc}
  by_Rain : string[20] = ('by_Rain 27/09-2006g.');

var
  put_rss_out : string = ('RSS_WORK_SAVE');
  put_file_lock : string = ('lock.ok');

const
  rss_none_name : string[7] = ('NONAME_');

  def_base : Array[1..7] of string[7] =
('squish', 'jam', 'msg', 'pkt', 'text', 'bso', '');
  pkt_mode : Array[1..2] of string[5] =
('net', 'local');

type tmsg = Array[1..16] of string[10];

const

  atr_msg : tmsg =
('Private', 'Received', 'Attach', 'Orphan',
'Local', 'FRq', 'RRc', 'URq', 'Crash',
'Sent', 'Transit', 'Kill', 'Hold',
'RRq', 'ARq', 'Scanned');


  atr_msg_del : tmsg =
('Pvt', 'Rcv', 'Att', 'Orp',
 'Loc', 'FRq', 'RRc', 'URq',
 'Cra', 'Snt', 'Trs', 'K/S',
 'Hld', 'RRq', 'ARq', 'Scn');

const

  art_bso_lo : Array[1..6] of string[9] =
('Normal', 'Delete', 'Hold', 'Direct', 'Crash', 'Immediate');

const
  ch_code : Array[1..5] of string[3] = ('win', 'iso', 'koi', 'mac', 'uni');


implementation


end.