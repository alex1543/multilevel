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

unit pro_pkt;

interface

  procedure p_pkt_create(const ch_create : PChar; const put_pkt_create : string);

implementation

uses
  crt, dos,

  pro_const, pro_string, pro_dt, pro_msg, pro_lang, pro_ch, pro_util, pro_files,

  skCommon;

const
  pkt_ver : string[4] = chr($00) + chr($00) + chr($02) + chr($00);
  pkt_end : string[4] = chr($00) + chr($00) + chr($00) + chr($00);
var
    atr_re_msg : tmsg;
    str_area : string;

type
  t_net_pkt_msg = record
    origNode,
    destNode,
    year,
    month,
    day,
    hour,
    minute,
    second : word;
    pkt_ver : string[4];
    origNet,
    destNet : word;
    prodCode, serialNo : byte;
    password : string[8];
    origZone, destZone : word;
    fill : string[20];

  end;
var
  net_pkt_msg : t_net_pkt_msg;

  function net_PacketMessage : string;

  begin
    net_PacketMessage := 
       Chr(Lo(net_pkt_msg. origNode)) + Chr(Hi(net_pkt_msg. origNode))
     + Chr(Lo(net_pkt_msg. destNode)) + Chr(Hi(net_pkt_msg. destNode))
     + Chr(Lo(net_pkt_msg. year)) + Chr(Hi(net_pkt_msg. year))
     + Chr(Lo(net_pkt_msg. month)) + Chr(Hi(net_pkt_msg. month))
     + Chr(Lo(net_pkt_msg. day)) + Chr(Hi(net_pkt_msg. day))
     + Chr(Lo(net_pkt_msg. hour)) + Chr(Hi(net_pkt_msg. hour))
     + Chr(Lo(net_pkt_msg. minute)) + Chr(Hi(net_pkt_msg. minute))
     + Chr(Lo(net_pkt_msg. second)) + Chr(Hi(net_pkt_msg. second))
     + net_pkt_msg. pkt_ver
     + Chr(Lo(net_pkt_msg. origNet)) + Chr(Hi(net_pkt_msg. origNet))
     + Chr(Lo(net_pkt_msg. destNet)) + Chr(Hi(net_pkt_msg. destNet))
     + chr(net_pkt_msg. prodCode) + chr(net_pkt_msg. serialNo)
     + net_pkt_msg. password
     + chr(net_pkt_msg. origZone) + chr($00)
     + chr(net_pkt_msg. destZone) + chr($00)
     + net_pkt_msg. fill;

  end;

type
  PktMessage = Record
    pkt_ver : string[4];
    OrigNode,
    DestNode,
    OrigNet,
    DestNet,
    Attr,
    Cost        : Word;
    Date        : String[19];
    Too         : String[35];
    From        : String[35];
    Subject     : String[71];
  End;

var
    PM : PktMessage;

Const 
  atr_msg_pkt : Array[1..16] of word =
($0001, $0004, $0010, $0040, $0100, $0800, $0000, $0000,
 $0002, $0008, $0020, $0000, $0080, $0200, $0000, $0000);

  Function PacketMessage : String;

  Begin

    PacketMessage := PM. pkt_ver
      + Chr(Lo(PM. OrigNode)) + Chr(Hi(PM. OrigNode))
      + Chr(Lo(PM. DestNode)) + Chr(Hi(PM. DestNode))
      + Chr(Lo(PM. OrigNet)) + Chr(Hi(PM. OrigNet))
      + Chr(Lo(PM. DestNet)) + Chr(Hi(PM. DestNet))
      + Chr(Lo(PM. Attr)) + Chr(Hi(PM. Attr))
      + Chr(Lo(PM. Cost)) + Chr(Hi(PM. Cost))
      + PM. Date + #0
      + PM. Too + #0
      + PM. From + #0
      + PM. Subject + #0;

  End;

  procedure p_set_atr_pkt (const in_re_atr_msg, in_set_atr_msg : tmsg);
  var
    num_t, num_temp : byte;

  begin
    num_t := 1; PM. Attr := $0000;
    while (atr_msg[num_t] <> '') do
    begin
      num_temp := 1;
      while (in_re_atr_msg[num_temp] <> '') do
      begin
        if (UpCase(in_re_atr_msg[num_temp]) = UpCase(in_set_atr_msg[num_t])) then
          PM. Attr := atr_msg_pkt[num_t];
        inc(num_temp);
      end;
      inc(num_t);
    end;
  end;

  procedure p_pkt_create(const ch_create : PChar; const put_pkt_create : string);
  var
    file_pkt : file of byte;
    address_t, address_f : TAddress;
    str_seen_node : string;

    procedure p_pkt_address_ver (const str_in_address_ver : string; var in_address_ver : TAddress);

    begin
    if not (StrToAddress(str_in_address_ver, in_address_ver)) then
      p_lang('error_address', true);

    end;
var
  hour, minute, second, ssec : Word;
  year, month, day, ned: Word;

  begin

    put_file_pkt := put_pkt_create + '/' + GenerateMSGID + '.pkt';

    p_pkt_address_ver (par_cfg[pro_const. num_rss][13][pro_const. num_tplus], address_t);
    p_pkt_address_ver (par_cfg[pro_const. num_rss][12][pro_const. num_tplus], address_f);

    Assign(file_pkt, put_file_pkt);
    rewrite(file_pkt);

    p_re_atr(par_cfg[pro_const. num_rss][17][pro_const. num_tplus], atr_re_msg);
    p_set_atr_pkt (atr_re_msg, atr_msg);
    p_set_atr_pkt (atr_re_msg, atr_msg_del);

    if (UpCase(par_cfg[pro_const. num_rss][22][pro_const. num_tplus]) = UpCase(pkt_mode[1])) or
       (par_cfg[pro_const. num_rss][22][pro_const. num_tplus] = '') then
    begin
      net_pkt_msg. origNode := address_f. node;
      net_pkt_msg. destNode := address_t. node;

      GetDate(Year, month, day, ned);
      GetTime (hour, minute, second, ssec);

      net_pkt_msg. year := year;
      net_pkt_msg. month := month;
      net_pkt_msg. day := day;
      net_pkt_msg. hour := hour;
      net_pkt_msg. minute := minute;
      net_pkt_msg. second := second;
      net_pkt_msg. pkt_ver := pkt_ver;

      net_pkt_msg. origNet := address_f. net;
      net_pkt_msg. destNet := address_t. net;

      net_pkt_msg. prodCode := $FF;
      net_pkt_msg. serialNo := $01;

      net_pkt_msg. password := str_fix(par_cfg[pro_const. num_rss][20][pro_const. num_tplus], 8, Chr($00));

      net_pkt_msg. origZone := address_f. Zone;
      net_pkt_msg. destZone := address_t. Zone;

      net_pkt_msg. fill := str_fix('', 18, Chr($00));

      file_add (file_pkt, net_PacketMessage);
    end;

    PM. pkt_ver := pkt_ver;
    PM. OrigNode := address_f. node;
    PM. DestNode := address_t. node;
    PM. OrigNet := address_f. net;
    PM. DestNet := address_t. net;
    PM. Date := date_and_time(3);
    PM. Too := par_cfg[pro_const. num_rss][11][pro_const. num_tplus];
    PM. From := par_cfg[pro_const. num_rss][10][pro_const. num_tplus];
    PM. Subject := par_cfg[pro_const. num_rss][14][pro_const. num_tplus];
    file_add (file_pkt, PacketMessage);

    str_area := par_cfg[pro_const. num_rss][21][pro_const. num_tplus];
    if (str_area <> '') then
      str_area := 'AREA:' + str_area;
    file_add (file_pkt, str_area);
    file_add (file_pkt, #13 + #01 + 'MSGID: ' + AddressToStrEx(address_f) + ' ' + GenerateMSGID + #13);

    file_add_ch (file_pkt, ch_create);

    file_add (file_pkt, #13 + '--- ' + par_cfg[pro_const. num_rss][15][pro_const. num_tplus]);
    file_add (file_pkt, #13 + ' * Origin: ' + par_cfg[pro_const. num_rss][16][pro_const. num_tplus] + ' (' + AddressToStrEx(address_f) + ')');

    if (address_f.node <> address_t.node) then
      str_seen_node := ' ' + f_num2str(address_f.node) else
      str_seen_node := '';

    file_add (file_pkt, #13 + 'SEEN-BY: ' + AddressToStrPointless(address_t) + str_seen_node);
    file_add (file_pkt, #13 + #01 + 'PATH: ' + AddressToStrPointless(address_f) + #13 + pkt_end);

    close(file_pkt);

    num_msg := search_file(put_pkt_create + '/', '*.pkt');
    p_lang('pkt', false);
  end;

end.
