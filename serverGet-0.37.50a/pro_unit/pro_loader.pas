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


unit pro_loader;

interface

  procedure get_inet_file (const put_inet_file, put_out_file, put_log_file : string);

implementation

uses
  crt, dos,

  pro_util, pro_const,

  httpsend, classes;

  procedure get_inet_file (const put_inet_file, put_out_file, put_log_file : string);
  var
    HTTP: THTTPSend;
    l: tstringlist;
    file_out : text;

  begin
    HTTP := THTTPSend.Create;


    {:Address of proxy server (IP address or domain name) where you want to
     connect in @link(HTTPMethod) method.}
 //   property ProxyHost: string read FProxyHost Write FProxyHost;

if not (par_cfg[pro_const. num_rss][32][pro_const. num_tplus] = '') then
  HTTP. ProxyHost := par_cfg[pro_const. num_rss][32][pro_const. num_tplus];

    {:Port number for proxy connection. Default value is 8080.}
 //   property ProxyPort: string read FProxyPort Write FProxyPort;

if not (par_cfg[pro_const. num_rss][33][pro_const. num_tplus] = '') then
  HTTP. ProxyPort := par_cfg[pro_const. num_rss][33][pro_const. num_tplus];

    {:Username for connect to proxy server where you want to connect in
     HTTPMethod method.}
 //   property ProxyUser: string read FProxyUser Write FProxyUser;

if not (par_cfg[pro_const. num_rss][34][pro_const. num_tplus] = '') then
  HTTP. ProxyUser := par_cfg[pro_const. num_rss][34][pro_const. num_tplus];

    {:Password for connect to proxy server where you want to connect in
     HTTPMethod method.}
 //   property ProxyPass: string read FProxyPass Write FProxyPass;

if not (par_cfg[pro_const. num_rss][35][pro_const. num_tplus] = '') then
  HTTP. ProxyPass := par_cfg[pro_const. num_rss][35][pro_const. num_tplus];

    {:Here you can specify custom User-Agent indentification. By default is
     used: 'Mozilla/4.0 (compatible; Synapse)'}
 //   property UserAgent: string read FUserAgent Write FUserAgent;

if not (par_cfg[pro_const. num_rss][36][pro_const. num_tplus] = '') then // default
  HTTP. UserAgent := par_cfg[pro_const. num_rss][36][pro_const. num_tplus] else
  HTTP. UserAgent := 'Mozilla/4.0 (' + by_Rain + ')';

    l := TStringList.create;
      if (HTTP.HTTPMethod('GET', put_inet_file)) then
      begin

        if (put_log_file = '') then
          writeln(Http.headers.text) else
        begin
          Assign(file_out, put_log_file);
          if (not file_exist(put_log_file)) then
            rewrite(file_out) else
            append(file_out);

          writeLn(file_out, Http.headers.text);
          close(file_out);

        end;

        l.loadfromstream(Http.Document);
        Assign(file_out, put_out_file);
        rewrite(file_out);
        writeLn(file_out, l.text);
        close(file_out);

      end;
      l.free;
      HTTP.Free;
  end;

end.