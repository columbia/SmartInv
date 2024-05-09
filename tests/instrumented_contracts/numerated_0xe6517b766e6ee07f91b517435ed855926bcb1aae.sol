1 pragma solidity ^0.4.2;
2 
3 // <ORACLIZE_API>
4 /*
5 Copyright (c) 2015-2016 Oraclize SRL
6 Copyright (c) 2016 Oraclize LTD
7 
8 
9 
10 Permission is hereby granted, free of charge, to any person obtaining a copy
11 of this software and associated documentation files (the "Software"), to deal
12 in the Software without restriction, including without limitation the rights
13 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
14 copies of the Software, and to permit persons to whom the Software is
15 furnished to do so, subject to the following conditions:
16 
17 
18 
19 The above copyright notice and this permission notice shall be included in
20 all copies or substantial portions of the Software.
21 
22 
23 
24 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
25 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
26 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
27 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
28 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
29 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
30 THE SOFTWARE.
31 */
32 
33 //please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
34 
35 contract OraclizeI {
36     address public cbAddress;
37     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
38     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
39     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
40     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
41     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
42     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
43     function getPrice(string _datasource) returns (uint _dsprice);
44     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
45     function useCoupon(string _coupon);
46     function setProofType(byte _proofType);
47     function setConfig(bytes32 _config);
48     function setCustomGasPrice(uint _gasPrice);
49 }
50 contract OraclizeAddrResolverI {
51     function getAddress() returns (address _addr);
52 }
53 contract usingOraclize {
54     uint constant day = 60*60*24;
55     uint constant week = 60*60*24*7;
56     uint constant month = 60*60*24*30;
57     byte constant proofType_NONE = 0x00;
58     byte constant proofType_TLSNotary = 0x10;
59     byte constant proofStorage_IPFS = 0x01;
60     uint8 constant networkID_auto = 0;
61     uint8 constant networkID_mainnet = 1;
62     uint8 constant networkID_testnet = 2;
63     uint8 constant networkID_morden = 2;
64     uint8 constant networkID_consensys = 161;
65 
66     OraclizeAddrResolverI OAR;
67 
68     OraclizeI oraclize;
69     modifier oraclizeAPI {
70         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
71         oraclize = OraclizeI(OAR.getAddress());
72         _;
73     }
74     modifier coupon(string code){
75         oraclize = OraclizeI(OAR.getAddress());
76         oraclize.useCoupon(code);
77         _;
78     }
79 
80     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
81         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
82             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
83             return true;
84         }
85         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
86             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
87             return true;
88         }
89         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
90             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
91             return true;
92         }
93         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
94             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
95             return true;
96         }
97         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
98             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
99             return true;
100         }
101         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
102             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
103             return true;
104         }
105         return false;
106     }
107 
108     function __callback(bytes32 myid, string result) {
109         __callback(myid, result, new bytes(0));
110     }
111     function __callback(bytes32 myid, string result, bytes proof) {
112     }
113 
114     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
115         return oraclize.getPrice(datasource);
116     }
117 
118     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
119         return oraclize.getPrice(datasource, gaslimit);
120     }
121 
122     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
123         uint price = oraclize.getPrice(datasource);
124         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
125         return oraclize.query.value(price)(0, datasource, arg);
126     }
127     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
128         uint price = oraclize.getPrice(datasource);
129         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
130         return oraclize.query.value(price)(timestamp, datasource, arg);
131     }
132     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
133         uint price = oraclize.getPrice(datasource, gaslimit);
134         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
135         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
136     }
137     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
138         uint price = oraclize.getPrice(datasource, gaslimit);
139         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
140         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
141     }
142     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
143         uint price = oraclize.getPrice(datasource);
144         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
145         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
146     }
147     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
148         uint price = oraclize.getPrice(datasource);
149         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
150         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
151     }
152     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
153         uint price = oraclize.getPrice(datasource, gaslimit);
154         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
155         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
156     }
157     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
158         uint price = oraclize.getPrice(datasource, gaslimit);
159         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
160         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
161     }
162     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
163         uint price = oraclize.getPrice(datasource);
164         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
165         bytes memory args = stra2cbor(argN);
166         return oraclize.queryN.value(price)(0, datasource, args);
167     }
168     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
169         uint price = oraclize.getPrice(datasource);
170         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
171         bytes memory args = stra2cbor(argN);
172         return oraclize.queryN.value(price)(timestamp, datasource, args);
173     }
174     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
175         uint price = oraclize.getPrice(datasource, gaslimit);
176         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
177         bytes memory args = stra2cbor(argN);
178         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
179     }
180     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
181         uint price = oraclize.getPrice(datasource, gaslimit);
182         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
183         bytes memory args = stra2cbor(argN);
184         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
185     }
186     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
187         string[] memory dynargs = new string[](1);
188         dynargs[0] = args[0];
189         return oraclize_query(datasource, dynargs);
190     }
191     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
192         string[] memory dynargs = new string[](1);
193         dynargs[0] = args[0];
194         return oraclize_query(timestamp, datasource, dynargs);
195     }
196     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
197         string[] memory dynargs = new string[](1);
198         dynargs[0] = args[0];
199         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
200     }
201     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
202         string[] memory dynargs = new string[](1);
203         dynargs[0] = args[0];
204         return oraclize_query(datasource, dynargs, gaslimit);
205     }
206 
207     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
208         string[] memory dynargs = new string[](2);
209         dynargs[0] = args[0];
210         dynargs[1] = args[1];
211         return oraclize_query(datasource, dynargs);
212     }
213     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
214         string[] memory dynargs = new string[](2);
215         dynargs[0] = args[0];
216         dynargs[1] = args[1];
217         return oraclize_query(timestamp, datasource, dynargs);
218     }
219     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
220         string[] memory dynargs = new string[](2);
221         dynargs[0] = args[0];
222         dynargs[1] = args[1];
223         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
224     }
225     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
226         string[] memory dynargs = new string[](2);
227         dynargs[0] = args[0];
228         dynargs[1] = args[1];
229         return oraclize_query(datasource, dynargs, gaslimit);
230     }
231     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
232         string[] memory dynargs = new string[](3);
233         dynargs[0] = args[0];
234         dynargs[1] = args[1];
235         dynargs[2] = args[2];
236         return oraclize_query(datasource, dynargs);
237     }
238     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
239         string[] memory dynargs = new string[](3);
240         dynargs[0] = args[0];
241         dynargs[1] = args[1];
242         dynargs[2] = args[2];
243         return oraclize_query(timestamp, datasource, dynargs);
244     }
245     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
246         string[] memory dynargs = new string[](3);
247         dynargs[0] = args[0];
248         dynargs[1] = args[1];
249         dynargs[2] = args[2];
250         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
251     }
252     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
253         string[] memory dynargs = new string[](3);
254         dynargs[0] = args[0];
255         dynargs[1] = args[1];
256         dynargs[2] = args[2];
257         return oraclize_query(datasource, dynargs, gaslimit);
258     }
259 
260     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
261         string[] memory dynargs = new string[](4);
262         dynargs[0] = args[0];
263         dynargs[1] = args[1];
264         dynargs[2] = args[2];
265         dynargs[3] = args[3];
266         return oraclize_query(datasource, dynargs);
267     }
268     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
269         string[] memory dynargs = new string[](4);
270         dynargs[0] = args[0];
271         dynargs[1] = args[1];
272         dynargs[2] = args[2];
273         dynargs[3] = args[3];
274         return oraclize_query(timestamp, datasource, dynargs);
275     }
276     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
277         string[] memory dynargs = new string[](4);
278         dynargs[0] = args[0];
279         dynargs[1] = args[1];
280         dynargs[2] = args[2];
281         dynargs[3] = args[3];
282         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
283     }
284     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
285         string[] memory dynargs = new string[](4);
286         dynargs[0] = args[0];
287         dynargs[1] = args[1];
288         dynargs[2] = args[2];
289         dynargs[3] = args[3];
290         return oraclize_query(datasource, dynargs, gaslimit);
291     }
292     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
293         string[] memory dynargs = new string[](5);
294         dynargs[0] = args[0];
295         dynargs[1] = args[1];
296         dynargs[2] = args[2];
297         dynargs[3] = args[3];
298         dynargs[4] = args[4];
299         return oraclize_query(datasource, dynargs);
300     }
301     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
302         string[] memory dynargs = new string[](5);
303         dynargs[0] = args[0];
304         dynargs[1] = args[1];
305         dynargs[2] = args[2];
306         dynargs[3] = args[3];
307         dynargs[4] = args[4];
308         return oraclize_query(timestamp, datasource, dynargs);
309     }
310     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
311         string[] memory dynargs = new string[](5);
312         dynargs[0] = args[0];
313         dynargs[1] = args[1];
314         dynargs[2] = args[2];
315         dynargs[3] = args[3];
316         dynargs[4] = args[4];
317         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
318     }
319     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
320         string[] memory dynargs = new string[](5);
321         dynargs[0] = args[0];
322         dynargs[1] = args[1];
323         dynargs[2] = args[2];
324         dynargs[3] = args[3];
325         dynargs[4] = args[4];
326         return oraclize_query(datasource, dynargs, gaslimit);
327     }
328 
329     function oraclize_cbAddress() oraclizeAPI internal returns (address){
330         return oraclize.cbAddress();
331     }
332     function oraclize_setProof(byte proofP) oraclizeAPI internal {
333         return oraclize.setProofType(proofP);
334     }
335     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
336         return oraclize.setCustomGasPrice(gasPrice);
337     }
338     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
339         return oraclize.setConfig(config);
340     }
341 
342     function getCodeSize(address _addr) constant internal returns(uint _size) {
343         assembly {
344             _size := extcodesize(_addr)
345         }
346     }
347 
348     function parseAddr(string _a) internal returns (address){
349         bytes memory tmp = bytes(_a);
350         uint160 iaddr = 0;
351         uint160 b1;
352         uint160 b2;
353         for (uint i=2; i<2+2*20; i+=2){
354             iaddr *= 256;
355             b1 = uint160(tmp[i]);
356             b2 = uint160(tmp[i+1]);
357             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
358             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
359             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
360             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
361             iaddr += (b1*16+b2);
362         }
363         return address(iaddr);
364     }
365 
366     function strCompare(string _a, string _b) internal returns (int) {
367         bytes memory a = bytes(_a);
368         bytes memory b = bytes(_b);
369         uint minLength = a.length;
370         if (b.length < minLength) minLength = b.length;
371         for (uint i = 0; i < minLength; i ++)
372             if (a[i] < b[i])
373                 return -1;
374             else if (a[i] > b[i])
375                 return 1;
376         if (a.length < b.length)
377             return -1;
378         else if (a.length > b.length)
379             return 1;
380         else
381             return 0;
382     }
383 
384     function indexOf(string _haystack, string _needle) internal returns (int) {
385         bytes memory h = bytes(_haystack);
386         bytes memory n = bytes(_needle);
387         if(h.length < 1 || n.length < 1 || (n.length > h.length))
388             return -1;
389         else if(h.length > (2**128 -1))
390             return -1;
391         else
392         {
393             uint subindex = 0;
394             for (uint i = 0; i < h.length; i ++)
395             {
396                 if (h[i] == n[0])
397                 {
398                     subindex = 1;
399                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
400                     {
401                         subindex++;
402                     }
403                     if(subindex == n.length)
404                         return int(i);
405                 }
406             }
407             return -1;
408         }
409     }
410 
411     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
412         bytes memory _ba = bytes(_a);
413         bytes memory _bb = bytes(_b);
414         bytes memory _bc = bytes(_c);
415         bytes memory _bd = bytes(_d);
416         bytes memory _be = bytes(_e);
417         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
418         bytes memory babcde = bytes(abcde);
419         uint k = 0;
420         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
421         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
422         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
423         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
424         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
425         return string(babcde);
426     }
427 
428     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
429         return strConcat(_a, _b, _c, _d, "");
430     }
431 
432     function strConcat(string _a, string _b, string _c) internal returns (string) {
433         return strConcat(_a, _b, _c, "", "");
434     }
435 
436     function strConcat(string _a, string _b) internal returns (string) {
437         return strConcat(_a, _b, "", "", "");
438     }
439 
440     // parseInt
441     function parseInt(string _a) internal returns (uint) {
442         return parseInt(_a, 0);
443     }
444 
445     // parseInt(parseFloat*10^_b)
446     function parseInt(string _a, uint _b) internal returns (uint) {
447         bytes memory bresult = bytes(_a);
448         uint mint = 0;
449         bool decimals = false;
450         for (uint i=0; i<bresult.length; i++){
451             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
452                 if (decimals){
453                    if (_b == 0) break;
454                     else _b--;
455                 }
456                 mint *= 10;
457                 mint += uint(bresult[i]) - 48;
458             } else if (bresult[i] == 46) decimals = true;
459         }
460         if (_b > 0) mint *= 10**_b;
461         return mint;
462     }
463 
464     function uint2str(uint i) internal returns (string){
465         if (i == 0) return "0";
466         uint j = i;
467         uint len;
468         while (j != 0){
469             len++;
470             j /= 10;
471         }
472         bytes memory bstr = new bytes(len);
473         uint k = len - 1;
474         while (i != 0){
475             bstr[k--] = byte(48 + i % 10);
476             i /= 10;
477         }
478         return string(bstr);
479     }
480 
481     function stra2cbor(string[] arr) internal returns (bytes) {
482             uint arrlen = arr.length;
483 
484             // get correct cbor output length
485             uint outputlen = 0;
486             bytes[] memory elemArray = new bytes[](arrlen);
487             for (uint i = 0; i < arrlen; i++) {
488                 elemArray[i] = (bytes(arr[i]));
489                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
490             }
491             uint ctr = 0;
492             uint cborlen = arrlen + 0x80;
493             outputlen += byte(cborlen).length;
494             bytes memory res = new bytes(outputlen);
495 
496             while (byte(cborlen).length > ctr) {
497                 res[ctr] = byte(cborlen)[ctr];
498                 ctr++;
499             }
500             for (i = 0; i < arrlen; i++) {
501                 res[ctr] = 0x5F;
502                 ctr++;
503                 for (uint x = 0; x < elemArray[i].length; x++) {
504                     // if there's a bug with larger strings, this may be the culprit
505                     if (x % 23 == 0) {
506                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
507                         elemcborlen += 0x40;
508                         uint lctr = ctr;
509                         while (byte(elemcborlen).length > ctr - lctr) {
510                             res[ctr] = byte(elemcborlen)[ctr - lctr];
511                             ctr++;
512                         }
513                     }
514                     res[ctr] = elemArray[i][x];
515                     ctr++;
516                 }
517                 res[ctr] = 0xFF;
518                 ctr++;
519             }
520             return res;
521         }
522 }
523 // </ORACLIZE_API>
524 
525 // Etheroll Functions
526 contract DSSafeAddSub {
527     function safeToAdd(uint a, uint b) internal returns (bool) {
528         return (a + b >= a);
529     }
530     function safeAdd(uint a, uint b) internal returns (uint) {
531         if (!safeToAdd(a, b)) throw;
532         return a + b;
533     }
534 
535     function safeToSubtract(uint a, uint b) internal returns (bool) {
536         return (b <= a);
537     }
538 
539     function safeSub(uint a, uint b) internal returns (uint) {
540         if (!safeToSubtract(a, b)) throw;
541         return a - b;
542     }
543 }
544 
545 contract IDice is usingOraclize, DSSafeAddSub {
546 
547     /*
548      * checks player profit and number is within range
549     */
550     modifier betIsValid(uint _betSize, uint _playerNumber) {
551         if(((((_betSize * (100-(safeSub(_playerNumber,1)))) / (safeSub(_playerNumber,1))+_betSize))*houseEdge/houseEdgeDivisor)-_betSize > maxProfit || _betSize < minBet || _playerNumber < minNumber || _playerNumber > maxNumber) throw;
552 		_;
553     }
554 
555     /*
556      * checks game is currently active
557     */
558     modifier gameIsActive {
559         if(gamePaused == true) throw;
560 		_;
561     }
562 
563     /*
564      * checks payouts are currently active
565     */
566     modifier payoutsAreActive {
567         if(payoutsPaused == true) throw;
568 		_;
569     }
570 
571     /*
572      * checks only Oraclize address is calling
573     */
574     modifier onlyOraclize {
575         if (msg.sender != oraclize_cbAddress()) throw;
576         _;
577     }
578 
579     /*
580      * checks only owner address is calling
581     */
582     modifier onlyOwner {
583          if (msg.sender != owner) throw;
584          _;
585     }
586 
587     /*
588      * checks only treasury address is calling
589     */
590     modifier onlyTreasury {
591          if (msg.sender != treasury) throw;
592          _;
593     }
594 
595     /*
596      * game vars
597     */
598 
599     uint constant public maxBetDivisor = 1000000;
600     uint constant public houseEdgeDivisor = 1000;
601     uint constant public maxNumber = 99;
602     uint constant public minNumber = 2;
603 	bool public gamePaused;
604     uint32 public gasForOraclize;
605     address public owner;
606     bool public payoutsPaused;
607     address public treasury;
608     uint public contractBalance;
609     uint public houseEdge;
610     uint public maxProfit;
611     uint public maxProfitAsPercentOfHouse;
612     uint public minBet;
613     int public totalBets;
614     uint public totalUserProfit;
615     uint public maxPendingPayouts;
616 
617     /*
618      * player vars
619     */
620     mapping (bytes32 => address) playerAddress;
621     mapping (bytes32 => address) playerTempAddress;
622     mapping (bytes32 => bytes32) playerBetId;
623     mapping (bytes32 => uint) playerBetValue;
624     mapping (bytes32 => uint) playerTempBetValue;
625     mapping (bytes32 => uint) playerRandomResult;
626     mapping (bytes32 => uint) playerDieResult;
627     mapping (bytes32 => uint) playerNumber;
628     mapping (address => uint) playerPendingWithdrawals;
629     mapping (bytes32 => uint) playerProfit;
630     mapping (bytes32 => uint) playerTempReward;
631 
632 
633     /*
634      * events
635     */
636     /* log bets + output to web3 for precise 'payout on win' field in UI */
637     event LogBet(bytes32 indexed BetID, address indexed PlayerAddress, uint indexed RewardValue, uint ProfitValue, uint BetValue, uint PlayerNumber);
638     /* output to web3 UI on bet result*/
639     /* Status: 0=lose, 1=win, 2=win + failed send, 3=refund, 4=refund + failed send*/
640 	event LogResult(bytes32 indexed BetID, address indexed PlayerAddress, uint indexed PlayerNumber, uint DiceResult, uint Value, int Status, bytes Proof);
641     /* log manual refunds */
642     event LogRefund(bytes32 indexed BetID, address indexed PlayerAddress, uint indexed RefundValue);
643     /* log owner transfers */
644     event LogOwnerTransfer(address indexed SentToAddress, uint indexed AmountTransferred);
645 
646 
647     /*
648      * init
649     */
650     function IDice() {
651 
652         owner = msg.sender;
653         treasury = msg.sender;
654 
655         // This setnetwork is unncessary
656         oraclize_setNetwork(networkID_auto);
657         /* use TLSNotary for oraclize call */
658 		oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
659 
660         /* init 990 = 99% (1% houseEdge)*/
661         ownerSetHouseEdge(935);
662 
663         // 25,000 = 2.5% is our max profit of the house
664         ownerSetMaxProfitAsPercentOfHouse(25000);
665         /* init min bet (0.2 ether) */
666 
667         ownerSetMinBet(200000000000000000);
668         /* init gas for oraclize */
669         gasForOraclize = 250000;
670 
671     }
672 
673     /*
674      * public function
675      * player submit bet
676      * only if game is active & bet is valid can query oraclize and set player vars
677     */
678     function playerRollDice(uint rollUnder) public
679         payable
680         gameIsActive
681         betIsValid(msg.value, rollUnder)
682 	{
683 
684         /*
685         * assign partially encrypted query to oraclize
686         * only the apiKey is encrypted
687         * integer query is in plain text
688         */
689         bytes32 rngId = oraclize_query("nested", "[URL] ['json(https://api.random.org/json-rpc/1/invoke).result.random.data.0', '\\n{\"jsonrpc\":\"2.0\",\"method\":\"generateSignedIntegers\",\"params\":{\"apiKey\":${[decrypt] BDC819nTYbEiByr/iwndzNdSJ9JGJGRWwOTnFLhrFcxtWh53H7szcqHaC+Z/6UKH6T6N57RiPNmBWGeFSmqURHUqCSyN8vmUjVj9gEi7HmCoQlLSpx8QJTV9OxhFf43u8Vn7DugZcgyVcPEkEs2lTP1BXiAd},\"n\":1,\"min\":1,\"max\":100,\"replacement\":true,\"base\":10${[identity] \"}\"},\"id\":1${[identity] \"}\"}']", gasForOraclize);
690         /* total number of bets (display purpose only) */
691         totalBets += 1;
692         /* map bet id to this oraclize query */
693 		playerBetId[rngId] = rngId;
694         /* map player lucky number to this oraclize query */
695 		playerNumber[rngId] = rollUnder;
696         /* map value of wager to this oraclize query */
697         playerBetValue[rngId] = msg.value;
698         /* map player address to this oraclize query */
699         playerAddress[rngId] = msg.sender;
700         /* safely map player reward to this oraclize query */
701         playerProfit[rngId] = ((((msg.value * (100-(safeSub(rollUnder,1)))) / (safeSub(rollUnder,1))+msg.value))*houseEdge/houseEdgeDivisor)-msg.value;
702         /* safely increase maxPendingPayouts liability - calc all pending payouts under assumption they win */
703         maxPendingPayouts = safeAdd(maxPendingPayouts, playerProfit[rngId]);
704         /* check contract can payout on win */
705         if(maxPendingPayouts >= contractBalance) throw;
706         /* provides accurate numbers for web3 and manual refunds in case of no oraclize __callback */
707         LogBet(playerBetId[rngId], playerAddress[rngId], safeAdd(playerBetValue[rngId], playerProfit[rngId]), playerProfit[rngId], playerBetValue[rngId], playerNumber[rngId]);
708 
709     }
710 
711 
712     /*
713     * semi-public function - only oraclize can call
714     */
715     /*TLSNotary for oraclize call */
716 	function __callback(bytes32 myid, string result, bytes proof) public
717     //function __callback(bytes32 myid, string result) public
718 		onlyOraclize
719 		payoutsAreActive
720 	{
721 
722         /* player address mapped to query id does not exist */
723         if (playerAddress[myid]==0x0) throw;
724 
725 	    /* map result to player */
726         playerRandomResult[myid] = parseInt(result);
727 
728         /* provably-fair random integer for player bounded to 1-100 inclusive
729         *  sha3 the result from random.org and proof (IPFS address of TLSNotary proof)
730         */
731         playerDieResult[myid] = uint(sha3(playerRandomResult[myid], proof)) % (100 - 1) + 1;
732 
733         /* get the playerAddress for this query id */
734         playerTempAddress[myid] = playerAddress[myid];
735         /* delete playerAddress for this query id */
736         delete playerAddress[myid];
737 
738         /* map the playerProfit for this query id */
739         playerTempReward[myid] = playerProfit[myid];
740         /* set  playerProfit for this query id to 0 */
741         playerProfit[myid] = 0;
742 
743         /* safely reduce maxPendingPayouts liability */
744         maxPendingPayouts = safeSub(maxPendingPayouts, playerTempReward[myid]);
745 
746         /* map the playerBetValue for this query id */
747         playerTempBetValue[myid] = playerBetValue[myid];
748         /* set  playerBetValue for this query id to 0 */
749         playerBetValue[myid] = 0;
750 
751         /*
752         * refund
753         * if result from oraclize is 0 refund only the original bet value
754         * if refund fails save refund value to playerPendingWithdrawals
755         */
756         if(playerDieResult[myid]==0){
757 
758              LogResult(playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempBetValue[myid], 3, proof);
759             //LogResult(playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempBetValue[myid], 3);
760 
761             /*
762             * send refund - external call to an untrusted contract
763             * if send fails map refund value to playerPendingWithdrawals[address]
764             * for withdrawal later via playerWithdrawPendingTransactions
765             */
766             if(!playerTempAddress[myid].send(playerTempBetValue[myid])){
767                 LogResult(playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempBetValue[myid], 4, proof);
768                 //LogResult(playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempBetValue[myid], 4);
769                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
770                 playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], playerTempBetValue[myid]);
771             }
772 
773             return;
774         }
775 
776         /*
777         * pay winner
778         * update contract balance to calculate new max bet
779         * send reward
780         * if send of reward fails save value to playerPendingWithdrawals
781         */
782         if(playerDieResult[myid] < playerNumber[myid]){
783 
784             /* safely reduce contract balance by player profit */
785             contractBalance = safeSub(contractBalance, playerTempReward[myid]);
786 
787             /* safely calculate total payout as player profit plus original wager */
788             playerTempReward[myid] = safeAdd(playerTempReward[myid], playerTempBetValue[myid]);
789 
790             totalUserProfit = totalUserProfit + playerTempReward[myid]; // total profits
791 
792             LogResult(playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempReward[myid], 1, proof);
793             //LogResult(playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempReward[myid], 1);
794 
795             /* update maximum profit */
796             setMaxProfit();
797 
798             /*
799             * send win - external call to an untrusted contract
800             * if send fails map reward value to playerPendingWithdrawals[address]
801             * for withdrawal later via playerWithdrawPendingTransactions
802             */
803             if(!playerTempAddress[myid].send(playerTempReward[myid])){
804                 LogResult(playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempReward[myid], 2, proof);
805                 //LogResult(playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempReward[myid], 2);
806                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
807                 playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], playerTempReward[myid]);
808             }
809 
810             return;
811         }
812 
813         /*
814         * no win
815         * send 1 wei to a losing bet
816         * update contract balance to calculate new max bet
817         */
818         if(playerDieResult[myid] >= playerNumber[myid]){
819 
820             LogResult(playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempBetValue[myid], 0, proof);
821             //LogResult(playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempBetValue[myid], 0);
822 
823             /*
824             *  safe adjust contractBalance
825             *  setMaxProfit
826             *  send 1 wei to losing bet
827             */
828             contractBalance = safeAdd(contractBalance, (playerTempBetValue[myid]-1));
829 
830             /* update maximum profit */
831             setMaxProfit();
832 
833             /*
834             * send 1 wei - external call to an untrusted contract
835             */
836             if(!playerTempAddress[myid].send(1)){
837                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
838                playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], 1);
839             }
840 
841             return;
842 
843         }
844 
845     }
846 
847     /*
848     * public function
849     * in case of a failed refund or win send
850     */
851     function playerWithdrawPendingTransactions() public
852         payoutsAreActive
853         returns (bool)
854      {
855         uint withdrawAmount = playerPendingWithdrawals[msg.sender];
856         playerPendingWithdrawals[msg.sender] = 0;
857         /* external call to untrusted contract */
858         if (msg.sender.call.value(withdrawAmount)()) {
859             return true;
860         } else {
861             /* if send failed revert playerPendingWithdrawals[msg.sender] = 0; */
862             /* player can try to withdraw again later */
863             playerPendingWithdrawals[msg.sender] = withdrawAmount;
864             return false;
865         }
866     }
867 
868     /* check for pending withdrawals  */
869     function playerGetPendingTxByAddress(address addressToCheck) public constant returns (uint) {
870         return playerPendingWithdrawals[addressToCheck];
871     }
872 
873     /*
874     * internal function
875     * sets max profit
876     */
877     function setMaxProfit() internal {
878         maxProfit = (contractBalance*maxProfitAsPercentOfHouse)/maxBetDivisor;
879     }
880 
881     /*
882     * owner/treasury address only functions
883     */
884     function ()
885         payable
886     {
887         playerRollDice(47);
888     }
889 
890     function ownerAddBankroll ()
891     payable
892     onlyTreasury
893     {
894         /* safely update contract balance */
895         contractBalance = safeAdd(contractBalance, msg.value);
896         /* update the maximum profit */
897         setMaxProfit();
898     }
899 
900     /* set gas for oraclize query */
901     function ownerSetOraclizeSafeGas(uint32 newSafeGasToOraclize) public
902 		onlyOwner
903 	{
904     	gasForOraclize = newSafeGasToOraclize;
905     }
906 
907     /* only owner address can set houseEdge */
908     function ownerSetHouseEdge(uint newHouseEdge) public
909 		onlyOwner
910     {
911         houseEdge = newHouseEdge;
912     }
913 
914     /* only owner address can set maxProfitAsPercentOfHouse */
915     function ownerSetMaxProfitAsPercentOfHouse(uint newMaxProfitAsPercent) public
916 		onlyOwner
917     {
918         /* restrict to maximum profit of 5% of total house balance*/
919         if(newMaxProfitAsPercent > 50000) throw;
920         maxProfitAsPercentOfHouse = newMaxProfitAsPercent;
921         setMaxProfit();
922     }
923 
924     /* only owner address can set minBet */
925     function ownerSetMinBet(uint newMinimumBet) public
926 		onlyOwner
927     {
928         minBet = newMinimumBet;
929     }
930 
931     /* only owner address can transfer ether */
932     function ownerTransferEther(address sendTo, uint amount) public
933 		onlyOwner
934     {
935         /* safely update contract balance when sending out funds*/
936         contractBalance = safeSub(contractBalance, amount);
937         /* update max profit */
938         setMaxProfit();
939         if(!sendTo.send(amount)) throw;
940         LogOwnerTransfer(sendTo, amount);
941     }
942 
943     /* only owner address can do manual refund
944     * used only if bet placed + oraclize failed to __callback
945     * filter LogBet by address and/or playerBetId:
946     * LogBet(playerBetId[rngId], playerAddress[rngId], safeAdd(playerBetValue[rngId], playerProfit[rngId]), playerProfit[rngId], playerBetValue[rngId], playerNumber[rngId]);
947     * check the following logs do not exist for playerBetId and/or playerAddress[rngId] before refunding:
948     * LogResult or LogRefund
949     * if LogResult exists player should use the withdraw pattern playerWithdrawPendingTransactions
950     */
951     function ownerRefundPlayer(bytes32 originalPlayerBetId, address sendTo, uint originalPlayerProfit, uint originalPlayerBetValue) public
952 		onlyOwner
953     {
954         /* safely reduce pendingPayouts by playerProfit[rngId] */
955         maxPendingPayouts = safeSub(maxPendingPayouts, originalPlayerProfit);
956         /* send refund */
957         if(!sendTo.send(originalPlayerBetValue)) throw;
958         /* log refunds */
959         LogRefund(originalPlayerBetId, sendTo, originalPlayerBetValue);
960     }
961 
962     /* only owner address can set emergency pause #1 */
963     function ownerPauseGame(bool newStatus) public
964 		onlyOwner
965     {
966 		gamePaused = newStatus;
967     }
968 
969     /* only owner address can set emergency pause #2 */
970     function ownerPausePayouts(bool newPayoutStatus) public
971 		onlyOwner
972     {
973 		payoutsPaused = newPayoutStatus;
974     }
975 
976     /* only owner address can set treasury address */
977     function ownerSetTreasury(address newTreasury) public
978 		onlyOwner
979 	{
980         treasury = newTreasury;
981     }
982 
983     /* only owner address can set owner address */
984     function ownerChangeOwner(address newOwner) public
985 		onlyOwner
986 	{
987         owner = newOwner;
988     }
989 
990     /* only owner address can suicide - emergency */
991     function ownerkill() public
992 		onlyOwner
993 	{
994 		suicide(owner);
995 	}
996 
997 
998 }