(*
 * Copyright (c) 2006
 *      Alexey Subbotin. All rights reserved.
 * Copyright (c) XGSoft 2001-2002

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
unit pro_cp;

interface

    function DosToIso(var Text: string): boolean;
    function DosToKoi(var Text: string): boolean;
    function DosToMac(var Text: string): boolean;
    function DosToUnicode(var Text: string): boolean;
    function DosToWin(var Text: string): boolean;
    function IsoToDos(var Text: string): boolean;
    function IsoToKoi(var Text: string): boolean;
    function IsoToMac(var Text: string): boolean;
    function IsoToUnicode(var Text: string): boolean;
    function IsoToWin(var Text: string): boolean;
    function KoiToDos(var Text: string): boolean;
    function KoiToIso(var Text: string): boolean;
    function KoiToMac(var Text: string): boolean;
    function KoiToUnicode(var Text: string): boolean;
    function KoiToWin(var Text: string): boolean;
    function MacToDos(var Text: string): boolean;
    function MacToIso(var Text: string): boolean;
    function MacToKoi(var Text: string): boolean;
    function MacToUnicode(var Text: string): boolean;
    function MacToWin(var Text: string): boolean;
    function UnicodeToDos(var Text: string): boolean;
    function UnicodeToIso(var Text: string): boolean;
    function UnicodeToKoi(var Text: string): boolean;
    function UnicodeToMac(var Text: string): boolean;
    function UnicodeToWin(var Text: string): boolean;
    function WinToDos(var Text: string): boolean;
    function WinToIso(var Text: string): boolean;
    function WinToKoi(var Text: string): boolean;
    function WinToMac(var Text: string): boolean;
    function WinToUnicode(var Text: string): boolean;


implementation

function DosToIso(var Text: string): boolean;
var InString: string;
    b: Char;
    i, Len: integer;
    c: byte;
begin
Result:=true;
InString:=Text;
Len:=Length(InString);
try
        for i:=1 to Len do begin
                b:=InString[i];
                c:=Ord(b);
                case c of
        {a}             160: c:=208; 161: c:=209; 162: c:=210; 163: c:=211; 164: c:=212; 165: c:=213; 166: c:=214; 167: c:=215; 168: c:=216; 169: c:=217; 170: c:=218; 171: c:=219; 172: c:=220; 173: c:=221; 174: c:=222; 175: c:=223; 224: c:=224; 225: c:=225; 226: c:=226; 227: c:=227; 228: c:=228; 229: c:=229; 230: c:=230; 231: c:=231; 232: c:=232; 233: c:=233; 234: c:=234; 235: c:=235; 236: c:=236; 237: c:=237; 238: c:=238; 239: c:=239; 241: c:=241;
        {A}             128: c:=176; 129: c:=177; 130: c:=178; 131: c:=179; 132: c:=180; 133: c:=181; 134: c:=182; 135: c:=183; 136: c:=184; 137: c:=185; 138: c:=186; 139: c:=187; 140: c:=188; 141: c:=189; 142: c:=190; 143: c:=191; 144: c:=192; 145: c:=193; 146: c:=194; 147: c:=195; 148: c:=196; 149: c:=197; 150: c:=198; 151: c:=199; 152: c:=200; 153: c:=201; 154: c:=202; 155: c:=203; 156: c:=204; 157: c:=205; 158: c:=206; 159: c:=207; 240: c:=161; 252: c:=240
                        end;
                b:=Char(c);
                InString[i]:=b
                end;
        Text:=InString
        except
        Result:=false
        end
end;

function DosToKoi(var Text: string): boolean;
var InString: string;
    b: Char;
    i, Len: integer;
    c: byte;
begin
Result:=true;
InString:=Text;
Len:=Length(InString);
try
        for i:=1 to Len do begin
                b:=InString[i];
                c:=Ord(b);
                case c of
        {a}             160: c:=193; 161: c:=194; 162: c:=215; 163: c:=199; 164: c:=196; 165: c:=197; 166: c:=214; 167: c:=218; 168: c:=201; 169: c:=202; 170: c:=203; 171: c:=204; 172: c:=205; 173: c:=206; 174: c:=207; 175: c:=208; 224: c:=210; 225: c:=211; 226: c:=212; 227: c:=213; 228: c:=198; 229: c:=200; 230: c:=195; 231: c:=222; 232: c:=219; 233: c:=221; 234: c:=223; 235: c:=217; 236: c:=216; 237: c:=220; 238: c:=192; 239: c:=209; 241: c:=163;
        {A}             128: c:=225; 129: c:=226; 130: c:=247; 131: c:=231; 132: c:=228; 133: c:=229; 134: c:=246; 135: c:=250; 136: c:=233; 137: c:=234; 138: c:=235; 139: c:=236; 140: c:=237; 141: c:=238; 142: c:=239; 143: c:=240; 144: c:=242; 145: c:=243; 146: c:=244; 147: c:=245; 148: c:=230; 149: c:=232; 150: c:=227; 151: c:=254; 152: c:=251; 153: c:=253; 154: c:=255; 155: c:=249; 156: c:=248; 157: c:=252; 158: c:=224; 159: c:=241; 240: c:=179; 252: c:=78
                        end;
                b:=Char(c);
                InString[i]:=b
                end;
        Text:=InString
        except
        Result:=false
        end
end;

function DosToMac(var Text: string): boolean;
var InString: string;
    b: char;
    i, Len: integer;
    c: byte;
begin
Result:=true;
InString:=Text;
Len:=Length(InString);
try
        for i:=1 to Len do begin
                b:=InString[i];
                c:=Ord(b);
                case c of
        {a}             160: c:=255; 161: c:=240; 240: c:=252
                        end;
                b:=Char(c);
                InString[i]:=b
                end;
        Text:=InString
        except
        Result:=false
        end
end;

function DosToUnicode(var Text: string): boolean;
var InString, OutString, b: string;
    i, Len: integer;
    c: byte;
    a: Char;
begin
Result:=true;
InString:=Text; OutString:='';
Len:=Length(InString);
try
        b:=#255#254; OutString:=OutString+b;
        for i:=1 to Len do begin
                a:=InString[i];
                c:=Ord(a);
                case c of
{a english}             97: b:=#97#0; 98: b:=#98#0; 99: b:=#99#0; 100: b:=#100#0; 101: b:=#101#0; 102: b:=#102#0; 103: b:=#103#0; 104: b:=#104#0; 105: b:=#105#0; 106: b:=#106#0; 107: b:=#107#0; 108: b:=#108#0; 109: b:=#109#0; 110: b:=#110#0; 111: b:=#111#0; 112: b:=#112#0; 113: b:=#113#0; 114: b:=#114#0; 115: b:=#115#0; 116: b:=#116#0; 117: b:=#117#0; 118: b:=#118#0; 119: b:=#119#0; 120: b:=#120#0; 121: b:=#121#0; 122: b:=#122#0;
{A english}             65: b:=#65#0; 66: b:=#66#0; 67: b:=#67#0; 68: b:=#68#0; 69: b:=#69#0; 70: b:=#70#0; 71: b:=#71#0; 72: b:=#72#0; 73: b:=#73#0; 74: b:=#74#0; 75: b:=#75#0; 76: b:=#76#0; 77: b:=#77#0; 78: b:=#78#0; 79: b:=#79#0; 80: b:=#80#0; 81: b:=#81#0; 82: b:=#82#0; 83: b:=#83#0; 84: b:=#84#0; 85: b:=#85#0; 86: b:=#86#0; 87: b:=#87#0; 88: b:=#88#0; 89: b:=#89#0; 90: b:=#90#0;
{0..9}                  48: b:=#48#0; 49: b:=#49#0; 50: b:=#50#0; 51: b:=#51#0; 52: b:=#52#0; 53: b:=#53#0; 54: b:=#54#0; 55: b:=#55#0; 56: b:=#56#0; 57: b:=#57#0;
{Спец символы}          33: b:=#33#0; 13: b:=#13#0; 9: b:=#9#0; 10: b:=#10#0; 32: b:=#32#0; 64: b:=#64#0; 35: b:=#35#0; 36: b:=#36#0; 37: b:=#37#0; 94: b:=#94#0; 38: b:=#38#0; 42: b:=#42#0; 40: b:=#40#0; 41: b:=#41#0; 45: b:=#45#0; 95: b:=#95#0; 43: b:=#43#0; 61: b:=#61#0; 92: b:=#92#0; 47: b:=#47#0; 124: b:=#124#0; 46: b:=#46#0; 44: b:=#44#0; 59: b:=#59#0; 58: b:=#58#0; 123: b:=#123#0; 125: b:=#125#0; 63: b:=#63#0; 60: b:=#60#0; 62: b:=#62#0; 34: b:=#34#0; 91: b:=#91#0; 93: b:=#93#0; 96: b:=#96#0; 126: b:=#126#0; 252: b:=#22#33;
{а русские}             160: b:=#48#4; 161: b:=#49#4; 162: b:=#50#4; 163: b:=#51#4; 164: b:=#52#4; 165: b:=#53#4; 166: b:=#54#4; 167: b:=#55#4; 168: b:=#56#4; 169: b:=#57#4; 170: b:=#58#4; 171: b:=#59#4; 172: b:=#60#4; 173: b:=#61#4; 174: b:=#62#4; 175: b:=#63#4; 224: b:=#64#4; 225: b:=#65#4; 226: b:=#66#4; 227: b:=#67#4; 228: b:=#68#4; 229: b:=#69#4; 230: b:=#70#4; 231: b:=#71#4; 232: b:=#72#4; 233: b:=#73#4; 234: b:=#74#4; 235: b:=#75#4; 236: b:=#76#4; 237: b:=#77#4; 238: b:=#78#4; 239: b:=#79#4; 241: b:=#81#4;
{А русские}             128: b:=#16#4; 129: b:=#17#4; 130: b:=#18#4; 131: b:=#19#4; 132: b:=#20#4; 133: b:=#21#4; 134: b:=#22#4; 135: b:=#23#4; 136: b:=#24#4; 137: b:=#25#4; 138: b:=#26#4; 139: b:=#27#4; 140: b:=#28#4; 141: b:=#29#4; 142: b:=#30#4; 143: b:=#31#4; 144: b:=#32#4; 145: b:=#33#4; 146: b:=#34#4; 147: b:=#35#4; 148: b:=#36#4;  149: b:=#37#4; 150: b:=#38#4; 151: b:=#39#4; 152: b:=#40#4; 153: b:=#41#4; 154: b:=#42#4; 155: b:=#43#4; 156: b:=#44#4; 157: b:=#45#4; 158: b:=#46#4; 159: b:=#47#4; 240: b:=#1#4
                        end;
                OutString:=OutString+b
                end;
        Text:= OutString
        except
        Result:=false
        end
end;

function DosToWin(var Text: string): boolean;
var InString: string;
    b: Char;
    i, Len: integer;
    c: byte;
begin
Result:=true;
InString:=Text;
Len:=Length(InString);
try
        for i:=1 to Len do begin
                b:=InString[i];
                c:=Ord(b);
                case c of
        {a}             160: c:=224; 161: c:=225; 162: c:=226; 163: c:=227; 164: c:=228; 165: c:=229; 166: c:=230; 167: c:=231; 168: c:=232; 169: c:=233; 170: c:=234; 171: c:=235; 172: c:=236; 173: c:=237; 174: c:=238; 175: c:=239; 224: c:=240; 225: c:=241; 226: c:=242; 227: c:=243; 228: c:=244; 229: c:=245; 230: c:=246; 231: c:=247; 232: c:=248; 233: c:=249; 234: c:=250; 235: c:=251; 236: c:=252; 237: c:=253; 238: c:=254; 239: c:=255; 241: c:=184;
        {A}             128: c:=192; 129: c:=193; 130: c:=194; 131: c:=195; 132: c:=196; 133: c:=197; 134: c:=198; 135: c:=199; 136: c:=200; 137: c:=201; 138: c:=202; 139: c:=203; 140: c:=204; 141: c:=205; 142: c:=206; 143: c:=207; 144: c:=208; 145: c:=209; 146: c:=210; 147: c:=211; 148: c:=212; 149: c:=213; 150: c:=214; 151: c:=215; 152: c:=216; 153: c:=217; 154: c:=218; 155: c:=219; 156: c:=220; 157: c:=221; 158: c:=222; 159: c:=223; 240: c:=168; 252: c:=185
                        end;
                b:=Char(c);
                InString[i]:=b
                end;
        Text:=InString
        except
        Result:=false
        end
end;

function IsoToDos(var Text: string): boolean;
var InString: string;
    b: char;
    i, Len: integer;
    c: byte;
begin
Result:=true;
InString:=Text;
Len:=Length(InString);
try
        for i:=1 to Len do begin
                b:=InString[i];
                c:=Ord(b);
                case c of
        {a}             208: c:=160; 209: c:=161; 210: c:=162; 211: c:=163; 212: c:=164; 213: c:=165; 214: c:=166; 215: c:=167; 216: c:=168; 217: c:=169; 218: c:=170; 219: c:=171; 220: c:=172; 221: c:=173; 222: c:=174; 223: c:=175; 224: c:=224; 225: c:=225; 226: c:=226; 227: c:=227; 228: c:=228; 229: c:=229; 230: c:=230; 231: c:=231; 232: c:=232; 233: c:=233; 234: c:=234; 235: c:=235; 236: c:=236; 237: c:=237; 238: c:=238; 239: c:=239; 241: c:=241;
        {A}             176: c:=128; 177: c:=129; 178: c:=130; 179: c:=131; 180: c:=132; 181: c:=133; 182: c:=134; 183: c:=135; 184: c:=136; 185: c:=137; 186: c:=138; 187: c:=139; 188: c:=140; 189: c:=141; 190: c:=142; 191: c:=143; 192: c:=144; 193: c:=145; 194: c:=146; 195: c:=147; 196: c:=148; 197: c:=149; 198: c:=150; 199: c:=151; 200: c:=152; 201: c:=153; 202: c:=154; 203: c:=155; 204: c:=156; 205: c:=157; 206: c:=158; 207: c:=159; 161: c:=240; 240: c:=252
                        end;
                b:=Char(c);
                InString[i]:=b;
                end;
        Text:=InString
        except
        Result:=false
        end
end;

function IsoToKoi(var Text: string): boolean;
var InString: string;
    b: char;
    i, Len: integer;
    c: byte;
begin
Result:=true;
InString:=Text;
Len:=Length(InString);
try
        for i:=1 to Len do begin
                b:=InString[i];
                c:=Ord(b);
                case c of
        {a}             208: c:=193; 209: c:=194; 210: c:=215; 211: c:=199; 212: c:=196; 213: c:=197; 214: c:=214; 215: c:=218; 216: c:=201; 217: c:=202; 218: c:=203; 219: c:=204; 220: c:=205; 221: c:=206; 222: c:=207; 223: c:=208; 224: c:=210; 225: c:=211; 226: c:=212; 227: c:=213; 228: c:=198; 229: c:=200; 230: c:=195; 231: c:=222; 232: c:=219; 233: c:=221; 234: c:=223; 235: c:=217; 236: c:=216; 237: c:=220; 238: c:=192; 239: c:=209; 241: c:=163;
        {A}             176: c:=225; 177: c:=226; 178: c:=247; 179: c:=231; 180: c:=228; 181: c:=229; 182: c:=246; 183: c:=250; 184: c:=233; 185: c:=234; 186: c:=235; 187: c:=236; 188: c:=237; 189: c:=238; 190: c:=239; 191: c:=240; 192: c:=242; 193: c:=243; 194: c:=244; 195: c:=245; 196: c:=230; 197: c:=232; 198: c:=227; 199: c:=254; 200: c:=251; 201: c:=253; 202: c:=255; 203: c:=249; 204: c:=248; 205: c:=252; 206: c:=224; 207: c:=241; 161: c:=179; 240: c:=78
                        end;
                b:=Char(c);
                InString[i]:=b
                end;
        Text:=InString
        except
        Result:=false
        end
end;

function IsoToMac(var Text: string): boolean;
var InString: string;
    b: char;
    i, Len: integer;
    c: byte;
begin
Result:=true;
InString:=Text;
Len:=Length(InString);
try
        for i:=1 to Len do begin
                b:=InString[i];
                c:=Ord(b);
                case c of
        {a}             208: c:=255; 209: c:=240; 210: c:=162; 211: c:=163; 212: c:=164; 213: c:=165; 214: c:=166; 215: c:=167; 216: c:=168; 217: c:=169; 218: c:=170; 219: c:=171; 220: c:=172; 221: c:=173; 222: c:=174; 223: c:=175; 224: c:=224; 225: c:=225; 226: c:=226; 227: c:=227; 228: c:=228; 229: c:=229; 230: c:=230; 231: c:=231; 232: c:=232; 233: c:=233; 234: c:=234; 235: c:=235; 236: c:=236; 237: c:=237; 238: c:=238; 239: c:=239; 241: c:=241;
        {A}             176: c:=128; 177: c:=129; 178: c:=130; 179: c:=131; 180: c:=132; 181: c:=133; 182: c:=134; 183: c:=135; 184: c:=136; 185: c:=137; 186: c:=138; 187: c:=139; 188: c:=140; 189: c:=141; 190: c:=142; 191: c:=143; 192: c:=144; 193: c:=145; 194: c:=146; 195: c:=147; 196: c:=148; 197: c:=149; 198: c:=150; 199: c:=151; 200: c:=152; 201: c:=153; 202: c:=154; 203: c:=155; 204: c:=156; 205: c:=157; 206: c:=158; 207: c:=159; 161: c:=252
                        end;
                b:=Char(c);
                InString[i]:=b
                end;
        Text:=InString
        except
        Result:=false
        end
end;

function IsoToUnicode(var Text: string): boolean;
var InString, OutString, b: string;
    i, Len: integer;
    c: byte;
    a: Char;
begin
Result:=true;
InString:=Text; OutString:='';
Len:=Length(InString);
try
        b:=#255#254; OutString:=OutString+b;
        for i:=1 to Len do begin
                a:=InString[i];
                c:=Ord(a);
                case c of
{a english}             97: b:=#97#0; 98: b:=#98#0; 99: b:=#99#0; 100: b:=#100#0; 101: b:=#101#0; 102: b:=#102#0; 103: b:=#103#0; 104: b:=#104#0; 105: b:=#105#0; 106: b:=#106#0; 107: b:=#107#0; 108: b:=#108#0; 109: b:=#109#0; 110: b:=#110#0; 111: b:=#111#0; 112: b:=#112#0; 113: b:=#113#0; 114: b:=#114#0; 115: b:=#115#0; 116: b:=#116#0; 117: b:=#117#0; 118: b:=#118#0; 119: b:=#119#0; 120: b:=#120#0; 121: b:=#121#0;  122: b:=#122#0;
{A english}             65: b:=#65#0; 66: b:=#66#0; 67: b:=#67#0; 68: b:=#68#0; 69: b:=#67#0; 70: b:=#70#0; 71: b:=#71#0; 72: b:=#72#0; 73: b:=#73#0; 74: b:=#74#0; 75: b:=#75#0; 76: b:=#76#0; 77: b:=#77#0; 78: b:=#78#0; 79: b:=#79#0; 80: b:=#80#0; 81: b:=#81#0; 82: b:=#82#0; 83: b:=#83#0; 84: b:=#84#0; 85: b:=#85#0; 86: b:=#86#0; 87: b:=#87#0; 88: b:=#88#0; 89: b:=#89#0; 90: b:=#90#0;
{0..9}                  48: b:=#48#0; 49: b:=#49#0; 50: b:=#50#0; 51: b:=#51#0; 52: b:=#52#0; 53: b:=#53#0; 54: b:=#54#0; 55: b:=#55#0; 56: b:=#56#0; 57: b:=#57#0;
{Спец символы}          33: b:=#33#0; 13: b:=#13#0; 9: b:=#9#0; 10: b:=#10#0; 32: b:=#32#0; 64: b:=#64#0; 35: b:=#35#0; 36: b:=#36#0; 37: b:=#37#0; 94: b:=#94#0; 38: b:=#38#0; 42: b:=#42#0; 40: b:=#40#0; 41: b:=#41#0; 45: b:=#45#0; 95: b:=#95#0; 43: b:=#43#0; 61: b:=#61#0; 92: b:=#92#0; 47: b:=#47#0; 124: b:=#124#0; 46: b:=#46#0; 44: b:=#44#0; 59: b:=#59#0; 58: b:=#58#0; 123: b:=#123#0; 125: b:=#125#0; 63: b:=#63#0; 60: b:=#60#0; 62: b:=#62#0; 34: b:=#34#0; 91: b:=#91#0; 93: b:=#93#0; 96: b:=#96#0; 126: b:=#126#0; 240: b:=#22#33;
{а русские}             208: b:=#48#4; 209: b:=#49#4; 210: b:=#50#4; 211: b:=#51#4; 212: b:=#52#4; 213: b:=#53#4; 214: b:=#54#4; 215: b:=#55#4; 216: b:=#56#4; 217: b:=#57#4; 218: b:=#58#4; 219: b:=#59#4; 220: b:=#60#4; 221: b:=#61#4; 222: b:=#62#4; 223: b:=#63#4; 224: b:=#64#4; 225: b:=#65#4; 226: b:=#66#4; 227: b:=#67#4; 228: b:=#68#4; 229: b:=#69#4; 230: b:=#70#4; 231: b:=#71#4; 232: b:=#72#4; 233: b:=#73#4; 234: b:=#74#4; 235: b:=#75#4; 236: b:=#76#4; 237: b:=#77#4; 238: b:=#78#4; 239: b:=#79#4; 241: b:=#81#4;
{А русские}             176: b:=#16#4; 177: b:=#17#4; 178: b:=#18#4; 179: b:=#19#4; 180: b:=#20#4; 181: b:=#21#4; 182: b:=#22#4; 183: b:=#23#4; 184: b:=#24#4; 185: b:=#25#4; 186: b:=#26#4; 187: b:=#27#4; 188: b:=#28#4; 189: b:=#29#4; 190: b:=#30#4; 191: b:=#31#4; 192: b:=#32#4; 193: b:=#33#4; 194: b:=#34#4; 195: b:=#35#4; 196: b:=#36#4; 197: b:=#37#4; 198: b:=#38#4; 199: b:=#39#4; 200: b:=#40#4; 201: b:=#41#4; 202: b:=#42#4; 203: b:=#43#4; 204: b:=#44#4; 205: b:=#45#4; 206: b:=#46#4; 207: b:=#47#4; 161: b:=#1#4
                        end;
                OutString:=OutString+b
                end;
        Text:= OutString
        except
        Result:=false
        end
end;

function IsoToWin(var Text: string): boolean;
var InString: string;
    b: char;
    i, Len: integer;
    c: byte;
begin
Result:=true;
InString:=Text;
Len:=Length(InString);
try
        for i:=1 to Len do begin
                b:=InString[i];
                c:=Ord(b);
                case c of
        {a}             208: c:=224; 209: c:=225; 210: c:=226; 211: c:=227; 212: c:=228; 213: c:=229; 214: c:=230; 215: c:=231; 216: c:=232; 217: c:=233; 218: c:=234; 219: c:=235; 220: c:=236; 221: c:=237; 222: c:=238; 223: c:=239; 224: c:=240; 225: c:=241; 226: c:=242; 227: c:=243; 228: c:=244; 229: c:=245; 230: c:=246; 231: c:=247; 232: c:=248; 233: c:=249; 234: c:=250; 235: c:=251; 236: c:=252; 237: c:=253; 238: c:=254; 239: c:=255; 241: c:=184;
        {A}             176: c:=192; 177: c:=193; 178: c:=194; 179: c:=195; 180: c:=196; 181: c:=197; 182: c:=198; 183: c:=199; 184: c:=200; 185: c:=201; 186: c:=202; 187: c:=203; 188: c:=204; 189: c:=205; 190: c:=206; 191: c:=207; 192: c:=208; 193: c:=209; 194: c:=210; 195: c:=211; 196: c:=212; 197: c:=213; 198: c:=214; 199: c:=215; 200: c:=216; 201: c:=217; 202: c:=218; 203: c:=219; 204: c:=220; 205: c:=221; 206: c:=222; 207: c:=223; 161: c:=168; 240: c:=185
                        end;
                b:=Char(c);
                InString[i]:=b
                end;
        Text:=InString
        except
        Result:=false
        end
end;

function KoiToDos(var Text: string): boolean;
var InString: string;
    b: char;
    i, Len: integer;
    c: byte;
begin
Result:=true;
InString:=Text;
Len:=Length(InString);
try
        for i:=1 to Len do begin
                b:=InString[i];
                c:=Ord(b);
                case c of
        {a}             193: c:=160; 194: c:=161; 215: c:=162; 199: c:=163; 196: c:=164; 197: c:=165; 214: c:=166; 218: c:=167; 201: c:=168; 202: c:=169; 203: c:=170; 204: c:=171; 205: c:=172; 206: c:=173; 207: c:=174; 208: c:=175; 210: c:=224; 211: c:=225; 212: c:=226; 213: c:=227; 198: c:=228; 200: c:=229; 195: c:=230; 222: c:=231; 219: c:=232; 221: c:=233; 223: c:=234; 217: c:=235; 216: c:=236; 220: c:=237; 192: c:=238; 209: c:=239; 163: c:=241;
        {A}             225: c:=128; 226: c:=129; 247: c:=130; 231: c:=131; 228: c:=132; 229: c:=133; 246: c:=134; 250: c:=135; 233: c:=136; 234: c:=137; 235: c:=138; 236: c:=139; 237: c:=140; 238: c:=141; 239: c:=142; 240: c:=143; 242: c:=144; 243: c:=145; 244: c:=146; 245: c:=147; 230: c:=148; 232: c:=149; 227: c:=150; 254: c:=151; 251: c:=152; 253: c:=153; 255: c:=154; 249: c:=155; 248: c:=156; 252: c:=157; 224: c:=158; 241: c:=159; 179: c:=240; 78: c:=252
                        end;
                b:=Char(c);
                InString[i]:=b
                end;
        Text:=InString
        except
        Result:=false
        end
end;

function KoiToIso(var Text: string): boolean;
var InString: string;
    b: char;
    i, Len: integer;
    c: byte;
begin
Result:=true;
InString:=Text;
Len:=Length(InString);
try
        for i:=1 to Len do begin
                b:=InString[i];
                c:=Ord(b);
                case c of
        {a}             193: c:=208; 194: c:=209; 215: c:=210; 199: c:=211; 196: c:=212; 197: c:=213; 214: c:=214; 218: c:=215; 201: c:=216; 202: c:=217; 203: c:=218; 204: c:=219; 205: c:=220; 206: c:=221; 207: c:=222; 208: c:=223; 210: c:=224; 211: c:=225; 212: c:=226; 213: c:=227; 198: c:=228; 200: c:=229; 195: c:=230; 222: c:=231; 219: c:=232; 221: c:=233; 223: c:=234; 217: c:=235; 216: c:=236; 220: c:=237; 192: c:=238; 209: c:=239; 163: c:=241;
        {A}             225: c:=176; 226: c:=177; 247: c:=178; 231: c:=179; 228: c:=180; 229: c:=181; 246: c:=182; 250: c:=183; 233: c:=184; 234: c:=185; 235: c:=186; 236: c:=187; 237: c:=188; 238: c:=189; 239: c:=190; 240: c:=191; 242: c:=192; 243: c:=193; 244: c:=194; 245: c:=195; 230: c:=196; 232: c:=197; 227: c:=198; 254: c:=199; 251: c:=200; 253: c:=201; 255: c:=202; 249: c:=203; 248: c:=204; 252: c:=205; 224: c:=206; 241: c:=207; 179: c:=161; 78: c:=240
                        end;
                b:=Char(c);
                InString[i]:=b
                end;
        Text:=InString
        except
        Result:=false
        end
end;

function KoiToMac(var Text: string): boolean;
var InString: string;
    b: char;
    i, Len: integer;
    c: byte;
begin
Result:=true;
InString:=Text;
Len:=Length(InString);
try
        for i:=1 to Len do begin
                b:=InString[i];
                c:=Ord(b);
                case c of
        {a}             193: c:=255; 194: c:=240; 215: c:=162; 199: c:=163; 196: c:=164; 197: c:=165; 214: c:=166; 218: c:=167; 201: c:=168; 202: c:=169; 203: c:=170; 204: c:=171; 205: c:=172; 206: c:=173; 207: c:=174; 208: c:=175; 210: c:=224; 211: c:=225; 212: c:=226; 213: c:=227; 198: c:=228; 200: c:=229; 195: c:=230; 222: c:=231; 219: c:=232; 221: c:=233; 223: c:=234; 217: c:=235; 216: c:=236; 220: c:=237; 192: c:=238; 209: c:=239; 163: c:=241;
        {A}             225: c:=128; 226: c:=129; 247: c:=130; 231: c:=131; 228: c:=132; 229: c:=133; 246: c:=134; 250: c:=135; 233: c:=136; 234: c:=137; 235: c:=138; 236: c:=139; 237: c:=140; 238: c:=141; 239: c:=142; 240: c:=143; 242: c:=144; 243: c:=145; 244: c:=146; 245: c:=147; 230: c:=148; 232: c:=149; 227: c:=150; 254: c:=151; 251: c:=152; 253: c:=153; 255: c:=154; 249: c:=155; 248: c:=156; 252: c:=157; 224: c:=158; 241: c:=159; 179: c:=252
                        end;
                b:=Char(c);
                InString[i]:=b
                end;
        Text:=InString
        except
        Result:=false
        end
end;

function KoiToUnicode(var Text: string): boolean;
var InString, OutString, b: string;
    i, Len: integer;
    c: byte;
    a: Char;
begin
Result:=true;
InString:=Text; OutString:='';
Len:=Length(InString);
try
        b:=#255#254; OutString:=OutString+b;
        for i:=1 to Len do begin
                a:=InString[i];
                c:=Ord(a);
                case c of
{a english}             97: b:=#97#0; 98: b:=#98#0; 99: b:=#99#0; 100: b:=#100#0; 101: b:=#101#0; 102: b:=#102#0; 103: b:=#103#0; 104: b:=#104#0; 105: b:=#105#0; 106: b:=#106#0; 107: b:=#107#0; 108: b:=#108#0; 109: b:=#109#0; 110: b:=#110#0; 111: b:=#111#0; 112: b:=#112#0; 113: b:=#113#0; 114: b:=#114#0; 115: b:=#115#0; 116: b:=#116#0; 117: b:=#117#0; 118: b:=#118#0; 119: b:=#119#0; 120: b:=#120#0; 121: b:=#121#0; 122: b:=#122#0;
{A english}             65: b:=#65#0; 66: b:=#66#0; 67: b:=#67#0; 68: b:=#68#0; 69: b:=#69#0; 70: b:=#70#0; 71: b:=#71#0; 72: b:=#72#0; 73: b:=#73#0; 74: b:=#74#0; 75: b:=#75#0; 76: b:=#76#0; 77: b:=#77#0; 78: b:=#78#0; 79: b:=#79#0; 80: b:=#80#0; 81: b:=#81#0; 82: b:=#82#0; 83: b:=#83#0; 84: b:=#84#0; 85: b:=#85#0; 86: b:=#86#0; 87: b:=#87#0; 88: b:=#88#0; 89: b:=#89#0; 90: b:=#90#0;
{0..9}                  48: b:=#48#0; 49: b:=#49#0; 50: b:=#50#0; 51: b:=#51#0; 52: b:=#52#0; 53: b:=#53#0; 54: b:=#54#0; 55: b:=#55#0; 56: b:=#56#0; 57: b:=#57#0;
{Спец символы}          33: b:=#33#0; 13: b:=#13#0; 9: b:=#9#0; 10: b:=#10#0; 32: b:=#32#0; 64: b:=#64#0; 35: b:=#35#0; 36: b:=#36#0; 37: b:=#37#0; 94: b:=#94#0; 38: b:=#38#0; 42: b:=#42#0; 40: b:=#40#0; 41: b:=#41#0; 45: b:=#45#0; 95: b:=#95#0; 43: b:=#43#0; 61: b:=#61#0; 92: b:=#92#0; 47: b:=#47#0; 124: b:=#124#0; 46: b:=#46#0; 44: b:=#44#0; 59: b:=#59#0; 58: b:=#58#0; 123: b:=#123#0; 125: b:=#125#0; 63: b:=#63#0; 60: b:=#60#0; 62: b:=#62#0; 34: b:=#34#0; 91: b:=#91#0; 93: b:=#93#0; 96: b:=#96#0; 126: b:=#126#0;
{а русские}             193: b:=#48#4; 194: b:=#49#4; 215: b:=#50#4; 199: b:=#51#4; 196: b:=#52#4; 197: b:=#53#4; 214: b:=#54#4; 218: b:=#55#4; 201: b:=#56#4; 202: b:=#57#4; 203: b:=#58#4; 204: b:=#59#4; 205: b:=#60#4; 206: b:=#61#4; 207: b:=#62#4; 208: b:=#63#4; 210: b:=#64#4; 211: b:=#65#4; 212: b:=#66#4; 213: b:=#67#4; 198: b:=#68#4; 200: b:=#69#4; 195: b:=#70#4; 222: b:=#71#4; 219: b:=#72#4; 221: b:=#73#4; 223: b:=#74#4; 217: b:=#75#4; 216: b:=#76#4; 220: b:=#77#4; 192: b:=#78#4; 209: b:=#79#4; 163: b:=#81#4;
{А русские}             225: b:=#16#4; 226: b:=#17#4; 247: b:=#18#4; 231: b:=#19#4; 228: b:=#20#4; 229: b:=#21#4; 246: b:=#22#4; 250: b:=#23#4; 233: b:=#24#4; 234: b:=#25#4; 235: b:=#26#4; 236: b:=#27#4; 237: b:=#28#4; 238: b:=#29#4; 239: b:=#30#4; 240: b:=#31#4; 242: b:=#32#4; 243: b:=#33#4; 244: b:=#34#4; 245: b:=#35#4; 230: b:=#36#4; 232: b:=#37#4; 227: b:=#38#4; 254: b:=#39#4; 251: b:=#40#4; 253: b:=#41#4; 255: b:=#42#4; 249: b:=#43#4; 248: b:=#44#4; 252: b:=#45#4; 224: b:=#46#4; 241: b:=#47#4; 179: b:=#1#4
                        end;
                OutString:=OutString+b
                end;
        Text:= OutString
        except
        Result:=false
        end
end;

function KoiToWin(var Text: string): boolean;
var InString: string;
    b: char;
    i, Len: integer;
    c: byte;
begin
Result:=true;
InString:=Text;
Len:=Length(InString);
try
        for i:=1 to Len do begin
                b:=InString[i];
                c:=Ord(b);
                case c of
        {a}             193: c:=224; 194: c:=225; 215: c:=226; 199: c:=227; 196: c:=228; 197: c:=229; 214: c:=230; 218: c:=231; 201: c:=232; 202: c:=233; 203: c:=234; 204: c:=235; 205: c:=236; 206: c:=237; 207: c:=238; 208: c:=239; 210: c:=240; 211: c:=241; 212: c:=242; 213: c:=243; 198: c:=244; 200: c:=245; 195: c:=246; 222: c:=247; 219: c:=248; 221: c:=249; 223: c:=250; 217: c:=251; 216: c:=252; 220: c:=253; 192: c:=254; 209: c:=255; 163: c:=184;
        {A}             225: c:=192; 226: c:=193; 247: c:=194; 231: c:=195; 228: c:=196; 229: c:=197; 246: c:=198; 250: c:=199; 233: c:=200; 234: c:=201; 235: c:=202; 236: c:=203; 237: c:=204; 238: c:=205; 239: c:=206; 240: c:=207; 242: c:=208; 243: c:=209; 244: c:=210; 245: c:=211; 230: c:=212; 232: c:=213; 227: c:=214; 254: c:=215; 251: c:=216; 253: c:=217; 255: c:=218; 249: c:=219; 248: c:=220; 252: c:=221; 224: c:=222; 241: c:=223; 179: c:=168
                        end;
                b:=Char(c);
                InString[i]:=b
                end;
        Text:=InString
        except
        Result:=false
        end
end;

function MacToDos(var Text: string): boolean;
var InString: string;
    b: char;
    i, Len: integer;
    c: byte;
begin
Result:=true;
InString:=Text;
Len:=Length(InString);
try
        for i:=1 to Len do begin
                b:=InString[i];
                c:=Ord(b);
                case c of
        {a}             255: c:=160; 240: c:=161; 252: c:=240
                        end;
                b:=Char(c);
                InString[i]:=b
                end;
        Text:=InString
        except
        Result:=false
        end
end;

function MacToIso(var Text: string): boolean;
var InString: string;
    b: char;
    i, Len: integer;
    c: byte;
begin
Result:=true;
InString:=Text;
Len:=Length(InString);
try
        for i:=1 to Len do begin
                b:=InString[i];
                c:=Ord(b);
                case c of
        {a}             255: c:=208; 240: c:=209; 162: c:=210; 163: c:=211; 164: c:=212; 165: c:=213; 166: c:=214; 167: c:=215; 168: c:=216; 169: c:=217; 170: c:=218; 171: c:=219; 172: c:=220; 173: c:=221; 174: c:=222; 175: c:=223; 224: c:=224; 225: c:=225; 226: c:=226; 227: c:=227; 228: c:=228; 229: c:=229; 230: c:=230; 231: c:=231; 232: c:=232; 233: c:=233; 234: c:=234; 235: c:=235; 236: c:=236; 237: c:=237; 238: c:=238; 239: c:=239; 241: c:=241;
        {A}             128: c:=176; 129: c:=177; 130: c:=178; 131: c:=179; 132: c:=180; 133: c:=181; 134: c:=182; 135: c:=183; 136: c:=184; 137: c:=185; 138: c:=186; 139: c:=187; 140: c:=188; 141: c:=189; 142: c:=190; 143: c:=191; 144: c:=192; 145: c:=193; 146: c:=194; 147: c:=195; 148: c:=196; 149: c:=197; 150: c:=198; 151: c:=199; 152: c:=200; 153: c:=201; 154: c:=202; 155: c:=203; 156: c:=204; 157: c:=205; 158: c:=206; 159: c:=207; 252: c:=161
                        end;
                b:=Char(c);
                InString[i]:=b
                end;
        Text:=InString
        except
        Result:=false
        end
end;

function MacToKoi(var Text: string): boolean;
var InString: string;
    b: char;
    i, Len: integer;
    c: byte;
begin
Result:=true;
InString:=Text;
Len:=Length(InString);
try
        for i:=1 to Len do begin
                b:=InString[i];
                c:=Ord(b);
                case c of
        {a}             255: c:=193; 240: c:=194; 162: c:=215; 163: c:=199; 164: c:=196; 165: c:=197; 166: c:=214; 167: c:=218; 168: c:=201; 169: c:=202; 170: c:=203; 171: c:=204; 172: c:=205; 173: c:=206; 174: c:=207; 175: c:=208; 224: c:=210; 225: c:=211; 226: c:=212; 227: c:=213; 228: c:=198; 229: c:=200; 230: c:=195; 231: c:=222; 232: c:=219; 233: c:=221; 234: c:=223; 235: c:=217; 236: c:=216; 237: c:=220; 238: c:=192; 239: c:=209; 241: c:=163;
        {A}             128: c:=225; 129: c:=226; 130: c:=247; 131: c:=231; 132: c:=228; 133: c:=229; 134: c:=246; 135: c:=250; 136: c:=233; 137: c:=234; 138: c:=235; 139: c:=236; 140: c:=237; 141: c:=238; 142: c:=239; 143: c:=240; 144: c:=242; 145: c:=243; 146: c:=244; 147: c:=245; 148: c:=230; 149: c:=232; 150: c:=227; 151: c:=254; 152: c:=251; 153: c:=253; 154: c:=255; 155: c:=249; 156: c:=248; 157: c:=252; 158: c:=224; 159: c:=241; 252: c:=179
                        end;
                b:=Char(c);
                InString[i]:=b
                end;
        Text:=InString
        except
        Result:=false
        end
end;

function MacToUnicode(var Text: string): boolean;
var InString, OutString, b: string;
    i, Len: integer;
    c: byte;
    a: Char;
begin
Result:=true;
InString:=Text; OutString:='';
Len:=Length(InString);
try
        b:=#255#254; OutString:=OutString+b;
        for i:=1 to Len do begin
                a:=InString[i];
                c:=Ord(a);
                case c of
{a english}     	97: b:=#97#0; 98: b:=#98#0; 99: b:=#99#0; 100: b:=#100#0; 101: b:=#101#0; 102: b:=#102#0; 103: b:=#103#0; 104: b:=#104#0; 105: b:=#105#0; 106: b:=#106#0; 107: b:=#107#0; 108: b:=#108#0; 109: b:=#109#0; 110: b:=#110#0; 111: b:=#111#0; 112: b:=#112#0; 113: b:=#113#0; 114: b:=#114#0; 115: b:=#115#0; 116: b:=#116#0; 117: b:=#117#0; 118: b:=#118#0; 119: b:=#119#0; 120: b:=#120#0; 121: b:=#121#0; 122: b:=#122#0;
{A english}     	65: b:=#65#0; 66: b:=#66#0; 67: b:=#67#0; 68: b:=#68#0; 69: b:=#69#0; 70: b:=#70#0; 71: b:=#71#0; 72: b:=#72#0; 73: b:=#73#0; 74: b:=#74#0; 75: b:=#75#0; 76: b:=#76#0; 77: b:=#77#0; 78: b:=#78#0; 79: b:=#79#0; 80: b:=#80#0; 81: b:=#81#0; 82: b:=#82#0; 83: b:=#83#0; 84: b:=#84#0; 85: b:=#85#0; 86: b:=#86#0; 87: b:=#87#0; 88: b:=#88#0; 89: b:=#89#0; 90: b:=#90#0;
{0..9}          	48: b:=#48#0; 49: b:=#49#0; 50: b:=#50#0; 51: b:=#51#0; 52: b:=#52#0; 53: b:=#53#0; 54: b:=#54#0; 55: b:=#55#0; 56: b:=#56#0; 57: b:=#57#0;
{Спец символы}  	33: b:=#33#0; 13: b:=#13#0; 9: b:=#9#0; 10: b:=#10#0; 32: b:=#32#0; 64: b:=#64#0; 35: b:=#35#0; 36: b:=#36#0; 37: b:=#37#0; 94: b:=#94#0; 38: b:=#38#0; 42: b:=#42#0; 40: b:=#40#0; 41: b:=#41#0; 45: b:=#45#0; 95: b:=#95#0; 43: b:=#43#0; 61: b:=#61#0; 92: b:=#92#0; 47: b:=#47#0; 124: b:=#124#0; 46: b:=#46#0; 44: b:=#44#0; 59: b:=#59#0; 58: b:=#58#0; 123: b:=#123#0; 125: b:=#125#0; 63: b:=#63#0; 60: b:=#60#0; 62: b:=#62#0; 34: b:=#34#0; 91: b:=#91#0; 93: b:=#93#0; 96: b:=#96#0; 126: b:=#126#0;
{а русские}     	255: b:=#48#4; 240: b:=#49#4; 162: b:=#50#4; 163: b:=#51#4; 164: b:=#52#4; 165: b:=#53#4; 166: b:=#54#4; 167: b:=#55#4; 168: b:=#56#4; 169: b:=#57#4; 170: b:=#58#4; 171: b:=#59#4; 172: b:=#60#4; 173: b:=#61#4; 174: b:=#62#4; 175: b:=#63#4; 224: b:=#64#4; 225: b:=#65#4; 226: b:=#66#4; 227: b:=#67#4; 228: b:=#68#4; 229: b:=#69#4; 230: b:=#70#4; 231: b:=#71#4; 232: b:=#72#4; 233: b:=#73#4; 234: b:=#74#4; 235: b:=#75#4; 236: b:=#76#4; 237: b:=#77#4; 238: b:=#78#4; 239: b:=#79#4; 241: b:=#81#4;
{А русские}     	128: b:=#16#4; 129: b:=#17#4; 130: b:=#18#4; 131: b:=#19#4; 132: b:=#20#4; 133: b:=#21#4; 134: b:=#22#4; 135: b:=#23#4; 136: b:=#24#4; 137: b:=#25#4; 138: b:=#26#4; 139: b:=#27#4; 140: b:=#28#4; 141: b:=#29#4; 142: b:=#30#4; 143: b:=#31#4; 144: b:=#32#4; 145: b:=#33#4; 146: b:=#34#4; 147: b:=#35#4; 148: b:=#36#4; 149: b:=#37#4; 150: b:=#38#4; 151: b:=#39#4; 152: b:=#40#4; 153: b:=#41#4; 154: b:=#42#4; 155: b:=#43#4; 156: b:=#44#4; 157: b:=#45#4; 158: b:=#46#4; 159: b:=#47#4; 252: b:=#1#4
                	end;
                OutString:=OutString+b
                end;
        Text:= OutString
        except
        Result:=false
        end
end;

function MacToWin(var Text: string): boolean;
var InString: string;
    b: char;
    i, Len: integer;
    c: byte;
begin
Result:=true;
InString:=Text;
Len:=Length(InString);
try
        for i:=1 to Len do begin
                b:=InString[i];
                c:=Ord(b);
                case c of
        {a}       255: c:=224; 240: c:=225; 162: c:=226; 163: c:=227; 164: c:=228; 165: c:=229; 166: c:=230; 167: c:=231; 168: c:=232; 169: c:=233; 170: c:=234; 171: c:=235; 172: c:=236; 173: c:=237; 174: c:=238; 175: c:=239; 224: c:=240; 225: c:=241; 226: c:=242; 227: c:=243; 228: c:=244; 229: c:=245; 230: c:=246; 231: c:=247; 232: c:=248; 233: c:=249; 234: c:=250; 235: c:=251; 236: c:=252; 237: c:=253; 238: c:=254; 239: c:=255; 241: c:=184;
        {A}       128: c:=192; 129: c:=193; 130: c:=194; 131: c:=195; 132: c:=196; 133: c:=197; 134: c:=198; 135: c:=199; 136: c:=200; 137: c:=201; 138: c:=202; 139: c:=203; 140: c:=204; 141: c:=205; 142: c:=206; 143: c:=207; 144: c:=208; 145: c:=209; 146: c:=210; 147: c:=211; 148: c:=212; 149: c:=213; 150: c:=214; 151: c:=215; 152: c:=216; 153: c:=217; 154: c:=218; 155: c:=219; 156: c:=220; 157: c:=221; 158: c:=222; 159: c:=223; 252: c:=168
                  end;
                b:=Char(c);
                InString[i]:=b
                end;
        Text:=InString
        except
        Result:=false
        end
end;

function UnicodeToDos(var Text: string): boolean;
var InString, OutString: string;
    i, Len: integer;
    b: Char;
begin
Result:=true; i:=1;
InString:=Text; OutString:='';
Delete(InString, 1, 2);
Len:=Length(InString);
try
	repeat
  	case InString[i+1] of
  		#0: case InString[i] of
{a english}     #97: b:=#97; #98: b:=#98; #99: b:=#99; #100: b:=#100; #101: b:=#101; #102: b:=#102; #103: b:=#103; #104: b:=#104; #105: b:=#105; #106: b:=#106; #107: b:=#107; #108: b:=#108; #109: b:=#109; #110: b:=#110; #111: b:=#111; #112: b:=#112; #113: b:=#113; #114: b:=#114; #115: b:=#115; #116: b:=#116; #117: b:=#117; #118: b:=#118; #119: b:=#119; #120: b:=#120; #121: b:=#121; #122: b:=#122;
{A english}     #65: b:=#65; #66: b:=#66; #67: b:=#67; #68: b:=#68; #69: b:=#67; #70: b:=#70; #71: b:=#71; #72: b:=#72; #73: b:=#73; #74: b:=#74; #75: b:=#75; #76: b:=#76; #77: b:=#77; #78: b:=#78; #79: b:=#79; #80: b:=#80; #81: b:=#81; #82: b:=#82; #83: b:=#83; #84: b:=#84; #85: b:=#85; #86: b:=#86; #87: b:=#87; #88: b:=#88; #89: b:=#89; #90: b:=#90;
{0..9}          #48: b:=#48; #49: b:=#49; #50: b:=#50; #51: b:=#51; #52: b:=#52; #53: b:=#53; #54: b:=#54; #55: b:=#55; #56: b:=#56; #57: b:=#57;
{Спец символы}  #33: b:=#33; #13: b:=#13; #9: b:=#9; #10: b:=#10; #32: b:=#32; #64: b:=#64; #35: b:=#35; #36: b:=#36; #37: b:=#37; #94: b:=#94; #38: b:=#38; #42: b:=#42; #40: b:=#40; #41: b:=#41; #45: b:=#45; #95: b:=#95; #43: b:=#43; #61: b:=#61; #92: b:=#92; #47: b:=#47; #124: b:=#124; #46: b:=#46; #44: b:=#44; #59: b:=#59; #58: b:=#58; #123: b:=#123; #125: b:=#125; #63: b:=#63; #60: b:=#60; #62: b:=#62; #34: b:=#34; #91: b:=#91; #93: b:=#93; #96: b:=#96; #126: b:=#126
			    			end;
    	#4: case InString[i] of
{а русские}     #48: b:=#160; #49: b:=#161; #50: b:=#162; #51: b:=#163; #52: b:=#164; #53: b:=#165; #54: b:=#166; #55: b:=#167; #56: b:=#168; #57: b:=#169; #58: b:=#170; #59: b:=#171; #60: b:=#172; #61: b:=#173; #62: b:=#174; #63: b:=#175; #64: b:=#224; #65: b:=#225; #66: b:=#226; #67: b:=#227; #68: b:=#228; #69: b:=#229; #70: b:=#230; #71: b:=#231; #72: b:=#232; #73: b:=#233; #74: b:=#234; #75: b:=#235; #76: b:=#236; #77: b:=#237; #78: b:=#238; #79: b:=#239; #81: b:=#241;
{А русские}     #16: b:=#128; #17: b:=#129; #18: b:=#130; #19: b:=#131; #20: b:=#132; #21: b:=#133; #22: b:=#134; #23: b:=#135; #24: b:=#136; #25: b:=#137; #26: b:=#138; #27: b:=#139; #28: b:=#140; #29: b:=#141; #30: b:=#142; #31: b:=#143; #32: b:=#144; #33: b:=#145; #34: b:=#146; #35: b:=#147; #36: b:=#148; #37: b:=#149; #38: b:=#150; #39: b:=#151; #40: b:=#152; #41: b:=#153; #42: b:=#154; #43: b:=#155; #44: b:=#156; #45: b:=#157; #46: b:=#158; #47: b:=#159; #1: b:=#240
			    			end
			else if (InString[i]=#84) and (InString[i+1]=#70) then b:=#252
    	end;
		OutString:=OutString+b;
  	i:=i+2
	until i>Len;
  Text:=OutString
  except
  Result:=false
  end
end;

function UnicodeToIso(var Text: string): boolean;
var InString, OutString: string;
    i, Len: integer;
    b: Char;
begin
Result:=true; i:=1;
InString:=Text; OutString:='';
Delete(InString, 1, 2);
Len:=Length(InString);
try
	repeat
  	case InString[i+1] of
  		#0: case InString[i] of
{a english}     #97: b:=#97; #98: b:=#98; #99: b:=#99; #100: b:=#100; #101: b:=#101; #102: b:=#102; #103: b:=#103; #104: b:=#104; #105: b:=#105; #106: b:=#106; #107: b:=#107; #108: b:=#108; #109: b:=#109; #110: b:=#110; #111: b:=#111; #112: b:=#112; #113: b:=#113; #114: b:=#114; #115: b:=#115; #116: b:=#116; #117: b:=#117; #118: b:=#118; #119: b:=#119; #120: b:=#120; #121: b:=#121; #122: b:=#122;
{A english}     #65: b:=#65; #66: b:=#66; #67: b:=#67; #68: b:=#68; #69: b:=#67; #70: b:=#70; #71: b:=#71; #72: b:=#72; #73: b:=#73; #74: b:=#74; #75: b:=#75; #76: b:=#76; #77: b:=#77; #78: b:=#78; #79: b:=#79; #80: b:=#80; #81: b:=#81; #82: b:=#82; #83: b:=#83; #84: b:=#84; #85: b:=#85; #86: b:=#86; #87: b:=#87; #88: b:=#88; #89: b:=#89; #90: b:=#90;
{0..9}          #48: b:=#48; #49: b:=#49; #50: b:=#50; #51: b:=#51; #52: b:=#52; #53: b:=#53; #54: b:=#54; #55: b:=#55; #56: b:=#56; #57: b:=#57;
{Спец символы}  #33: b:=#33; #13: b:=#13; #9: b:=#9; #10: b:=#10; #32: b:=#32; #64: b:=#64; #35: b:=#35; #36: b:=#36; #37: b:=#37; #94: b:=#94; #38: b:=#38; #42: b:=#42; #40: b:=#40; #41: b:=#41; #45: b:=#45; #95: b:=#95; #43: b:=#43; #61: b:=#61; #92: b:=#92; #47: b:=#47; #124: b:=#124; #46: b:=#46; #44: b:=#44; #59: b:=#59; #58: b:=#58; #123: b:=#123; #125: b:=#125; #63: b:=#63; #60: b:=#60; #62: b:=#62; #34: b:=#34; #91: b:=#91; #93: b:=#93; #96: b:=#96; #126: b:=#126
                end;
    	#4: case InString[i] of
{а русские}     #48: b:=#208; #49: b:=#209; #50: b:=#210; #51: b:=#211; #52: b:=#212; #53: b:=#213; #54: b:=#214; #55: b:=#215; #56: b:=#216; #57: b:=#217; #58: b:=#218; #59: b:=#219; #60: b:=#220; #61: b:=#221; #62: b:=#222; #63: b:=#223; #64: b:=#224; #65: b:=#225; #66: b:=#226; #67: b:=#227; #68: b:=#228; #69: b:=#229; #70: b:=#230; #71: b:=#231; #72: b:=#232; #73: b:=#233; #74: b:=#234; #75: b:=#235; #76: b:=#236; #77: b:=#237; #78: b:=#238; #79: b:=#239; #81: b:=#241;
{А русские}     #16: b:=#176; #17: b:=#177; #18: b:=#178; #19: b:=#179; #20: b:=#180; #21: b:=#181; #22: b:=#182; #23: b:=#183; #24: b:=#184; #25: b:=#185; #26: b:=#186; #27: b:=#187; #28: b:=#188; #29: b:=#189; #30: b:=#190; #31: b:=#191; #32: b:=#192; #33: b:=#193; #34: b:=#194; #35: b:=#195; #36: b:=#196; #37: b:=#197; #38: b:=#198; #39: b:=#199; #40: b:=#200; #41: b:=#201; #42: b:=#202; #43: b:=#203; #44: b:=#204; #45: b:=#205; #46: b:=#206; #47: b:=#207; #1: b:=#161
                end
                else if (InString[i]=#84) and (InString[i+1]=#70) then b:=#240
    	end;
		OutString:=OutString+b;
  	i:=i+2
	until i>Len;
  Text:=OutString
  except
  Result:=false
  end
end;

function UnicodeToKoi(var Text: string): boolean;
var InString, OutString: string;
    i, Len: integer;
    b: Char;
begin
Result:=true; i:=1;
InString:=Text; OutString:='';
Delete(InString, 1, 2);
Len:=Length(InString);
try
	repeat
  	case InString[i+1] of
  		#0: case InString[i] of
{a english}     #97: b:=#97; #98: b:=#98; #99: b:=#99; #100: b:=#100; #101: b:=#101; #102: b:=#102; #103: b:=#103; #104: b:=#104; #105: b:=#105; #106: b:=#106; #107: b:=#107; #108: b:=#108; #109: b:=#109; #110: b:=#110; #111: b:=#111; #112: b:=#112; #113: b:=#113; #114: b:=#114; #115: b:=#115; #116: b:=#116; #117: b:=#117; #118: b:=#118; #119: b:=#119; #120: b:=#120; #121: b:=#121; #122: b:=#122;
{A english}     #65: b:=#65; #66: b:=#66; #67: b:=#67; #68: b:=#68; #69: b:=#67; #70: b:=#70; #71: b:=#71; #72: b:=#72; #73: b:=#73; #74: b:=#74; #75: b:=#75; #76: b:=#76; #77: b:=#77; #78: b:=#78; #79: b:=#79; #80: b:=#80; #81: b:=#81; #82: b:=#82; #83: b:=#83; #84: b:=#84; #85: b:=#85; #86: b:=#86; #87: b:=#87; #88: b:=#88; #89: b:=#89; #90: b:=#90;
{0..9}          #48: b:=#48; #49: b:=#49; #50: b:=#50; #51: b:=#51; #52: b:=#52; #53: b:=#53; #54: b:=#54; #55: b:=#55; #56: b:=#56; #57: b:=#57;
{Спец символы}  #33: b:=#33; #13: b:=#13; #9: b:=#9; #10: b:=#10; #32: b:=#32; #64: b:=#64; #35: b:=#35; #36: b:=#36; #37: b:=#37; #94: b:=#94; #38: b:=#38; #42: b:=#42; #40: b:=#40; #41: b:=#41; #45: b:=#45; #95: b:=#95; #43: b:=#43; #61: b:=#61; #92: b:=#92; #47: b:=#47; #124: b:=#124; #46: b:=#46; #44: b:=#44; #59: b:=#59; #58: b:=#58; #123: b:=#123; #125: b:=#125; #63: b:=#63; #60: b:=#60; #62: b:=#62; #34: b:=#34; #91: b:=#91; #93: b:=#93; #96: b:=#96; #126: b:=#126
                end;
    	#4: case InString[i] of
{а русские}     #48: b:=#193; #49: b:=#194; #50: b:=#215; #51: b:=#199; #52: b:=#196; #53: b:=#197; #54: b:=#214; #55: b:=#218; #56: b:=#201; #57: b:=#202; #58: b:=#203; #59: b:=#204; #60: b:=#205; #61: b:=#206; #62: b:=#207; #63: b:=#208; #64: b:=#210; #65: b:=#211; #66: b:=#212; #67: b:=#213; #68: b:=#198; #69: b:=#200; #70: b:=#195; #71: b:=#222; #72: b:=#219; #73: b:=#221; #74: b:=#223; #75: b:=#217; #76: b:=#216; #77: b:=#220; #78: b:=#192; #79: b:=#209; #81: b:=#163;
{А русские}     #16: b:=#225; #17: b:=#226; #18: b:=#247; #19: b:=#231; #20: b:=#228; #21: b:=#229; #22: b:=#246; #23: b:=#250; #24: b:=#233; #25: b:=#234; #26: b:=#235; #27: b:=#236; #28: b:=#237; #29: b:=#238; #30: b:=#239; #31: b:=#240; #32: b:=#242; #33: b:=#243; #34: b:=#244; #35: b:=#245; #36: b:=#230; #37: b:=#232; #38: b:=#227; #39: b:=#254; #40: b:=#251; #41: b:=#253; #42: b:=#255; #43: b:=#249; #44: b:=#248; #45: b:=#252; #46: b:=#224; #47: b:=#241; #1: b:=#179
                end
                else if (InString[i]=#84) and (InString[i+1]=#70) then b:=#78
    	end;
		OutString:=OutString+b;
  	i:=i+2
	until i>Len;
  Text:=OutString
  except
  Result:=false
  end
end;

function UnicodeToMac(var Text: string): boolean;
var InString, OutString: string;
    i, Len: integer;
    b: Char;
begin
Result:=true; i:=1;
InString:=Text; OutString:='';
Delete(InString, 1, 2);
Len:=Length(InString);
try
	repeat
  	case InString[i+1] of
  		#0: case InString[i] of
{a english}     #97: b:=#97; #98: b:=#98; #99: b:=#99; #100: b:=#100; #101: b:=#101; #102: b:=#102; #103: b:=#103; #104: b:=#104; #105: b:=#105; #106: b:=#106; #107: b:=#107; #108: b:=#108; #109: b:=#109; #110: b:=#110; #111: b:=#111; #112: b:=#112; #113: b:=#113; #114: b:=#114; #115: b:=#115; #116: b:=#116; #117: b:=#117; #118: b:=#118; #119: b:=#119; #120: b:=#120; #121: b:=#121; #122: b:=#122;
{A english}     #65: b:=#65; #66: b:=#66; #67: b:=#67; #68: b:=#68; #69: b:=#67; #70: b:=#70; #71: b:=#71; #72: b:=#72; #73: b:=#73; #74: b:=#74; #75: b:=#75; #76: b:=#76; #77: b:=#77; #78: b:=#78; #79: b:=#79; #80: b:=#80; #81: b:=#81; #82: b:=#82; #83: b:=#83; #84: b:=#84; #85: b:=#85; #86: b:=#86; #87: b:=#87; #88: b:=#88; #89: b:=#89; #90: b:=#90;
{0..9}          #48: b:=#48; #49: b:=#49; #50: b:=#50; #51: b:=#51; #52: b:=#52; #53: b:=#53; #54: b:=#54; #55: b:=#55; #56: b:=#56; #57: b:=#57;
{Спец символы}  #33: b:=#33; #13: b:=#13; #9: b:=#9; #10: b:=#10; #32: b:=#32; #64: b:=#64; #35: b:=#35; #36: b:=#36; #37: b:=#37; #94: b:=#94; #38: b:=#38; #42: b:=#42; #40: b:=#40; #41: b:=#41; #45: b:=#45; #95: b:=#95; #43: b:=#43; #61: b:=#61; #92: b:=#92; #47: b:=#47; #124: b:=#124; #46: b:=#46; #44: b:=#44; #59: b:=#59; #58: b:=#58; #123: b:=#123; #125: b:=#125; #63: b:=#63; #60: b:=#60; #62: b:=#62; #34: b:=#34; #91: b:=#91; #93: b:=#93; #96: b:=#96; #126: b:=#126
                end;
    	#4: case InString[i] of
{а русские}     #48: b:=#255; #49: b:=#240; #50: b:=#162; #51: b:=#163; #52: b:=#164; #53: b:=#165; #54: b:=#166; #55: b:=#167; #56: b:=#168; #57: b:=#169; #58: b:=#170; #59: b:=#171; #60: b:=#172; #61: b:=#173; #62: b:=#174; #63: b:=#175; #64: b:=#224; #65: b:=#225; #66: b:=#226; #67: b:=#227; #68: b:=#228; #69: b:=#229; #70: b:=#230; #71: b:=#231; #72: b:=#232; #73: b:=#233; #74: b:=#234; #75: b:=#235; #76: b:=#236; #77: b:=#237; #78: b:=#238; #79: b:=#239; #81: b:=#241;
{А русские}     #16: b:=#128; #17: b:=#129; #18: b:=#130; #19: b:=#131; #20: b:=#132; #21: b:=#133; #22: b:=#134; #23: b:=#135; #24: b:=#136; #25: b:=#137; #26: b:=#138; #27: b:=#139; #28: b:=#140; #29: b:=#141; #30: b:=#142; #31: b:=#143; #32: b:=#144; #33: b:=#145; #34: b:=#146; #35: b:=#147; #36: b:=#148; #37: b:=#149; #38: b:=#150; #39: b:=#151; #40: b:=#152; #41: b:=#153; #42: b:=#154; #43: b:=#155; #44: b:=#156; #45: b:=#157; #46: b:=#158; #47: b:=#159; #1: b:=#252
                end
                else if (InString[i]=#84) and (InString[i+1]=#70) then b:=#252
    	end;
		OutString:=OutString+b;
  	i:=i+2
	until i>Len;
  Text:=OutString
  except
  Result:=false
  end
end;

function UnicodeToWin(var Text: string): boolean;
var InString, OutString: string;
    i, Len: integer;
    b: Char;
begin
Result:=true; i:=1;
InString:=Text; OutString:='';
Delete(InString, 1, 2);
Len:=Length(InString);
try
	repeat
  	case InString[i+1] of
  		#0: case InString[i] of
{a english}     #97: b:=#97; #98: b:=#98; #99: b:=#99; #100: b:=#100; #101: b:=#101; #102: b:=#102; #103: b:=#103; #104: b:=#104; #105: b:=#105; #106: b:=#106; #107: b:=#107; #108: b:=#108; #109: b:=#109; #110: b:=#110; #111: b:=#111; #112: b:=#112; #113: b:=#113; #114: b:=#114; #115: b:=#115; #116: b:=#116; #117: b:=#117; #118: b:=#118; #119: b:=#119; #120: b:=#120; #121: b:=#121; #122: b:=#122;
{A english}     #65: b:=#65; #66: b:=#66; #67: b:=#67; #68: b:=#68; #69: b:=#67; #70: b:=#70; #71: b:=#71; #72: b:=#72; #73: b:=#73; #74: b:=#74; #75: b:=#75; #76: b:=#76; #77: b:=#77; #78: b:=#78; #79: b:=#79; #80: b:=#80; #81: b:=#81; #82: b:=#82; #83: b:=#83; #84: b:=#84; #85: b:=#85; #86: b:=#86; #87: b:=#87; #88: b:=#88; #89: b:=#89; #90: b:=#90;
{0..9}          #48: b:=#48; #49: b:=#49; #50: b:=#50; #51: b:=#51; #52: b:=#52; #53: b:=#53; #54: b:=#54; #55: b:=#55; #56: b:=#56; #57: b:=#57;
{Спец символы}  #33: b:=#33; #13: b:=#13; #9: b:=#9; #10: b:=#10; #32: b:=#32; #64: b:=#64; #35: b:=#35; #36: b:=#36; #37: b:=#37; #94: b:=#94; #38: b:=#38; #42: b:=#42; #40: b:=#40; #41: b:=#41; #45: b:=#45; #95: b:=#95; #43: b:=#43; #61: b:=#61; #92: b:=#92; #47: b:=#47; #124: b:=#124; #46: b:=#46; #44: b:=#44; #59: b:=#59; #58: b:=#58; #123: b:=#123; #125: b:=#125; #63: b:=#63; #60: b:=#60; #62: b:=#62; #34: b:=#34; #91: b:=#91; #93: b:=#93; #96: b:=#96; #126: b:=#126
                end;
    	#4: case InString[i] of
{а русские}     #48: b:=#224; #49: b:=#225; #50: b:=#226; #51: b:=#227; #52: b:=#228; #53: b:=#229; #54: b:=#230; #55: b:=#231; #56: b:=#232; #57: b:=#233; #58: b:=#234; #59: b:=#235; #60: b:=#236; #61: b:=#237; #62: b:=#238; #63: b:=#239; #64: b:=#240; #65: b:=#241; #66: b:=#242; #67: b:=#243; #68: b:=#244; #69: b:=#245; #70: b:=#246; #71: b:=#247; #72: b:=#248; #73: b:=#249; #74: b:=#250; #75: b:=#251; #76: b:=#252; #77: b:=#253; #78: b:=#254; #79: b:=#255; #81: b:=#184;
{А русские}     #16: b:=#192; #17: b:=#193; #18: b:=#194; #19: b:=#195; #20: b:=#196; #21: b:=#197; #22: b:=#198; #23: b:=#199; #24: b:=#200; #25: b:=#201; #26: b:=#202; #27: b:=#203; #28: b:=#204; #29: b:=#205; #30: b:=#206; #31: b:=#207; #32: b:=#208; #33: b:=#209; #34: b:=#210; #35: b:=#211; #36: b:=#212; #37: b:=#213; #38: b:=#214; #39: b:=#215; #40: b:=#216; #41: b:=#217; #42: b:=#218; #43: b:=#219; #44: b:=#220; #45: b:=#221; #46: b:=#222; #47: b:=#223; #1: b:=#168
                end
                else if (InString[i]=#84) and (InString[i+1]=#70) then b:=#185
    	end;
		OutString:=OutString+b;
  	i:=i+2
	until i>Len;
  Text:=OutString
  except
  Result:=false
  end
end;

function WinToDos(var Text: string): boolean;
var InString: string;
    b: char;
    i, Len: integer;
    c: byte;
begin
Result:=true;
InString:=Text;
Len:=Length(InString);
try
        for i:=1 to Len do begin
                b:=InString[i];
                c:=Ord(b);
                case c of
        {a}     	224: c:=160; 225: c:=161; 226: c:=162; 227: c:=163; 228: c:=164; 229: c:=165; 230: c:=166; 231: c:=167; 232: c:=168; 233: c:=169; 234: c:=170; 235: c:=171; 236: c:=172; 237: c:=173; 238: c:=174; 239: c:=175; 240: c:=224; 241: c:=225; 242: c:=226; 243: c:=227; 244: c:=228; 245: c:=229; 246: c:=230; 247: c:=231; 248: c:=232; 249: c:=233; 250: c:=234; 251: c:=235; 252: c:=236; 253: c:=237; 254: c:=238; 255: c:=239; 184: c:=241;
        {A}     	192: c:=128; 193: c:=129; 194: c:=130; 195: c:=131; 196: c:=132; 197: c:=133; 198: c:=134; 199: c:=135; 200: c:=136; 201: c:=137; 202: c:=138; 203: c:=139; 204: c:=140; 205: c:=141; 206: c:=142; 207: c:=143; 208: c:=144; 209: c:=145; 210: c:=146; 211: c:=147; 212: c:=148; 213: c:=149; 214: c:=150; 215: c:=151; 216: c:=152; 217: c:=153; 218: c:=154; 219: c:=155; 220: c:=156; 221: c:=157; 222: c:=158; 223: c:=159; 168: c:=240; 185: c:=252
                	end;
        				b:=Char(c);
                InString[i]:=b
                end;
        Text:=InString
        except
        Result:=false
        end
end;

function WinToIso(var Text: string): boolean;
var InString: string;
    b: char;
    i, Len: integer;
    c: byte;
begin
Result:=true;
InString:=Text;
Len:=Length(InString);
try
        for i:=1 to Len do begin
                b:=InString[i];
                c:=Ord(b);
                case c of
        {a}     	224: c:=208; 225: c:=209; 226: c:=210; 227: c:=211; 228: c:=212; 229: c:=213; 230: c:=214; 231: c:=215; 232: c:=216; 233: c:=217; 234: c:=218; 235: c:=219; 236: c:=220; 237: c:=221; 238: c:=222; 239: c:=223; 240: c:=224; 241: c:=225; 242: c:=226; 243: c:=227; 244: c:=228; 245: c:=229; 246: c:=230; 247: c:=231; 248: c:=232; 249: c:=233; 250: c:=234; 251: c:=235; 252: c:=236; 253: c:=237; 254: c:=238; 255: c:=239; 184: c:=241;
        {A}     	192: c:=176; 193: c:=177; 194: c:=178; 195: c:=179; 196: c:=180; 197: c:=181; 198: c:=182; 199: c:=183; 200: c:=184; 201: c:=185; 202: c:=186; 203: c:=187; 204: c:=188; 205: c:=189; 206: c:=190; 207: c:=191; 208: c:=192; 209: c:=193; 210: c:=194; 211: c:=195; 212: c:=196; 213: c:=197; 214: c:=198; 215: c:=199; 216: c:=200; 217: c:=201; 218: c:=202; 219: c:=203; 220: c:=204; 221: c:=205; 222: c:=206; 223: c:=207; 168: c:=161; 185: c:=240
                	end;
        				b:=Char(c);
                InString[i]:=b
                end;
        Text:=InString
        except
        Result:=false
        end
end;

function WinToKoi(var Text: string): boolean;
var InString: string;
    b: char;
    i, Len: integer;
    c: byte;
begin
Result:=true;
InString:=Text;
Len:=Length(InString);
try
        for i:=1 to Len do begin
                b:=InString[i];
                c:=Ord(b);
                case c of
        {a}     	224: c:=193; 225: c:=194; 226: c:=215; 227: c:=199; 228: c:=196; 229: c:=197; 230: c:=214; 231: c:=218; 232: c:=201; 233: c:=202; 234: c:=203; 235: c:=204; 236: c:=205; 237: c:=206; 238: c:=207; 239: c:=208; 240: c:=210; 241: c:=211; 242: c:=212; 243: c:=213; 244: c:=198; 245: c:=200; 246: c:=195; 247: c:=222; 248: c:=219; 249: c:=221; 250: c:=223; 251: c:=217; 252: c:=216; 253: c:=220; 254: c:=192; 255: c:=209; 184: c:=163;
        {A}     	192: c:=225; 193: c:=226; 194: c:=247; 195: c:=231; 196: c:=228; 197: c:=229; 198: c:=246; 199: c:=250; 200: c:=233; 201: c:=234; 202: c:=235; 203: c:=236; 204: c:=237; 205: c:=238; 206: c:=239; 207: c:=240; 208: c:=242; 209: c:=243; 210: c:=244; 211: c:=245; 212: c:=230; 213: c:=232; 214: c:=227; 215: c:=254; 216: c:=251; 217: c:=253; 218: c:=255; 219: c:=249; 220: c:=248; 221: c:=252; 222: c:=224; 223: c:=241; 168: c:=179; 185: c:=78
                	end;
        				b:=Char(c);
                InString[i]:=b
                end;
        Text:=InString
        except
        Result:=false
        end
end;

function WinToMac(var Text: string): boolean;
var InString: string;
    b: char;
    i, Len: integer;
    c: byte;
begin
Result:=true;
InString:=Text;
Len:=Length(InString);
try
        for i:=1 to Len do begin
                b:=InString[i];
                c:=Ord(b);
                case c of
        {a}     	224: c:=255; 225: c:=240; 226: c:=162; 227: c:=163; 228: c:=164; 229: c:=165; 230: c:=166; 231: c:=167; 232: c:=168; 233: c:=169; 234: c:=170; 235: c:=171; 236: c:=172; 237: c:=173; 238: c:=174; 239: c:=175; 240: c:=224; 241: c:=225; 242: c:=226; 243: c:=227; 244: c:=228; 245: c:=229; 246: c:=230; 247: c:=231; 248: c:=232; 249: c:=233; 250: c:=234; 251: c:=235; 252: c:=236; 253: c:=237; 254: c:=238; 255: c:=239; 184: c:=241;
        {A}     	192: c:=128; 193: c:=129; 194: c:=130; 195: c:=131; 196: c:=132; 197: c:=133; 198: c:=134; 199: c:=135; 200: c:=136; 201: c:=137; 202: c:=138; 203: c:=139; 204: c:=140; 205: c:=141; 206: c:=142; 207: c:=143; 208: c:=144; 209: c:=145; 210: c:=146; 211: c:=147; 212: c:=148; 213: c:=149; 214: c:=150; 215: c:=151; 216: c:=152; 217: c:=153; 218: c:=154; 219: c:=155; 220: c:=156; 221: c:=157; 222: c:=158; 223: c:=159; 168: c:=252
                	end;
        				b:=Char(c);
                InString[i]:=b
                end;
        Text:=InString
        except
        Result:=false
        end
end;

function WinToUnicode(var Text: string): boolean;
var InString, OutString, b: string;
    i, Len: integer;
    c: byte;
    a: Char;
begin
Result:=true;
InString:=Text; OutString:='';
Len:=Length(InString);
try
        b:=#255#254; OutString:=OutString+b;
        for i:=1 to Len do begin
                a:=InString[i];
                c:=Ord(a);
                case c of
{a english}     	97: b:=#97#0; 98: b:=#98#0; 99: b:=#99#0; 100: b:=#100#0; 101: b:=#101#0; 102: b:=#102#0; 103: b:=#103#0; 104: b:=#104#0; 105: b:=#105#0; 106: b:=#106#0; 107: b:=#107#0; 108: b:=#108#0; 109: b:=#109#0; 110: b:=#110#0; 111: b:=#111#0; 112: b:=#112#0; 113: b:=#113#0; 114: b:=#114#0; 115: b:=#115#0; 116: b:=#116#0; 117: b:=#117#0; 118: b:=#118#0; 119: b:=#119#0; 120: b:=#120#0; 121: b:=#121#0; 122: b:=#122#0;
{A english}     	65: b:=#65#0; 66: b:=#66#0; 67: b:=#67#0; 68: b:=#68#0; 69: b:=#69#0; 70: b:=#70#0; 71: b:=#71#0; 72: b:=#72#0; 73: b:=#73#0; 74: b:=#74#0; 75: b:=#75#0; 76: b:=#76#0; 77: b:=#77#0; 78: b:=#78#0; 79: b:=#79#0; 80: b:=#80#0; 81: b:=#81#0; 82: b:=#82#0; 83: b:=#83#0; 84: b:=#84#0; 85: b:=#85#0; 86: b:=#86#0; 87: b:=#87#0; 88: b:=#88#0; 89: b:=#89#0; 90: b:=#90#0;
{0..9}          	48: b:=#48#0; 49: b:=#49#0; 50: b:=#50#0; 51: b:=#51#0; 52: b:=#52#0; 53: b:=#53#0; 54: b:=#54#0; 55: b:=#55#0; 56: b:=#56#0; 57: b:=#57#0;
{Спец символы}  	33: b:=#33#0; 13: b:=#13#0; 9: b:=#9#0; 10: b:=#10#0; 32: b:=#32#0; 64: b:=#64#0; 35: b:=#35#0; 36: b:=#36#0; 37: b:=#37#0; 94: b:=#94#0; 38: b:=#38#0; 42: b:=#42#0; 40: b:=#40#0; 41: b:=#41#0; 45: b:=#45#0; 95: b:=#95#0; 43: b:=#43#0; 61: b:=#61#0; 92: b:=#92#0; 47: b:=#47#0; 124: b:=#124#0; 46: b:=#46#0; 44: b:=#44#0; 59: b:=#59#0; 58: b:=#58#0; 123: b:=#123#0; 125: b:=#125#0; 63: b:=#63#0; 60: b:=#60#0; 62: b:=#62#0; 34: b:=#34#0; 91: b:=#91#0; 93: b:=#93#0; 96: b:=#96#0; 126: b:=#126#0; 185: b:=#22#33;
{а русские}     	224: b:=#48#4; 225: b:=#49#4; 226: b:=#50#4; 227: b:=#51#4; 228: b:=#52#4; 229: b:=#53#4; 230: b:=#54#4; 231: b:=#55#4; 232: b:=#56#4; 233: b:=#57#4; 234: b:=#58#4; 235: b:=#59#4; 236: b:=#60#4; 237: b:=#61#4; 238: b:=#62#4; 239: b:=#63#4; 240: b:=#64#4; 241: b:=#65#4; 242: b:=#66#4; 243: b:=#67#4; 244: b:=#68#4; 245: b:=#69#4; 246: b:=#70#4; 247: b:=#71#4; 248: b:=#72#4; 249: b:=#73#4; 250: b:=#74#4; 251: b:=#75#4; 252: b:=#76#4; 253: b:=#77#4; 254: b:=#78#4; 255: b:=#79#4; 184: b:=#81#4;
{А русские}     	192: b:=#16#4; 193: b:=#17#4; 194: b:=#18#4; 195: b:=#19#4; 196: b:=#20#4; 197: b:=#21#4; 198: b:=#22#4; 199: b:=#23#4; 200: b:=#24#4; 201: b:=#25#4; 202: b:=#26#4; 203: b:=#27#4; 204: b:=#28#4; 205: b:=#29#4; 206: b:=#30#4; 207: b:=#31#4; 208: b:=#32#4; 209: b:=#33#4; 210: b:=#34#4; 211: b:=#35#4; 212: b:=#36#4; 213: b:=#37#4; 214: b:=#38#4; 215: b:=#39#4; 216: b:=#40#4; 217: b:=#41#4; 218: b:=#42#4; 219: b:=#43#4; 220: b:=#44#4; 221: b:=#45#4; 222: b:=#46#4; 223: b:=#47#4; 168: b:=#1#4
                	end;
                OutString:=OutString+b
                end;
        Text:= OutString
        except
        Result:=false
        end
end;

end.
