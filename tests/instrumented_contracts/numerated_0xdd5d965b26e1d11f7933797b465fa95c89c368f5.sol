1 //just updated the encrypted api key
2 
3 pragma solidity ^0.4.2;
4 
5 // <ORACLIZE_API>
6 /*
7 Copyright (c) 2015-2016 Oraclize SRL
8 Copyright (c) 2016 Oraclize LTD
9 
10 
11 
12 Permission is hereby granted, free of charge, to any person obtaining a copy
13 of this software and associated documentation files (the "Software"), to deal
14 in the Software without restriction, including without limitation the rights
15 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
16 copies of the Software, and to permit persons to whom the Software is
17 furnished to do so, subject to the following conditions:
18 
19 
20 
21 The above copyright notice and this permission notice shall be included in
22 all copies or substantial portions of the Software.
23 
24 
25 
26 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
27 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
28 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
29 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
30 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
31 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
32 THE SOFTWARE.
33 */
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
358             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
359             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
360             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
361             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
362             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
363             iaddr += (b1*16+b2);
364         }
365         return address(iaddr);
366     }
367 
368     function strCompare(string _a, string _b) internal returns (int) {
369         bytes memory a = bytes(_a);
370         bytes memory b = bytes(_b);
371         uint minLength = a.length;
372         if (b.length < minLength) minLength = b.length;
373         for (uint i = 0; i < minLength; i ++)
374             if (a[i] < b[i])
375                 return -1;
376             else if (a[i] > b[i])
377                 return 1;
378         if (a.length < b.length)
379             return -1;
380         else if (a.length > b.length)
381             return 1;
382         else
383             return 0;
384     }
385 
386     function indexOf(string _haystack, string _needle) internal returns (int) {
387         bytes memory h = bytes(_haystack);
388         bytes memory n = bytes(_needle);
389         if(h.length < 1 || n.length < 1 || (n.length > h.length))
390             return -1;
391         else if(h.length > (2**128 -1))
392             return -1;
393         else
394         {
395             uint subindex = 0;
396             for (uint i = 0; i < h.length; i ++)
397             {
398                 if (h[i] == n[0])
399                 {
400                     subindex = 1;
401                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
402                     {
403                         subindex++;
404                     }
405                     if(subindex == n.length)
406                         return int(i);
407                 }
408             }
409             return -1;
410         }
411     }
412 
413     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
414         bytes memory _ba = bytes(_a);
415         bytes memory _bb = bytes(_b);
416         bytes memory _bc = bytes(_c);
417         bytes memory _bd = bytes(_d);
418         bytes memory _be = bytes(_e);
419         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
420         bytes memory babcde = bytes(abcde);
421         uint k = 0;
422         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
423         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
424         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
425         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
426         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
427         return string(babcde);
428     }
429 
430     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
431         return strConcat(_a, _b, _c, _d, "");
432     }
433 
434     function strConcat(string _a, string _b, string _c) internal returns (string) {
435         return strConcat(_a, _b, _c, "", "");
436     }
437 
438     function strConcat(string _a, string _b) internal returns (string) {
439         return strConcat(_a, _b, "", "", "");
440     }
441 
442     // parseInt
443     function parseInt(string _a) internal returns (uint) {
444         return parseInt(_a, 0);
445     }
446 
447     // parseInt(parseFloat*10^_b)
448     function parseInt(string _a, uint _b) internal returns (uint) {
449         bytes memory bresult = bytes(_a);
450         uint mint = 0;
451         bool decimals = false;
452         for (uint i=0; i<bresult.length; i++){
453             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
454                 if (decimals){
455                    if (_b == 0) break;
456                     else _b--;
457                 }
458                 mint *= 10;
459                 mint += uint(bresult[i]) - 48;
460             } else if (bresult[i] == 46) decimals = true;
461         }
462         if (_b > 0) mint *= 10**_b;
463         return mint;
464     }
465 
466     function uint2str(uint i) internal returns (string){
467         if (i == 0) return "0";
468         uint j = i;
469         uint len;
470         while (j != 0){
471             len++;
472             j /= 10;
473         }
474         bytes memory bstr = new bytes(len);
475         uint k = len - 1;
476         while (i != 0){
477             bstr[k--] = byte(48 + i % 10);
478             i /= 10;
479         }
480         return string(bstr);
481     }
482 
483     function stra2cbor(string[] arr) internal returns (bytes) {
484             uint arrlen = arr.length;
485 
486             // get correct cbor output length
487             uint outputlen = 0;
488             bytes[] memory elemArray = new bytes[](arrlen);
489             for (uint i = 0; i < arrlen; i++) {
490                 elemArray[i] = (bytes(arr[i]));
491                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
492             }
493             uint ctr = 0;
494             uint cborlen = arrlen + 0x80;
495             outputlen += byte(cborlen).length;
496             bytes memory res = new bytes(outputlen);
497 
498             while (byte(cborlen).length > ctr) {
499                 res[ctr] = byte(cborlen)[ctr];
500                 ctr++;
501             }
502             for (i = 0; i < arrlen; i++) {
503                 res[ctr] = 0x5F;
504                 ctr++;
505                 for (uint x = 0; x < elemArray[i].length; x++) {
506                     // if there's a bug with larger strings, this may be the culprit
507                     if (x % 23 == 0) {
508                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
509                         elemcborlen += 0x40;
510                         uint lctr = ctr;
511                         while (byte(elemcborlen).length > ctr - lctr) {
512                             res[ctr] = byte(elemcborlen)[ctr - lctr];
513                             ctr++;
514                         }
515                     }
516                     res[ctr] = elemArray[i][x];
517                     ctr++;
518                 }
519                 res[ctr] = 0xFF;
520                 ctr++;
521             }
522             return res;
523         }
524 }
525 // </ORACLIZE_API>
526 
527 /*
528  * @title String & slice utility library for Solidity contracts.
529  * @author Nick Johnson <arachnid@notdot.net>
530  *
531  * @dev Functionality in this library is largely implemented using an
532  *      abstraction called a 'slice'. A slice represents a part of a string -
533  *      anything from the entire string to a single character, or even no
534  *      characters at all (a 0-length slice). Since a slice only has to specify
535  *      an offset and a length, copying and manipulating slices is a lot less
536  *      expensive than copying and manipulating the strings they reference.
537  *
538  *      To further reduce gas costs, most functions on slice that need to return
539  *      a slice modify the original one instead of allocating a new one; for
540  *      instance, `s.split(".")` will return the text up to the first '.',
541  *      modifying s to only contain the remainder of the string after the '.'.
542  *      In situations where you do not want to modify the original slice, you
543  *      can make a copy first with `.copy()`, for example:
544  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
545  *      Solidity has no memory management, it will result in allocating many
546  *      short-lived slices that are later discarded.
547  *
548  *      Functions that return two slices come in two versions: a non-allocating
549  *      version that takes the second slice as an argument, modifying it in
550  *      place, and an allocating version that allocates and returns the second
551  *      slice; see `nextRune` for example.
552  *
553  *      Functions that have to copy string data will return strings rather than
554  *      slices; these can be cast back to slices for further processing if
555  *      required.
556  *
557  *      For convenience, some functions are provided with non-modifying
558  *      variants that create a new slice and return both; for instance,
559  *      `s.splitNew('.')` leaves s unmodified, and returns two values
560  *      corresponding to the left and right parts of the string.
561  */
562 library strings {
563     struct slice {
564         uint _len;
565         uint _ptr;
566     }
567 
568     function memcpy(uint dest, uint src, uint len) private {
569         // Copy word-length chunks while possible
570         for(; len >= 32; len -= 32) {
571             assembly {
572                 mstore(dest, mload(src))
573             }
574             dest += 32;
575             src += 32;
576         }
577 
578         // Copy remaining bytes
579         uint mask = 256 ** (32 - len) - 1;
580         assembly {
581             let srcpart := and(mload(src), not(mask))
582             let destpart := and(mload(dest), mask)
583             mstore(dest, or(destpart, srcpart))
584         }
585     }
586 
587     /*
588      * @dev Returns a slice containing the entire string.
589      * @param self The string to make a slice from.
590      * @return A newly allocated slice containing the entire string.
591      */
592     function toSlice(string self) internal returns (slice) {
593         uint ptr;
594         assembly {
595             ptr := add(self, 0x20)
596         }
597         return slice(bytes(self).length, ptr);
598     }
599 
600     /*
601      * @dev Returns the length of a null-terminated bytes32 string.
602      * @param self The value to find the length of.
603      * @return The length of the string, from 0 to 32.
604      */
605     function len(bytes32 self) internal returns (uint) {
606         uint ret;
607         if (self == 0)
608             return 0;
609         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
610             ret += 16;
611             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
612         }
613         if (self & 0xffffffffffffffff == 0) {
614             ret += 8;
615             self = bytes32(uint(self) / 0x10000000000000000);
616         }
617         if (self & 0xffffffff == 0) {
618             ret += 4;
619             self = bytes32(uint(self) / 0x100000000);
620         }
621         if (self & 0xffff == 0) {
622             ret += 2;
623             self = bytes32(uint(self) / 0x10000);
624         }
625         if (self & 0xff == 0) {
626             ret += 1;
627         }
628         return 32 - ret;
629     }
630 
631     /*
632      * @dev Returns a slice containing the entire bytes32, interpreted as a
633      *      null-termintaed utf-8 string.
634      * @param self The bytes32 value to convert to a slice.
635      * @return A new slice containing the value of the input argument up to the
636      *         first null.
637      */
638     function toSliceB32(bytes32 self) internal returns (slice ret) {
639         // Allocate space for `self` in memory, copy it there, and point ret at it
640         assembly {
641             let ptr := mload(0x40)
642             mstore(0x40, add(ptr, 0x20))
643             mstore(ptr, self)
644             mstore(add(ret, 0x20), ptr)
645         }
646         ret._len = len(self);
647     }
648 
649     /*
650      * @dev Returns a new slice containing the same data as the current slice.
651      * @param self The slice to copy.
652      * @return A new slice containing the same data as `self`.
653      */
654     function copy(slice self) internal returns (slice) {
655         return slice(self._len, self._ptr);
656     }
657 
658     /*
659      * @dev Copies a slice to a new string.
660      * @param self The slice to copy.
661      * @return A newly allocated string containing the slice's text.
662      */
663     function toString(slice self) internal returns (string) {
664         var ret = new string(self._len);
665         uint retptr;
666         assembly { retptr := add(ret, 32) }
667 
668         memcpy(retptr, self._ptr, self._len);
669         return ret;
670     }
671 
672     /*
673      * @dev Returns the length in runes of the slice. Note that this operation
674      *      takes time proportional to the length of the slice; avoid using it
675      *      in loops, and call `slice.empty()` if you only need to know whether
676      *      the slice is empty or not.
677      * @param self The slice to operate on.
678      * @return The length of the slice in runes.
679      */
680     function len(slice self) internal returns (uint) {
681         // Starting at ptr-31 means the LSB will be the byte we care about
682         var ptr = self._ptr - 31;
683         var end = ptr + self._len;
684         for (uint len = 0; ptr < end; len++) {
685             uint8 b;
686             assembly { b := and(mload(ptr), 0xFF) }
687             if (b < 0x80) {
688                 ptr += 1;
689             } else if(b < 0xE0) {
690                 ptr += 2;
691             } else if(b < 0xF0) {
692                 ptr += 3;
693             } else if(b < 0xF8) {
694                 ptr += 4;
695             } else if(b < 0xFC) {
696                 ptr += 5;
697             } else {
698                 ptr += 6;
699             }
700         }
701         return len;
702     }
703 
704     /*
705      * @dev Returns true if the slice is empty (has a length of 0).
706      * @param self The slice to operate on.
707      * @return True if the slice is empty, False otherwise.
708      */
709     function empty(slice self) internal returns (bool) {
710         return self._len == 0;
711     }
712 
713     /*
714      * @dev Returns a positive number if `other` comes lexicographically after
715      *      `self`, a negative number if it comes before, or zero if the
716      *      contents of the two slices are equal. Comparison is done per-rune,
717      *      on unicode codepoints.
718      * @param self The first slice to compare.
719      * @param other The second slice to compare.
720      * @return The result of the comparison.
721      */
722     function compare(slice self, slice other) internal returns (int) {
723         uint shortest = self._len;
724         if (other._len < self._len)
725             shortest = other._len;
726 
727         var selfptr = self._ptr;
728         var otherptr = other._ptr;
729         for (uint idx = 0; idx < shortest; idx += 32) {
730             uint a;
731             uint b;
732             assembly {
733                 a := mload(selfptr)
734                 b := mload(otherptr)
735             }
736             if (a != b) {
737                 // Mask out irrelevant bytes and check again
738                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
739                 var diff = (a & mask) - (b & mask);
740                 if (diff != 0)
741                     return int(diff);
742             }
743             selfptr += 32;
744             otherptr += 32;
745         }
746         return int(self._len) - int(other._len);
747     }
748 
749     /*
750      * @dev Returns true if the two slices contain the same text.
751      * @param self The first slice to compare.
752      * @param self The second slice to compare.
753      * @return True if the slices are equal, false otherwise.
754      */
755     function equals(slice self, slice other) internal returns (bool) {
756         return compare(self, other) == 0;
757     }
758 
759     /*
760      * @dev Extracts the first rune in the slice into `rune`, advancing the
761      *      slice to point to the next rune and returning `self`.
762      * @param self The slice to operate on.
763      * @param rune The slice that will contain the first rune.
764      * @return `rune`.
765      */
766     function nextRune(slice self, slice rune) internal returns (slice) {
767         rune._ptr = self._ptr;
768 
769         if (self._len == 0) {
770             rune._len = 0;
771             return rune;
772         }
773 
774         uint len;
775         uint b;
776         // Load the first byte of the rune into the LSBs of b
777         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
778         if (b < 0x80) {
779             len = 1;
780         } else if(b < 0xE0) {
781             len = 2;
782         } else if(b < 0xF0) {
783             len = 3;
784         } else {
785             len = 4;
786         }
787 
788         // Check for truncated codepoints
789         if (len > self._len) {
790             rune._len = self._len;
791             self._ptr += self._len;
792             self._len = 0;
793             return rune;
794         }
795 
796         self._ptr += len;
797         self._len -= len;
798         rune._len = len;
799         return rune;
800     }
801 
802     /*
803      * @dev Returns the first rune in the slice, advancing the slice to point
804      *      to the next rune.
805      * @param self The slice to operate on.
806      * @return A slice containing only the first rune from `self`.
807      */
808     function nextRune(slice self) internal returns (slice ret) {
809         nextRune(self, ret);
810     }
811 
812     /*
813      * @dev Returns the number of the first codepoint in the slice.
814      * @param self The slice to operate on.
815      * @return The number of the first codepoint in the slice.
816      */
817     function ord(slice self) internal returns (uint ret) {
818         if (self._len == 0) {
819             return 0;
820         }
821 
822         uint word;
823         uint len;
824         uint div = 2 ** 248;
825 
826         // Load the rune into the MSBs of b
827         assembly { word:= mload(mload(add(self, 32))) }
828         var b = word / div;
829         if (b < 0x80) {
830             ret = b;
831             len = 1;
832         } else if(b < 0xE0) {
833             ret = b & 0x1F;
834             len = 2;
835         } else if(b < 0xF0) {
836             ret = b & 0x0F;
837             len = 3;
838         } else {
839             ret = b & 0x07;
840             len = 4;
841         }
842 
843         // Check for truncated codepoints
844         if (len > self._len) {
845             return 0;
846         }
847 
848         for (uint i = 1; i < len; i++) {
849             div = div / 256;
850             b = (word / div) & 0xFF;
851             if (b & 0xC0 != 0x80) {
852                 // Invalid UTF-8 sequence
853                 return 0;
854             }
855             ret = (ret * 64) | (b & 0x3F);
856         }
857 
858         return ret;
859     }
860 
861     /*
862      * @dev Returns the keccak-256 hash of the slice.
863      * @param self The slice to hash.
864      * @return The hash of the slice.
865      */
866     function keccak(slice self) internal returns (bytes32 ret) {
867         assembly {
868             ret := sha3(mload(add(self, 32)), mload(self))
869         }
870     }
871 
872     /*
873      * @dev Returns true if `self` starts with `needle`.
874      * @param self The slice to operate on.
875      * @param needle The slice to search for.
876      * @return True if the slice starts with the provided text, false otherwise.
877      */
878     function startsWith(slice self, slice needle) internal returns (bool) {
879         if (self._len < needle._len) {
880             return false;
881         }
882 
883         if (self._ptr == needle._ptr) {
884             return true;
885         }
886 
887         bool equal;
888         assembly {
889             let len := mload(needle)
890             let selfptr := mload(add(self, 0x20))
891             let needleptr := mload(add(needle, 0x20))
892             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
893         }
894         return equal;
895     }
896 
897     /*
898      * @dev If `self` starts with `needle`, `needle` is removed from the
899      *      beginning of `self`. Otherwise, `self` is unmodified.
900      * @param self The slice to operate on.
901      * @param needle The slice to search for.
902      * @return `self`
903      */
904     function beyond(slice self, slice needle) internal returns (slice) {
905         if (self._len < needle._len) {
906             return self;
907         }
908 
909         bool equal = true;
910         if (self._ptr != needle._ptr) {
911             assembly {
912                 let len := mload(needle)
913                 let selfptr := mload(add(self, 0x20))
914                 let needleptr := mload(add(needle, 0x20))
915                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
916             }
917         }
918 
919         if (equal) {
920             self._len -= needle._len;
921             self._ptr += needle._len;
922         }
923 
924         return self;
925     }
926 
927     /*
928      * @dev Returns true if the slice ends with `needle`.
929      * @param self The slice to operate on.
930      * @param needle The slice to search for.
931      * @return True if the slice starts with the provided text, false otherwise.
932      */
933     function endsWith(slice self, slice needle) internal returns (bool) {
934         if (self._len < needle._len) {
935             return false;
936         }
937 
938         var selfptr = self._ptr + self._len - needle._len;
939 
940         if (selfptr == needle._ptr) {
941             return true;
942         }
943 
944         bool equal;
945         assembly {
946             let len := mload(needle)
947             let needleptr := mload(add(needle, 0x20))
948             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
949         }
950 
951         return equal;
952     }
953 
954     /*
955      * @dev If `self` ends with `needle`, `needle` is removed from the
956      *      end of `self`. Otherwise, `self` is unmodified.
957      * @param self The slice to operate on.
958      * @param needle The slice to search for.
959      * @return `self`
960      */
961     function until(slice self, slice needle) internal returns (slice) {
962         if (self._len < needle._len) {
963             return self;
964         }
965 
966         var selfptr = self._ptr + self._len - needle._len;
967         bool equal = true;
968         if (selfptr != needle._ptr) {
969             assembly {
970                 let len := mload(needle)
971                 let needleptr := mload(add(needle, 0x20))
972                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
973             }
974         }
975 
976         if (equal) {
977             self._len -= needle._len;
978         }
979 
980         return self;
981     }
982 
983     // Returns the memory address of the first byte of the first occurrence of
984     // `needle` in `self`, or the first byte after `self` if not found.
985     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
986         uint ptr;
987         uint idx;
988 
989         if (needlelen <= selflen) {
990             if (needlelen <= 32) {
991                 // Optimized assembly for 68 gas per byte on short strings
992                 assembly {
993                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
994                     let needledata := and(mload(needleptr), mask)
995                     let end := add(selfptr, sub(selflen, needlelen))
996                     ptr := selfptr
997                     loop:
998                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
999                     ptr := add(ptr, 1)
1000                     jumpi(loop, lt(sub(ptr, 1), end))
1001                     ptr := add(selfptr, selflen)
1002                     exit:
1003                 }
1004                 return ptr;
1005             } else {
1006                 // For long needles, use hashing
1007                 bytes32 hash;
1008                 assembly { hash := sha3(needleptr, needlelen) }
1009                 ptr = selfptr;
1010                 for (idx = 0; idx <= selflen - needlelen; idx++) {
1011                     bytes32 testHash;
1012                     assembly { testHash := sha3(ptr, needlelen) }
1013                     if (hash == testHash)
1014                         return ptr;
1015                     ptr += 1;
1016                 }
1017             }
1018         }
1019         return selfptr + selflen;
1020     }
1021 
1022     // Returns the memory address of the first byte after the last occurrence of
1023     // `needle` in `self`, or the address of `self` if not found.
1024     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1025         uint ptr;
1026 
1027         if (needlelen <= selflen) {
1028             if (needlelen <= 32) {
1029                 // Optimized assembly for 69 gas per byte on short strings
1030                 assembly {
1031                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1032                     let needledata := and(mload(needleptr), mask)
1033                     ptr := add(selfptr, sub(selflen, needlelen))
1034                     loop:
1035                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
1036                     ptr := sub(ptr, 1)
1037                     jumpi(loop, gt(add(ptr, 1), selfptr))
1038                     ptr := selfptr
1039                     jump(exit)
1040                     ret:
1041                     ptr := add(ptr, needlelen)
1042                     exit:
1043                 }
1044                 return ptr;
1045             } else {
1046                 // For long needles, use hashing
1047                 bytes32 hash;
1048                 assembly { hash := sha3(needleptr, needlelen) }
1049                 ptr = selfptr + (selflen - needlelen);
1050                 while (ptr >= selfptr) {
1051                     bytes32 testHash;
1052                     assembly { testHash := sha3(ptr, needlelen) }
1053                     if (hash == testHash)
1054                         return ptr + needlelen;
1055                     ptr -= 1;
1056                 }
1057             }
1058         }
1059         return selfptr;
1060     }
1061 
1062     /*
1063      * @dev Modifies `self` to contain everything from the first occurrence of
1064      *      `needle` to the end of the slice. `self` is set to the empty slice
1065      *      if `needle` is not found.
1066      * @param self The slice to search and modify.
1067      * @param needle The text to search for.
1068      * @return `self`.
1069      */
1070     function find(slice self, slice needle) internal returns (slice) {
1071         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1072         self._len -= ptr - self._ptr;
1073         self._ptr = ptr;
1074         return self;
1075     }
1076 
1077     /*
1078      * @dev Modifies `self` to contain the part of the string from the start of
1079      *      `self` to the end of the first occurrence of `needle`. If `needle`
1080      *      is not found, `self` is set to the empty slice.
1081      * @param self The slice to search and modify.
1082      * @param needle The text to search for.
1083      * @return `self`.
1084      */
1085     function rfind(slice self, slice needle) internal returns (slice) {
1086         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1087         self._len = ptr - self._ptr;
1088         return self;
1089     }
1090 
1091     /*
1092      * @dev Splits the slice, setting `self` to everything after the first
1093      *      occurrence of `needle`, and `token` to everything before it. If
1094      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1095      *      and `token` is set to the entirety of `self`.
1096      * @param self The slice to split.
1097      * @param needle The text to search for in `self`.
1098      * @param token An output parameter to which the first token is written.
1099      * @return `token`.
1100      */
1101     function split(slice self, slice needle, slice token) internal returns (slice) {
1102         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1103         token._ptr = self._ptr;
1104         token._len = ptr - self._ptr;
1105         if (ptr == self._ptr + self._len) {
1106             // Not found
1107             self._len = 0;
1108         } else {
1109             self._len -= token._len + needle._len;
1110             self._ptr = ptr + needle._len;
1111         }
1112         return token;
1113     }
1114 
1115     /*
1116      * @dev Splits the slice, setting `self` to everything after the first
1117      *      occurrence of `needle`, and returning everything before it. If
1118      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1119      *      and the entirety of `self` is returned.
1120      * @param self The slice to split.
1121      * @param needle The text to search for in `self`.
1122      * @return The part of `self` up to the first occurrence of `delim`.
1123      */
1124     function split(slice self, slice needle) internal returns (slice token) {
1125         split(self, needle, token);
1126     }
1127 
1128     /*
1129      * @dev Splits the slice, setting `self` to everything before the last
1130      *      occurrence of `needle`, and `token` to everything after it. If
1131      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1132      *      and `token` is set to the entirety of `self`.
1133      * @param self The slice to split.
1134      * @param needle The text to search for in `self`.
1135      * @param token An output parameter to which the first token is written.
1136      * @return `token`.
1137      */
1138     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
1139         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1140         token._ptr = ptr;
1141         token._len = self._len - (ptr - self._ptr);
1142         if (ptr == self._ptr) {
1143             // Not found
1144             self._len = 0;
1145         } else {
1146             self._len -= token._len + needle._len;
1147         }
1148         return token;
1149     }
1150 
1151     /*
1152      * @dev Splits the slice, setting `self` to everything before the last
1153      *      occurrence of `needle`, and returning everything after it. If
1154      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1155      *      and the entirety of `self` is returned.
1156      * @param self The slice to split.
1157      * @param needle The text to search for in `self`.
1158      * @return The part of `self` after the last occurrence of `delim`.
1159      */
1160     function rsplit(slice self, slice needle) internal returns (slice token) {
1161         rsplit(self, needle, token);
1162     }
1163 
1164     /*
1165      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
1166      * @param self The slice to search.
1167      * @param needle The text to search for in `self`.
1168      * @return The number of occurrences of `needle` found in `self`.
1169      */
1170     function count(slice self, slice needle) internal returns (uint count) {
1171         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
1172         while (ptr <= self._ptr + self._len) {
1173             count++;
1174             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
1175         }
1176     }
1177 
1178     /*
1179      * @dev Returns True if `self` contains `needle`.
1180      * @param self The slice to search.
1181      * @param needle The text to search for in `self`.
1182      * @return True if `needle` is found in `self`, false otherwise.
1183      */
1184     function contains(slice self, slice needle) internal returns (bool) {
1185         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
1186     }
1187 
1188     /*
1189      * @dev Returns a newly allocated string containing the concatenation of
1190      *      `self` and `other`.
1191      * @param self The first slice to concatenate.
1192      * @param other The second slice to concatenate.
1193      * @return The concatenation of the two strings.
1194      */
1195     function concat(slice self, slice other) internal returns (string) {
1196         var ret = new string(self._len + other._len);
1197         uint retptr;
1198         assembly { retptr := add(ret, 32) }
1199         memcpy(retptr, self._ptr, self._len);
1200         memcpy(retptr + self._len, other._ptr, other._len);
1201         return ret;
1202     }
1203 
1204     /*
1205      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1206      *      newly allocated string.
1207      * @param self The delimiter to use.
1208      * @param parts A list of slices to join.
1209      * @return A newly allocated string containing all the slices in `parts`,
1210      *         joined with `self`.
1211      */
1212     function join(slice self, slice[] parts) internal returns (string) {
1213         if (parts.length == 0)
1214             return "";
1215 
1216         uint len = self._len * (parts.length - 1);
1217         for(uint i = 0; i < parts.length; i++)
1218             len += parts[i]._len;
1219 
1220         var ret = new string(len);
1221         uint retptr;
1222         assembly { retptr := add(ret, 32) }
1223 
1224         for(i = 0; i < parts.length; i++) {
1225             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1226             retptr += parts[i]._len;
1227             if (i < parts.length - 1) {
1228                 memcpy(retptr, self._ptr, self._len);
1229                 retptr += self._len;
1230             }
1231         }
1232 
1233         return ret;
1234     }
1235 }
1236 
1237 
1238 contract DSSafeAddSub {
1239     function safeToAdd(uint a, uint b) internal returns (bool) {
1240         return (a + b >= a);
1241     }
1242     function safeAdd(uint a, uint b) internal returns (uint) {
1243         if (!safeToAdd(a, b)) throw;
1244         return a + b;
1245     }
1246 
1247     function safeToSubtract(uint a, uint b) internal returns (bool) {
1248         return (b <= a);
1249     }
1250 
1251     function safeSub(uint a, uint b) internal returns (uint) {
1252         if (!safeToSubtract(a, b)) throw;
1253         return a - b;
1254     } 
1255 }
1256 
1257 
1258 
1259 contract Etheroll is usingOraclize, DSSafeAddSub {
1260     
1261      using strings for *;
1262 
1263     /*
1264      * checks player profit, bet size and player number is within range
1265     */
1266     modifier betIsValid(uint _betSize, uint _playerNumber) {      
1267         if(((((_betSize * (100-(safeSub(_playerNumber,1)))) / (safeSub(_playerNumber,1))+_betSize))*houseEdge/houseEdgeDivisor)-_betSize > maxProfit || _betSize < minBet || _playerNumber < minNumber || _playerNumber > maxNumber) throw;        
1268 		_;
1269     }
1270 
1271     /*
1272      * checks game is currently active
1273     */
1274     modifier gameIsActive {
1275         if(gamePaused == true) throw;
1276 		_;
1277     }    
1278 
1279     /*
1280      * checks payouts are currently active
1281     */
1282     modifier payoutsAreActive {
1283         if(payoutsPaused == true) throw;
1284 		_;
1285     }    
1286 
1287     /*
1288      * checks only Oraclize address is calling
1289     */
1290     modifier onlyOraclize {
1291         if (msg.sender != oraclize_cbAddress()) throw;
1292         _;
1293     }
1294 
1295     /*
1296      * checks only owner address is calling
1297     */
1298     modifier onlyOwner {
1299          if (msg.sender != owner) throw;
1300          _;
1301     }
1302 
1303     /*
1304      * checks only treasury address is calling
1305     */
1306     modifier onlyTreasury {
1307          if (msg.sender != treasury) throw;
1308          _;
1309     }    
1310 
1311     /*
1312      * game vars
1313     */ 
1314     uint constant public maxProfitDivisor = 1000000;
1315     uint constant public houseEdgeDivisor = 1000;    
1316     uint constant public maxNumber = 99; 
1317     uint constant public minNumber = 2;
1318 	bool public gamePaused;
1319     uint32 public gasForOraclize;
1320     address public owner;
1321     bool public payoutsPaused; 
1322     address public treasury;
1323     uint public contractBalance;
1324     uint public houseEdge;     
1325     uint public maxProfit;   
1326     uint public maxProfitAsPercentOfHouse;                    
1327     uint public minBet;       
1328     int public totalBets;
1329     uint public maxPendingPayouts;
1330     uint public costToCallOraclizeInWei;
1331     uint public totalWeiWon;
1332 
1333     /*
1334      * player vars
1335     */
1336     mapping (bytes32 => address) playerAddress;
1337     mapping (bytes32 => address) playerTempAddress;
1338     mapping (bytes32 => bytes32) playerBetId;
1339     mapping (bytes32 => uint) playerBetValue;
1340     mapping (bytes32 => uint) playerTempBetValue;  
1341     mapping (bytes32 => uint) playerRandomResult;     
1342     mapping (bytes32 => uint) playerDieResult;
1343     mapping (bytes32 => uint) playerNumber;
1344     mapping (address => uint) playerPendingWithdrawals;      
1345     mapping (bytes32 => uint) playerProfit;
1346     mapping (bytes32 => uint) playerTempReward;    
1347         
1348 
1349     /*
1350      * events
1351     */
1352     /* log bets + output to web3 for precise 'payout on win' field in UI */
1353     event LogBet(bytes32 indexed BetID, address indexed PlayerAddress, uint indexed RewardValue, uint ProfitValue, uint BetValue, uint PlayerNumber);      
1354     /* output to web3 UI on bet result*/
1355     /* Status: 0=lose, 1=win, 2=win + failed send, 3=refund, 4=refund + failed send*/
1356 	event LogResult(uint indexed ResultSerialNumber, bytes32 indexed BetID, address indexed PlayerAddress, uint PlayerNumber, uint DiceResult, uint Value, int Status, bytes Proof);   
1357     /* log manual refunds */
1358     event LogRefund(bytes32 indexed BetID, address indexed PlayerAddress, uint indexed RefundValue);
1359     /* log owner transfers */
1360     event LogOwnerTransfer(address indexed SentToAddress, uint indexed AmountTransferred);               
1361 
1362 
1363     /*
1364      * init
1365     */
1366     function Etheroll() {
1367 
1368         owner = msg.sender;
1369         treasury = msg.sender;
1370         
1371         oraclize_setNetwork(networkID_auto);        
1372         /* use TLSNotary for oraclize call */
1373 		oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1374         /* init 990 = 99% (1% houseEdge)*/
1375         ownerSetHouseEdge(990);
1376         /* init 10,000 = 1%  */
1377         ownerSetMaxProfitAsPercentOfHouse(10000);
1378         /* init min bet (0.1 ether) */
1379         ownerSetMinBet(100000000000000000);        
1380         /* init gas for oraclize */        
1381         gasForOraclize = 250000;        
1382 
1383     }
1384 
1385     /*
1386      * public function
1387      * player submit bet
1388      * only if game is active & bet is valid can query oraclize and set player vars     
1389     */
1390     function playerRollDice(uint rollUnder) public 
1391         payable
1392         gameIsActive
1393         betIsValid(msg.value, rollUnder)
1394 	{        
1395         
1396         /*
1397         * assign partially encrypted query to oraclize
1398         * only the apiKey is encrypted 
1399         * integer query is in plain text
1400         */
1401         bytes32 rngId = oraclize_query("nested", "[URL] ['json(https://api.random.org/json-rpc/1/invoke).result.random[\"serialNumber\",\"data\"]', '\\n{\"jsonrpc\":\"2.0\",\"method\":\"generateSignedIntegers\",\"params\":{\"apiKey\":${[decrypt] BFw7bONBrlTL8wJfHzZJDlhDB2c6DY+n4pGe+a1jdT7qU3e6xN3szIb/9nHDsCKlp9pF531K+gdheiVMlsNT3MloZ7Vn45Hr+mvuOcW6DFnsj6aEgcrSPXiC2+unWOX9nUVk8DypQSnrIzOsEN45DXAAhPShxQY=},\"n\":1,\"min\":1,\"max\":100,\"replacement\":true,\"base\":10${[identity] \"}\"},\"id\":1${[identity] \"}\"}']", gasForOraclize);
1402         
1403         /* safely update contract balance to account for cost to call oraclize*/
1404         //contractBalance = contractBalance - costToCallOraclizeInWei;	        
1405         /* total number of bets */
1406         totalBets += 1;
1407         /* map bet id to this oraclize query */
1408 		playerBetId[rngId] = rngId;
1409         /* map player lucky number to this oraclize query */
1410 		playerNumber[rngId] = rollUnder;
1411         /* map value of wager to this oraclize query */
1412         playerBetValue[rngId] = msg.value;
1413         /* map player address to this oraclize query */
1414         playerAddress[rngId] = msg.sender;
1415         /* safely map player profit to this oraclize query */                     
1416         playerProfit[rngId] = ((((msg.value * (100-(safeSub(rollUnder,1)))) / (safeSub(rollUnder,1))+msg.value))*houseEdge/houseEdgeDivisor)-msg.value;        
1417         /* safely increase maxPendingPayouts liability - calc all pending payouts under assumption they win */
1418         maxPendingPayouts = safeAdd(maxPendingPayouts, playerProfit[rngId]);
1419         /* check contract can payout on win */
1420         if(maxPendingPayouts >= contractBalance) throw;
1421         /* provides accurate numbers for web3 and allows for manual refunds in case of no oraclize __callback */
1422         LogBet(playerBetId[rngId], playerAddress[rngId], safeAdd(playerBetValue[rngId], playerProfit[rngId]), playerProfit[rngId], playerBetValue[rngId], playerNumber[rngId]);          
1423 
1424     }   
1425              
1426 
1427     /*
1428     * semi-public function - only oraclize can call
1429     */
1430     /*TLSNotary for oraclize call */
1431 	function __callback(bytes32 myid, string result, bytes proof) public   
1432 		onlyOraclize
1433 		payoutsAreActive
1434 	{  
1435 
1436         /* player address mapped to query id does not exist */
1437         if (playerAddress[myid]==0x0) throw;
1438         
1439         /* keep oraclize honest by retrieving the serialNumber from random.org result */
1440         var sl_result = result.toSlice();
1441         sl_result.beyond("[".toSlice()).until("]".toSlice());
1442         uint serialNumberOfResult = parseInt(sl_result.split(', '.toSlice()).toString());          
1443 
1444 	    /* map result to player */
1445         playerRandomResult[myid] = parseInt(sl_result.beyond("[".toSlice()).until("]".toSlice()).toString());
1446         
1447         /* produce integer bounded to 1-100 inclusive
1448         *  via sha3 result from random.org and proof (IPFS address of TLSNotary proof)
1449         */
1450         playerDieResult[myid] = uint(sha3(playerRandomResult[myid], proof)) % 100 + 1;
1451         
1452         /* get the playerAddress for this query id */
1453         playerTempAddress[myid] = playerAddress[myid];
1454         /* delete playerAddress for this query id */
1455         delete playerAddress[myid];
1456 
1457         /* map the playerProfit for this query id */
1458         playerTempReward[myid] = playerProfit[myid];
1459         /* set  playerProfit for this query id to 0 */
1460         playerProfit[myid] = 0; 
1461 
1462         /* safely reduce maxPendingPayouts liability */
1463         maxPendingPayouts = safeSub(maxPendingPayouts, playerTempReward[myid]);         
1464 
1465         /* map the playerBetValue for this query id */
1466         playerTempBetValue[myid] = playerBetValue[myid];
1467         /* set  playerBetValue for this query id to 0 */
1468         playerBetValue[myid] = 0;                                             
1469 
1470         /*
1471         * refund
1472         * if result from oraclize is 0 refund only the original bet value
1473         * if refund fails save refund value to playerPendingWithdrawals
1474         */
1475         if(playerDieResult[myid]==0){                                
1476 
1477              LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempBetValue[myid], 3, proof);            
1478 
1479             /*
1480             * send refund - external call to an untrusted contract
1481             * if send fails map refund value to playerPendingWithdrawals[address]
1482             * for withdrawal later via playerWithdrawPendingTransactions
1483             */
1484             if(!playerTempAddress[myid].send(playerTempBetValue[myid])){
1485                 LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempBetValue[myid], 4, proof);              
1486                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
1487                 playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], playerTempBetValue[myid]);                        
1488             }
1489 
1490             return;
1491         }
1492 
1493         /*
1494         * pay winner
1495         * update contract balance to calculate new max bet
1496         * send reward
1497         * if send of reward fails save value to playerPendingWithdrawals        
1498         */
1499         if(playerDieResult[myid] < playerNumber[myid]){ 
1500 
1501             /* safely reduce contract balance by player profit */
1502             contractBalance = safeSub(contractBalance, playerTempReward[myid]); 
1503 
1504             /* update total wei won */
1505             totalWeiWon = safeAdd(totalWeiWon, playerTempReward[myid]);              
1506 
1507             /* safely calculate payout via profit plus original wager */
1508             playerTempReward[myid] = safeAdd(playerTempReward[myid], playerTempBetValue[myid]); 
1509 
1510             LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempReward[myid], 1, proof);                            
1511 
1512             /* update maximum profit */
1513             setMaxProfit();
1514             
1515             /*
1516             * send win - external call to an untrusted contract
1517             * if send fails map reward value to playerPendingWithdrawals[address]
1518             * for withdrawal later via playerWithdrawPendingTransactions
1519             */
1520             if(!playerTempAddress[myid].send(playerTempReward[myid])){
1521                 LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempReward[myid], 2, proof);                   
1522                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
1523                 playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], playerTempReward[myid]);                               
1524             }
1525 
1526             return;
1527 
1528         }
1529 
1530         /*
1531         * no win
1532         * send 1 wei to a losing bet
1533         * update contract balance to calculate new max bet
1534         */
1535         if(playerDieResult[myid] >= playerNumber[myid]){
1536 
1537             LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempBetValue[myid], 0, proof);                                
1538 
1539             /*  
1540             *  safe adjust contractBalance
1541             *  setMaxProfit
1542             *  send 1 wei to losing bet
1543             */
1544             contractBalance = safeAdd(contractBalance, (playerTempBetValue[myid]-1));                                                                         
1545 
1546             /* update maximum profit */
1547             setMaxProfit(); 
1548 
1549             /*
1550             * send 1 wei - external call to an untrusted contract                  
1551             */
1552             if(!playerTempAddress[myid].send(1)){
1553                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */                
1554                playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], 1);                                
1555             }                                   
1556 
1557             return;
1558 
1559         }
1560 
1561     }
1562     
1563     /*
1564     * public function
1565     * in case of a failed refund or win send
1566     */
1567     function playerWithdrawPendingTransactions() public 
1568         payoutsAreActive
1569         returns (bool)
1570      {
1571         uint withdrawAmount = playerPendingWithdrawals[msg.sender];
1572         playerPendingWithdrawals[msg.sender] = 0;
1573         /* external call to untrusted contract */
1574         if (msg.sender.call.value(withdrawAmount)()) {
1575             return true;
1576         } else {
1577             /* if send failed revert playerPendingWithdrawals[msg.sender] = 0; */
1578             /* player can try to withdraw again later */
1579             playerPendingWithdrawals[msg.sender] = withdrawAmount;
1580             return false;
1581         }
1582     }
1583 
1584     /* check for pending withdrawals  */
1585     function playerGetPendingTxByAddress(address addressToCheck) public constant returns (uint) {
1586         return playerPendingWithdrawals[addressToCheck];
1587     }
1588 
1589     /*
1590     * internal function
1591     * sets max profit
1592     */
1593     function setMaxProfit() internal {
1594         maxProfit = (contractBalance*maxProfitAsPercentOfHouse)/maxProfitDivisor;  
1595     }   
1596 
1597     /*
1598     * owner/treasury address only functions
1599     */
1600     function ()
1601         payable
1602         onlyTreasury
1603     {
1604         /* safely update contract balance */
1605         contractBalance = safeAdd(contractBalance, msg.value);        
1606         /* update the maximum profit */
1607         setMaxProfit();
1608     } 
1609 
1610     /* set gas for oraclize query */
1611     function ownerSetOraclizeSafeGas(uint32 newSafeGasToOraclize) public 
1612 		onlyOwner
1613 	{
1614     	gasForOraclize = newSafeGasToOraclize;
1615     }
1616 
1617     /* set house cost to call oraclize query */
1618     function ownerUpdateCostToCallOraclize(uint newCostToCallOraclizeInWei) public 
1619 		onlyOwner
1620     {        
1621        costToCallOraclizeInWei = newCostToCallOraclizeInWei;
1622     }     
1623 
1624     /* only owner address can set houseEdge */
1625     function ownerSetHouseEdge(uint newHouseEdge) public 
1626 		onlyOwner
1627     {
1628         houseEdge = newHouseEdge;
1629     }
1630 
1631     /* only owner address can set maxProfitAsPercentOfHouse */
1632     function ownerSetMaxProfitAsPercentOfHouse(uint newMaxProfitAsPercent) public 
1633 		onlyOwner
1634     {
1635         /* restrict each bet to a maximum profit of 1% contractBalance */
1636         if(newMaxProfitAsPercent > 10000) throw;
1637         maxProfitAsPercentOfHouse = newMaxProfitAsPercent;
1638         setMaxProfit();
1639     }
1640 
1641     /* only owner address can set minBet */
1642     function ownerSetMinBet(uint newMinimumBet) public 
1643 		onlyOwner
1644     {
1645         minBet = newMinimumBet;
1646     }       
1647 
1648     /* only owner address can transfer ether */
1649     function ownerTransferEther(address sendTo, uint amount) public 
1650 		onlyOwner
1651     {        
1652         /* safely update contract balance when sending out funds*/
1653         contractBalance = safeSub(contractBalance, amount);		
1654         /* update max profit */
1655         setMaxProfit();
1656         if(!sendTo.send(amount)) throw;
1657         LogOwnerTransfer(sendTo, amount); 
1658     }
1659 
1660     /* only owner address can do manual refund
1661     * used only if bet placed + oraclize failed to __callback
1662     * filter LogBet by address and/or playerBetId:
1663     * LogBet(playerBetId[rngId], playerAddress[rngId], safeAdd(playerBetValue[rngId], playerProfit[rngId]), playerProfit[rngId], playerBetValue[rngId], playerNumber[rngId]);
1664     * check the following logs do not exist for playerBetId and/or playerAddress[rngId] before refunding:
1665     * LogResult or LogRefund
1666     * if LogResult exists player should use the withdraw pattern playerWithdrawPendingTransactions 
1667     */
1668     function ownerRefundPlayer(bytes32 originalPlayerBetId, address sendTo, uint originalPlayerProfit, uint originalPlayerBetValue) public 
1669 		onlyOwner
1670     {        
1671         /* safely reduce pendingPayouts by playerProfit[rngId] */
1672         maxPendingPayouts = safeSub(maxPendingPayouts, originalPlayerProfit);
1673         /* send refund */
1674         if(!sendTo.send(originalPlayerBetValue)) throw;
1675         /* log refunds */
1676         LogRefund(originalPlayerBetId, sendTo, originalPlayerBetValue);        
1677     }    
1678 
1679     /* only owner address can set emergency pause #1 */
1680     function ownerPauseGame(bool newStatus) public 
1681 		onlyOwner
1682     {
1683 		gamePaused = newStatus;
1684     }
1685 
1686     /* only owner address can set emergency pause #2 */
1687     function ownerPausePayouts(bool newPayoutStatus) public 
1688 		onlyOwner
1689     {
1690 		payoutsPaused = newPayoutStatus;
1691     } 
1692 
1693     /* only owner address can set treasury address */
1694     function ownerSetTreasury(address newTreasury) public 
1695 		onlyOwner
1696 	{
1697         treasury = newTreasury;
1698     }         
1699 
1700     /* only owner address can set owner address */
1701     function ownerChangeOwner(address newOwner) public 
1702 		onlyOwner
1703 	{
1704         owner = newOwner;
1705     }
1706 
1707     /* only owner address can suicide - emergency */
1708     function ownerkill() public 
1709 		onlyOwner
1710 	{
1711 		suicide(owner);
1712 	}    
1713 
1714 
1715 }