1 //just updated the encrypted api key
2 //updated contractBalance -= 57245901639344;
3 
4 pragma solidity ^0.4.2;
5 
6 // <ORACLIZE_API>
7 /*
8 Copyright (c) 2015-2016 Oraclize SRL
9 Copyright (c) 2016 Oraclize LTD
10 
11 
12 
13 Permission is hereby granted, free of charge, to any person obtaining a copy
14 of this software and associated documentation files (the "Software"), to deal
15 in the Software without restriction, including without limitation the rights
16 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
17 copies of the Software, and to permit persons to whom the Software is
18 furnished to do so, subject to the following conditions:
19 
20 
21 
22 The above copyright notice and this permission notice shall be included in
23 all copies or substantial portions of the Software.
24 
25 
26 
27 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
28 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
29 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
30 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
31 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
32 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
33 THE SOFTWARE.
34 */
35 
36 contract OraclizeI {
37     address public cbAddress;
38     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
39     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
40     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
41     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
42     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
43     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
44     function getPrice(string _datasource) returns (uint _dsprice);
45     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
46     function useCoupon(string _coupon);
47     function setProofType(byte _proofType);
48     function setConfig(bytes32 _config);
49     function setCustomGasPrice(uint _gasPrice);
50 }
51 contract OraclizeAddrResolverI {
52     function getAddress() returns (address _addr);
53 }
54 contract usingOraclize {
55     uint constant day = 60*60*24;
56     uint constant week = 60*60*24*7;
57     uint constant month = 60*60*24*30;
58     byte constant proofType_NONE = 0x00;
59     byte constant proofType_TLSNotary = 0x10;
60     byte constant proofStorage_IPFS = 0x01;
61     uint8 constant networkID_auto = 0;
62     uint8 constant networkID_mainnet = 1;
63     uint8 constant networkID_testnet = 2;
64     uint8 constant networkID_morden = 2;
65     uint8 constant networkID_consensys = 161;
66 
67     OraclizeAddrResolverI OAR;
68 
69     OraclizeI oraclize;
70     modifier oraclizeAPI {
71         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
72         oraclize = OraclizeI(OAR.getAddress());
73         _;
74     }
75     modifier coupon(string code){
76         oraclize = OraclizeI(OAR.getAddress());
77         oraclize.useCoupon(code);
78         _;
79     }
80 
81     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
82         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
83             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
84             return true;
85         }
86         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
87             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
88             return true;
89         }
90         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
91             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
92             return true;
93         }
94         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
95             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
96             return true;
97         }
98         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
99             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
100             return true;
101         }
102         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
103             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
104             return true;
105         }
106         return false;
107     }
108 
109     function __callback(bytes32 myid, string result) {
110         __callback(myid, result, new bytes(0));
111     }
112     function __callback(bytes32 myid, string result, bytes proof) {
113     }
114 
115     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
116         return oraclize.getPrice(datasource);
117     }
118 
119     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
120         return oraclize.getPrice(datasource, gaslimit);
121     }
122     
123     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
124         uint price = oraclize.getPrice(datasource);
125         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
126         return oraclize.query.value(price)(0, datasource, arg);
127     }
128     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
129         uint price = oraclize.getPrice(datasource);
130         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
131         return oraclize.query.value(price)(timestamp, datasource, arg);
132     }
133     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
134         uint price = oraclize.getPrice(datasource, gaslimit);
135         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
136         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
137     }
138     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
139         uint price = oraclize.getPrice(datasource, gaslimit);
140         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
141         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
142     }
143     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
144         uint price = oraclize.getPrice(datasource);
145         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
146         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
147     }
148     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
149         uint price = oraclize.getPrice(datasource);
150         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
151         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
152     }
153     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
154         uint price = oraclize.getPrice(datasource, gaslimit);
155         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
156         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
157     }
158     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
159         uint price = oraclize.getPrice(datasource, gaslimit);
160         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
161         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
162     }
163     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
164         uint price = oraclize.getPrice(datasource);
165         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
166         bytes memory args = stra2cbor(argN);
167         return oraclize.queryN.value(price)(0, datasource, args);
168     }
169     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
170         uint price = oraclize.getPrice(datasource);
171         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
172         bytes memory args = stra2cbor(argN);
173         return oraclize.queryN.value(price)(timestamp, datasource, args);
174     }
175     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
176         uint price = oraclize.getPrice(datasource, gaslimit);
177         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
178         bytes memory args = stra2cbor(argN);
179         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
180     }
181     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
182         uint price = oraclize.getPrice(datasource, gaslimit);
183         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
184         bytes memory args = stra2cbor(argN);
185         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
186     }
187     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
188         string[] memory dynargs = new string[](1);
189         dynargs[0] = args[0];
190         return oraclize_query(datasource, dynargs);
191     }
192     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
193         string[] memory dynargs = new string[](1);
194         dynargs[0] = args[0];
195         return oraclize_query(timestamp, datasource, dynargs);
196     }
197     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
198         string[] memory dynargs = new string[](1);
199         dynargs[0] = args[0];
200         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
201     }
202     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
203         string[] memory dynargs = new string[](1);
204         dynargs[0] = args[0];       
205         return oraclize_query(datasource, dynargs, gaslimit);
206     }
207     
208     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
209         string[] memory dynargs = new string[](2);
210         dynargs[0] = args[0];
211         dynargs[1] = args[1];
212         return oraclize_query(datasource, dynargs);
213     }
214     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
215         string[] memory dynargs = new string[](2);
216         dynargs[0] = args[0];
217         dynargs[1] = args[1];
218         return oraclize_query(timestamp, datasource, dynargs);
219     }
220     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
221         string[] memory dynargs = new string[](2);
222         dynargs[0] = args[0];
223         dynargs[1] = args[1];
224         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
225     }
226     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
227         string[] memory dynargs = new string[](2);
228         dynargs[0] = args[0];
229         dynargs[1] = args[1];
230         return oraclize_query(datasource, dynargs, gaslimit);
231     }
232     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
233         string[] memory dynargs = new string[](3);
234         dynargs[0] = args[0];
235         dynargs[1] = args[1];
236         dynargs[2] = args[2];
237         return oraclize_query(datasource, dynargs);
238     }
239     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
240         string[] memory dynargs = new string[](3);
241         dynargs[0] = args[0];
242         dynargs[1] = args[1];
243         dynargs[2] = args[2];
244         return oraclize_query(timestamp, datasource, dynargs);
245     }
246     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
247         string[] memory dynargs = new string[](3);
248         dynargs[0] = args[0];
249         dynargs[1] = args[1];
250         dynargs[2] = args[2];
251         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
252     }
253     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
254         string[] memory dynargs = new string[](3);
255         dynargs[0] = args[0];
256         dynargs[1] = args[1];
257         dynargs[2] = args[2];
258         return oraclize_query(datasource, dynargs, gaslimit);
259     }
260     
261     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
262         string[] memory dynargs = new string[](4);
263         dynargs[0] = args[0];
264         dynargs[1] = args[1];
265         dynargs[2] = args[2];
266         dynargs[3] = args[3];
267         return oraclize_query(datasource, dynargs);
268     }
269     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
270         string[] memory dynargs = new string[](4);
271         dynargs[0] = args[0];
272         dynargs[1] = args[1];
273         dynargs[2] = args[2];
274         dynargs[3] = args[3];
275         return oraclize_query(timestamp, datasource, dynargs);
276     }
277     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
278         string[] memory dynargs = new string[](4);
279         dynargs[0] = args[0];
280         dynargs[1] = args[1];
281         dynargs[2] = args[2];
282         dynargs[3] = args[3];
283         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
284     }
285     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
286         string[] memory dynargs = new string[](4);
287         dynargs[0] = args[0];
288         dynargs[1] = args[1];
289         dynargs[2] = args[2];
290         dynargs[3] = args[3];
291         return oraclize_query(datasource, dynargs, gaslimit);
292     }
293     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
294         string[] memory dynargs = new string[](5);
295         dynargs[0] = args[0];
296         dynargs[1] = args[1];
297         dynargs[2] = args[2];
298         dynargs[3] = args[3];
299         dynargs[4] = args[4];
300         return oraclize_query(datasource, dynargs);
301     }
302     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
303         string[] memory dynargs = new string[](5);
304         dynargs[0] = args[0];
305         dynargs[1] = args[1];
306         dynargs[2] = args[2];
307         dynargs[3] = args[3];
308         dynargs[4] = args[4];
309         return oraclize_query(timestamp, datasource, dynargs);
310     }
311     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
312         string[] memory dynargs = new string[](5);
313         dynargs[0] = args[0];
314         dynargs[1] = args[1];
315         dynargs[2] = args[2];
316         dynargs[3] = args[3];
317         dynargs[4] = args[4];
318         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
319     }
320     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
321         string[] memory dynargs = new string[](5);
322         dynargs[0] = args[0];
323         dynargs[1] = args[1];
324         dynargs[2] = args[2];
325         dynargs[3] = args[3];
326         dynargs[4] = args[4];
327         return oraclize_query(datasource, dynargs, gaslimit);
328     }
329 
330     function oraclize_cbAddress() oraclizeAPI internal returns (address){
331         return oraclize.cbAddress();
332     }
333     function oraclize_setProof(byte proofP) oraclizeAPI internal {
334         return oraclize.setProofType(proofP);
335     }
336     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
337         return oraclize.setCustomGasPrice(gasPrice);
338     }
339     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
340         return oraclize.setConfig(config);
341     }
342 
343     function getCodeSize(address _addr) constant internal returns(uint _size) {
344         assembly {
345             _size := extcodesize(_addr)
346         }
347     }
348 
349     function parseAddr(string _a) internal returns (address){
350         bytes memory tmp = bytes(_a);
351         uint160 iaddr = 0;
352         uint160 b1;
353         uint160 b2;
354         for (uint i=2; i<2+2*20; i+=2){
355             iaddr *= 256;
356             b1 = uint160(tmp[i]);
357             b2 = uint160(tmp[i+1]);
358             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
359             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
360             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
361             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
362             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
363             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
364             iaddr += (b1*16+b2);
365         }
366         return address(iaddr);
367     }
368 
369     function strCompare(string _a, string _b) internal returns (int) {
370         bytes memory a = bytes(_a);
371         bytes memory b = bytes(_b);
372         uint minLength = a.length;
373         if (b.length < minLength) minLength = b.length;
374         for (uint i = 0; i < minLength; i ++)
375             if (a[i] < b[i])
376                 return -1;
377             else if (a[i] > b[i])
378                 return 1;
379         if (a.length < b.length)
380             return -1;
381         else if (a.length > b.length)
382             return 1;
383         else
384             return 0;
385     }
386 
387     function indexOf(string _haystack, string _needle) internal returns (int) {
388         bytes memory h = bytes(_haystack);
389         bytes memory n = bytes(_needle);
390         if(h.length < 1 || n.length < 1 || (n.length > h.length))
391             return -1;
392         else if(h.length > (2**128 -1))
393             return -1;
394         else
395         {
396             uint subindex = 0;
397             for (uint i = 0; i < h.length; i ++)
398             {
399                 if (h[i] == n[0])
400                 {
401                     subindex = 1;
402                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
403                     {
404                         subindex++;
405                     }
406                     if(subindex == n.length)
407                         return int(i);
408                 }
409             }
410             return -1;
411         }
412     }
413 
414     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
415         bytes memory _ba = bytes(_a);
416         bytes memory _bb = bytes(_b);
417         bytes memory _bc = bytes(_c);
418         bytes memory _bd = bytes(_d);
419         bytes memory _be = bytes(_e);
420         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
421         bytes memory babcde = bytes(abcde);
422         uint k = 0;
423         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
424         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
425         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
426         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
427         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
428         return string(babcde);
429     }
430 
431     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
432         return strConcat(_a, _b, _c, _d, "");
433     }
434 
435     function strConcat(string _a, string _b, string _c) internal returns (string) {
436         return strConcat(_a, _b, _c, "", "");
437     }
438 
439     function strConcat(string _a, string _b) internal returns (string) {
440         return strConcat(_a, _b, "", "", "");
441     }
442 
443     // parseInt
444     function parseInt(string _a) internal returns (uint) {
445         return parseInt(_a, 0);
446     }
447 
448     // parseInt(parseFloat*10^_b)
449     function parseInt(string _a, uint _b) internal returns (uint) {
450         bytes memory bresult = bytes(_a);
451         uint mint = 0;
452         bool decimals = false;
453         for (uint i=0; i<bresult.length; i++){
454             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
455                 if (decimals){
456                    if (_b == 0) break;
457                     else _b--;
458                 }
459                 mint *= 10;
460                 mint += uint(bresult[i]) - 48;
461             } else if (bresult[i] == 46) decimals = true;
462         }
463         if (_b > 0) mint *= 10**_b;
464         return mint;
465     }
466 
467     function uint2str(uint i) internal returns (string){
468         if (i == 0) return "0";
469         uint j = i;
470         uint len;
471         while (j != 0){
472             len++;
473             j /= 10;
474         }
475         bytes memory bstr = new bytes(len);
476         uint k = len - 1;
477         while (i != 0){
478             bstr[k--] = byte(48 + i % 10);
479             i /= 10;
480         }
481         return string(bstr);
482     }
483 
484     function stra2cbor(string[] arr) internal returns (bytes) {
485             uint arrlen = arr.length;
486 
487             // get correct cbor output length
488             uint outputlen = 0;
489             bytes[] memory elemArray = new bytes[](arrlen);
490             for (uint i = 0; i < arrlen; i++) {
491                 elemArray[i] = (bytes(arr[i]));
492                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
493             }
494             uint ctr = 0;
495             uint cborlen = arrlen + 0x80;
496             outputlen += byte(cborlen).length;
497             bytes memory res = new bytes(outputlen);
498 
499             while (byte(cborlen).length > ctr) {
500                 res[ctr] = byte(cborlen)[ctr];
501                 ctr++;
502             }
503             for (i = 0; i < arrlen; i++) {
504                 res[ctr] = 0x5F;
505                 ctr++;
506                 for (uint x = 0; x < elemArray[i].length; x++) {
507                     // if there's a bug with larger strings, this may be the culprit
508                     if (x % 23 == 0) {
509                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
510                         elemcborlen += 0x40;
511                         uint lctr = ctr;
512                         while (byte(elemcborlen).length > ctr - lctr) {
513                             res[ctr] = byte(elemcborlen)[ctr - lctr];
514                             ctr++;
515                         }
516                     }
517                     res[ctr] = elemArray[i][x];
518                     ctr++;
519                 }
520                 res[ctr] = 0xFF;
521                 ctr++;
522             }
523             return res;
524         }
525 }
526 // </ORACLIZE_API>
527 
528 /*
529  * @title String & slice utility library for Solidity contracts.
530  * @author Nick Johnson <arachnid@notdot.net>
531  *
532  * @dev Functionality in this library is largely implemented using an
533  *      abstraction called a 'slice'. A slice represents a part of a string -
534  *      anything from the entire string to a single character, or even no
535  *      characters at all (a 0-length slice). Since a slice only has to specify
536  *      an offset and a length, copying and manipulating slices is a lot less
537  *      expensive than copying and manipulating the strings they reference.
538  *
539  *      To further reduce gas costs, most functions on slice that need to return
540  *      a slice modify the original one instead of allocating a new one; for
541  *      instance, `s.split(".")` will return the text up to the first '.',
542  *      modifying s to only contain the remainder of the string after the '.'.
543  *      In situations where you do not want to modify the original slice, you
544  *      can make a copy first with `.copy()`, for example:
545  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
546  *      Solidity has no memory management, it will result in allocating many
547  *      short-lived slices that are later discarded.
548  *
549  *      Functions that return two slices come in two versions: a non-allocating
550  *      version that takes the second slice as an argument, modifying it in
551  *      place, and an allocating version that allocates and returns the second
552  *      slice; see `nextRune` for example.
553  *
554  *      Functions that have to copy string data will return strings rather than
555  *      slices; these can be cast back to slices for further processing if
556  *      required.
557  *
558  *      For convenience, some functions are provided with non-modifying
559  *      variants that create a new slice and return both; for instance,
560  *      `s.splitNew('.')` leaves s unmodified, and returns two values
561  *      corresponding to the left and right parts of the string.
562  */
563 library strings {
564     struct slice {
565         uint _len;
566         uint _ptr;
567     }
568 
569     function memcpy(uint dest, uint src, uint len) private {
570         // Copy word-length chunks while possible
571         for(; len >= 32; len -= 32) {
572             assembly {
573                 mstore(dest, mload(src))
574             }
575             dest += 32;
576             src += 32;
577         }
578 
579         // Copy remaining bytes
580         uint mask = 256 ** (32 - len) - 1;
581         assembly {
582             let srcpart := and(mload(src), not(mask))
583             let destpart := and(mload(dest), mask)
584             mstore(dest, or(destpart, srcpart))
585         }
586     }
587 
588     /*
589      * @dev Returns a slice containing the entire string.
590      * @param self The string to make a slice from.
591      * @return A newly allocated slice containing the entire string.
592      */
593     function toSlice(string self) internal returns (slice) {
594         uint ptr;
595         assembly {
596             ptr := add(self, 0x20)
597         }
598         return slice(bytes(self).length, ptr);
599     }
600 
601     /*
602      * @dev Returns the length of a null-terminated bytes32 string.
603      * @param self The value to find the length of.
604      * @return The length of the string, from 0 to 32.
605      */
606     function len(bytes32 self) internal returns (uint) {
607         uint ret;
608         if (self == 0)
609             return 0;
610         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
611             ret += 16;
612             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
613         }
614         if (self & 0xffffffffffffffff == 0) {
615             ret += 8;
616             self = bytes32(uint(self) / 0x10000000000000000);
617         }
618         if (self & 0xffffffff == 0) {
619             ret += 4;
620             self = bytes32(uint(self) / 0x100000000);
621         }
622         if (self & 0xffff == 0) {
623             ret += 2;
624             self = bytes32(uint(self) / 0x10000);
625         }
626         if (self & 0xff == 0) {
627             ret += 1;
628         }
629         return 32 - ret;
630     }
631 
632     /*
633      * @dev Returns a slice containing the entire bytes32, interpreted as a
634      *      null-termintaed utf-8 string.
635      * @param self The bytes32 value to convert to a slice.
636      * @return A new slice containing the value of the input argument up to the
637      *         first null.
638      */
639     function toSliceB32(bytes32 self) internal returns (slice ret) {
640         // Allocate space for `self` in memory, copy it there, and point ret at it
641         assembly {
642             let ptr := mload(0x40)
643             mstore(0x40, add(ptr, 0x20))
644             mstore(ptr, self)
645             mstore(add(ret, 0x20), ptr)
646         }
647         ret._len = len(self);
648     }
649 
650     /*
651      * @dev Returns a new slice containing the same data as the current slice.
652      * @param self The slice to copy.
653      * @return A new slice containing the same data as `self`.
654      */
655     function copy(slice self) internal returns (slice) {
656         return slice(self._len, self._ptr);
657     }
658 
659     /*
660      * @dev Copies a slice to a new string.
661      * @param self The slice to copy.
662      * @return A newly allocated string containing the slice's text.
663      */
664     function toString(slice self) internal returns (string) {
665         var ret = new string(self._len);
666         uint retptr;
667         assembly { retptr := add(ret, 32) }
668 
669         memcpy(retptr, self._ptr, self._len);
670         return ret;
671     }
672 
673     /*
674      * @dev Returns the length in runes of the slice. Note that this operation
675      *      takes time proportional to the length of the slice; avoid using it
676      *      in loops, and call `slice.empty()` if you only need to know whether
677      *      the slice is empty or not.
678      * @param self The slice to operate on.
679      * @return The length of the slice in runes.
680      */
681     function len(slice self) internal returns (uint) {
682         // Starting at ptr-31 means the LSB will be the byte we care about
683         var ptr = self._ptr - 31;
684         var end = ptr + self._len;
685         for (uint len = 0; ptr < end; len++) {
686             uint8 b;
687             assembly { b := and(mload(ptr), 0xFF) }
688             if (b < 0x80) {
689                 ptr += 1;
690             } else if(b < 0xE0) {
691                 ptr += 2;
692             } else if(b < 0xF0) {
693                 ptr += 3;
694             } else if(b < 0xF8) {
695                 ptr += 4;
696             } else if(b < 0xFC) {
697                 ptr += 5;
698             } else {
699                 ptr += 6;
700             }
701         }
702         return len;
703     }
704 
705     /*
706      * @dev Returns true if the slice is empty (has a length of 0).
707      * @param self The slice to operate on.
708      * @return True if the slice is empty, False otherwise.
709      */
710     function empty(slice self) internal returns (bool) {
711         return self._len == 0;
712     }
713 
714     /*
715      * @dev Returns a positive number if `other` comes lexicographically after
716      *      `self`, a negative number if it comes before, or zero if the
717      *      contents of the two slices are equal. Comparison is done per-rune,
718      *      on unicode codepoints.
719      * @param self The first slice to compare.
720      * @param other The second slice to compare.
721      * @return The result of the comparison.
722      */
723     function compare(slice self, slice other) internal returns (int) {
724         uint shortest = self._len;
725         if (other._len < self._len)
726             shortest = other._len;
727 
728         var selfptr = self._ptr;
729         var otherptr = other._ptr;
730         for (uint idx = 0; idx < shortest; idx += 32) {
731             uint a;
732             uint b;
733             assembly {
734                 a := mload(selfptr)
735                 b := mload(otherptr)
736             }
737             if (a != b) {
738                 // Mask out irrelevant bytes and check again
739                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
740                 var diff = (a & mask) - (b & mask);
741                 if (diff != 0)
742                     return int(diff);
743             }
744             selfptr += 32;
745             otherptr += 32;
746         }
747         return int(self._len) - int(other._len);
748     }
749 
750     /*
751      * @dev Returns true if the two slices contain the same text.
752      * @param self The first slice to compare.
753      * @param self The second slice to compare.
754      * @return True if the slices are equal, false otherwise.
755      */
756     function equals(slice self, slice other) internal returns (bool) {
757         return compare(self, other) == 0;
758     }
759 
760     /*
761      * @dev Extracts the first rune in the slice into `rune`, advancing the
762      *      slice to point to the next rune and returning `self`.
763      * @param self The slice to operate on.
764      * @param rune The slice that will contain the first rune.
765      * @return `rune`.
766      */
767     function nextRune(slice self, slice rune) internal returns (slice) {
768         rune._ptr = self._ptr;
769 
770         if (self._len == 0) {
771             rune._len = 0;
772             return rune;
773         }
774 
775         uint len;
776         uint b;
777         // Load the first byte of the rune into the LSBs of b
778         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
779         if (b < 0x80) {
780             len = 1;
781         } else if(b < 0xE0) {
782             len = 2;
783         } else if(b < 0xF0) {
784             len = 3;
785         } else {
786             len = 4;
787         }
788 
789         // Check for truncated codepoints
790         if (len > self._len) {
791             rune._len = self._len;
792             self._ptr += self._len;
793             self._len = 0;
794             return rune;
795         }
796 
797         self._ptr += len;
798         self._len -= len;
799         rune._len = len;
800         return rune;
801     }
802 
803     /*
804      * @dev Returns the first rune in the slice, advancing the slice to point
805      *      to the next rune.
806      * @param self The slice to operate on.
807      * @return A slice containing only the first rune from `self`.
808      */
809     function nextRune(slice self) internal returns (slice ret) {
810         nextRune(self, ret);
811     }
812 
813     /*
814      * @dev Returns the number of the first codepoint in the slice.
815      * @param self The slice to operate on.
816      * @return The number of the first codepoint in the slice.
817      */
818     function ord(slice self) internal returns (uint ret) {
819         if (self._len == 0) {
820             return 0;
821         }
822 
823         uint word;
824         uint len;
825         uint div = 2 ** 248;
826 
827         // Load the rune into the MSBs of b
828         assembly { word:= mload(mload(add(self, 32))) }
829         var b = word / div;
830         if (b < 0x80) {
831             ret = b;
832             len = 1;
833         } else if(b < 0xE0) {
834             ret = b & 0x1F;
835             len = 2;
836         } else if(b < 0xF0) {
837             ret = b & 0x0F;
838             len = 3;
839         } else {
840             ret = b & 0x07;
841             len = 4;
842         }
843 
844         // Check for truncated codepoints
845         if (len > self._len) {
846             return 0;
847         }
848 
849         for (uint i = 1; i < len; i++) {
850             div = div / 256;
851             b = (word / div) & 0xFF;
852             if (b & 0xC0 != 0x80) {
853                 // Invalid UTF-8 sequence
854                 return 0;
855             }
856             ret = (ret * 64) | (b & 0x3F);
857         }
858 
859         return ret;
860     }
861 
862     /*
863      * @dev Returns the keccak-256 hash of the slice.
864      * @param self The slice to hash.
865      * @return The hash of the slice.
866      */
867     function keccak(slice self) internal returns (bytes32 ret) {
868         assembly {
869             ret := sha3(mload(add(self, 32)), mload(self))
870         }
871     }
872 
873     /*
874      * @dev Returns true if `self` starts with `needle`.
875      * @param self The slice to operate on.
876      * @param needle The slice to search for.
877      * @return True if the slice starts with the provided text, false otherwise.
878      */
879     function startsWith(slice self, slice needle) internal returns (bool) {
880         if (self._len < needle._len) {
881             return false;
882         }
883 
884         if (self._ptr == needle._ptr) {
885             return true;
886         }
887 
888         bool equal;
889         assembly {
890             let len := mload(needle)
891             let selfptr := mload(add(self, 0x20))
892             let needleptr := mload(add(needle, 0x20))
893             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
894         }
895         return equal;
896     }
897 
898     /*
899      * @dev If `self` starts with `needle`, `needle` is removed from the
900      *      beginning of `self`. Otherwise, `self` is unmodified.
901      * @param self The slice to operate on.
902      * @param needle The slice to search for.
903      * @return `self`
904      */
905     function beyond(slice self, slice needle) internal returns (slice) {
906         if (self._len < needle._len) {
907             return self;
908         }
909 
910         bool equal = true;
911         if (self._ptr != needle._ptr) {
912             assembly {
913                 let len := mload(needle)
914                 let selfptr := mload(add(self, 0x20))
915                 let needleptr := mload(add(needle, 0x20))
916                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
917             }
918         }
919 
920         if (equal) {
921             self._len -= needle._len;
922             self._ptr += needle._len;
923         }
924 
925         return self;
926     }
927 
928     /*
929      * @dev Returns true if the slice ends with `needle`.
930      * @param self The slice to operate on.
931      * @param needle The slice to search for.
932      * @return True if the slice starts with the provided text, false otherwise.
933      */
934     function endsWith(slice self, slice needle) internal returns (bool) {
935         if (self._len < needle._len) {
936             return false;
937         }
938 
939         var selfptr = self._ptr + self._len - needle._len;
940 
941         if (selfptr == needle._ptr) {
942             return true;
943         }
944 
945         bool equal;
946         assembly {
947             let len := mload(needle)
948             let needleptr := mload(add(needle, 0x20))
949             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
950         }
951 
952         return equal;
953     }
954 
955     /*
956      * @dev If `self` ends with `needle`, `needle` is removed from the
957      *      end of `self`. Otherwise, `self` is unmodified.
958      * @param self The slice to operate on.
959      * @param needle The slice to search for.
960      * @return `self`
961      */
962     function until(slice self, slice needle) internal returns (slice) {
963         if (self._len < needle._len) {
964             return self;
965         }
966 
967         var selfptr = self._ptr + self._len - needle._len;
968         bool equal = true;
969         if (selfptr != needle._ptr) {
970             assembly {
971                 let len := mload(needle)
972                 let needleptr := mload(add(needle, 0x20))
973                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
974             }
975         }
976 
977         if (equal) {
978             self._len -= needle._len;
979         }
980 
981         return self;
982     }
983 
984     // Returns the memory address of the first byte of the first occurrence of
985     // `needle` in `self`, or the first byte after `self` if not found.
986     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
987         uint ptr;
988         uint idx;
989 
990         if (needlelen <= selflen) {
991             if (needlelen <= 32) {
992                 // Optimized assembly for 68 gas per byte on short strings
993                 assembly {
994                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
995                     let needledata := and(mload(needleptr), mask)
996                     let end := add(selfptr, sub(selflen, needlelen))
997                     ptr := selfptr
998                     loop:
999                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
1000                     ptr := add(ptr, 1)
1001                     jumpi(loop, lt(sub(ptr, 1), end))
1002                     ptr := add(selfptr, selflen)
1003                     exit:
1004                 }
1005                 return ptr;
1006             } else {
1007                 // For long needles, use hashing
1008                 bytes32 hash;
1009                 assembly { hash := sha3(needleptr, needlelen) }
1010                 ptr = selfptr;
1011                 for (idx = 0; idx <= selflen - needlelen; idx++) {
1012                     bytes32 testHash;
1013                     assembly { testHash := sha3(ptr, needlelen) }
1014                     if (hash == testHash)
1015                         return ptr;
1016                     ptr += 1;
1017                 }
1018             }
1019         }
1020         return selfptr + selflen;
1021     }
1022 
1023     // Returns the memory address of the first byte after the last occurrence of
1024     // `needle` in `self`, or the address of `self` if not found.
1025     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1026         uint ptr;
1027 
1028         if (needlelen <= selflen) {
1029             if (needlelen <= 32) {
1030                 // Optimized assembly for 69 gas per byte on short strings
1031                 assembly {
1032                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1033                     let needledata := and(mload(needleptr), mask)
1034                     ptr := add(selfptr, sub(selflen, needlelen))
1035                     loop:
1036                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
1037                     ptr := sub(ptr, 1)
1038                     jumpi(loop, gt(add(ptr, 1), selfptr))
1039                     ptr := selfptr
1040                     jump(exit)
1041                     ret:
1042                     ptr := add(ptr, needlelen)
1043                     exit:
1044                 }
1045                 return ptr;
1046             } else {
1047                 // For long needles, use hashing
1048                 bytes32 hash;
1049                 assembly { hash := sha3(needleptr, needlelen) }
1050                 ptr = selfptr + (selflen - needlelen);
1051                 while (ptr >= selfptr) {
1052                     bytes32 testHash;
1053                     assembly { testHash := sha3(ptr, needlelen) }
1054                     if (hash == testHash)
1055                         return ptr + needlelen;
1056                     ptr -= 1;
1057                 }
1058             }
1059         }
1060         return selfptr;
1061     }
1062 
1063     /*
1064      * @dev Modifies `self` to contain everything from the first occurrence of
1065      *      `needle` to the end of the slice. `self` is set to the empty slice
1066      *      if `needle` is not found.
1067      * @param self The slice to search and modify.
1068      * @param needle The text to search for.
1069      * @return `self`.
1070      */
1071     function find(slice self, slice needle) internal returns (slice) {
1072         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1073         self._len -= ptr - self._ptr;
1074         self._ptr = ptr;
1075         return self;
1076     }
1077 
1078     /*
1079      * @dev Modifies `self` to contain the part of the string from the start of
1080      *      `self` to the end of the first occurrence of `needle`. If `needle`
1081      *      is not found, `self` is set to the empty slice.
1082      * @param self The slice to search and modify.
1083      * @param needle The text to search for.
1084      * @return `self`.
1085      */
1086     function rfind(slice self, slice needle) internal returns (slice) {
1087         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1088         self._len = ptr - self._ptr;
1089         return self;
1090     }
1091 
1092     /*
1093      * @dev Splits the slice, setting `self` to everything after the first
1094      *      occurrence of `needle`, and `token` to everything before it. If
1095      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1096      *      and `token` is set to the entirety of `self`.
1097      * @param self The slice to split.
1098      * @param needle The text to search for in `self`.
1099      * @param token An output parameter to which the first token is written.
1100      * @return `token`.
1101      */
1102     function split(slice self, slice needle, slice token) internal returns (slice) {
1103         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1104         token._ptr = self._ptr;
1105         token._len = ptr - self._ptr;
1106         if (ptr == self._ptr + self._len) {
1107             // Not found
1108             self._len = 0;
1109         } else {
1110             self._len -= token._len + needle._len;
1111             self._ptr = ptr + needle._len;
1112         }
1113         return token;
1114     }
1115 
1116     /*
1117      * @dev Splits the slice, setting `self` to everything after the first
1118      *      occurrence of `needle`, and returning everything before it. If
1119      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1120      *      and the entirety of `self` is returned.
1121      * @param self The slice to split.
1122      * @param needle The text to search for in `self`.
1123      * @return The part of `self` up to the first occurrence of `delim`.
1124      */
1125     function split(slice self, slice needle) internal returns (slice token) {
1126         split(self, needle, token);
1127     }
1128 
1129     /*
1130      * @dev Splits the slice, setting `self` to everything before the last
1131      *      occurrence of `needle`, and `token` to everything after it. If
1132      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1133      *      and `token` is set to the entirety of `self`.
1134      * @param self The slice to split.
1135      * @param needle The text to search for in `self`.
1136      * @param token An output parameter to which the first token is written.
1137      * @return `token`.
1138      */
1139     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
1140         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1141         token._ptr = ptr;
1142         token._len = self._len - (ptr - self._ptr);
1143         if (ptr == self._ptr) {
1144             // Not found
1145             self._len = 0;
1146         } else {
1147             self._len -= token._len + needle._len;
1148         }
1149         return token;
1150     }
1151 
1152     /*
1153      * @dev Splits the slice, setting `self` to everything before the last
1154      *      occurrence of `needle`, and returning everything after it. If
1155      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1156      *      and the entirety of `self` is returned.
1157      * @param self The slice to split.
1158      * @param needle The text to search for in `self`.
1159      * @return The part of `self` after the last occurrence of `delim`.
1160      */
1161     function rsplit(slice self, slice needle) internal returns (slice token) {
1162         rsplit(self, needle, token);
1163     }
1164 
1165     /*
1166      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
1167      * @param self The slice to search.
1168      * @param needle The text to search for in `self`.
1169      * @return The number of occurrences of `needle` found in `self`.
1170      */
1171     function count(slice self, slice needle) internal returns (uint count) {
1172         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
1173         while (ptr <= self._ptr + self._len) {
1174             count++;
1175             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
1176         }
1177     }
1178 
1179     /*
1180      * @dev Returns True if `self` contains `needle`.
1181      * @param self The slice to search.
1182      * @param needle The text to search for in `self`.
1183      * @return True if `needle` is found in `self`, false otherwise.
1184      */
1185     function contains(slice self, slice needle) internal returns (bool) {
1186         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
1187     }
1188 
1189     /*
1190      * @dev Returns a newly allocated string containing the concatenation of
1191      *      `self` and `other`.
1192      * @param self The first slice to concatenate.
1193      * @param other The second slice to concatenate.
1194      * @return The concatenation of the two strings.
1195      */
1196     function concat(slice self, slice other) internal returns (string) {
1197         var ret = new string(self._len + other._len);
1198         uint retptr;
1199         assembly { retptr := add(ret, 32) }
1200         memcpy(retptr, self._ptr, self._len);
1201         memcpy(retptr + self._len, other._ptr, other._len);
1202         return ret;
1203     }
1204 
1205     /*
1206      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1207      *      newly allocated string.
1208      * @param self The delimiter to use.
1209      * @param parts A list of slices to join.
1210      * @return A newly allocated string containing all the slices in `parts`,
1211      *         joined with `self`.
1212      */
1213     function join(slice self, slice[] parts) internal returns (string) {
1214         if (parts.length == 0)
1215             return "";
1216 
1217         uint len = self._len * (parts.length - 1);
1218         for(uint i = 0; i < parts.length; i++)
1219             len += parts[i]._len;
1220 
1221         var ret = new string(len);
1222         uint retptr;
1223         assembly { retptr := add(ret, 32) }
1224 
1225         for(i = 0; i < parts.length; i++) {
1226             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1227             retptr += parts[i]._len;
1228             if (i < parts.length - 1) {
1229                 memcpy(retptr, self._ptr, self._len);
1230                 retptr += self._len;
1231             }
1232         }
1233 
1234         return ret;
1235     }
1236 }
1237 
1238 
1239 contract DSSafeAddSub {
1240     function safeToAdd(uint a, uint b) internal returns (bool) {
1241         return (a + b >= a);
1242     }
1243     function safeAdd(uint a, uint b) internal returns (uint) {
1244         if (!safeToAdd(a, b)) throw;
1245         return a + b;
1246     }
1247 
1248     function safeToSubtract(uint a, uint b) internal returns (bool) {
1249         return (b <= a);
1250     }
1251 
1252     function safeSub(uint a, uint b) internal returns (uint) {
1253         if (!safeToSubtract(a, b)) throw;
1254         return a - b;
1255     } 
1256 }
1257 
1258 
1259 
1260 contract Etheroll is usingOraclize, DSSafeAddSub {
1261     
1262      using strings for *;
1263 
1264     /*
1265      * checks player profit, bet size and player number is within range
1266     */
1267     modifier betIsValid(uint _betSize, uint _playerNumber) {      
1268         if(((((_betSize * (100-(safeSub(_playerNumber,1)))) / (safeSub(_playerNumber,1))+_betSize))*houseEdge/houseEdgeDivisor)-_betSize > maxProfit || _betSize < minBet || _playerNumber < minNumber || _playerNumber > maxNumber) throw;        
1269 		_;
1270     }
1271 
1272     /*
1273      * checks game is currently active
1274     */
1275     modifier gameIsActive {
1276         if(gamePaused == true) throw;
1277 		_;
1278     }    
1279 
1280     /*
1281      * checks payouts are currently active
1282     */
1283     modifier payoutsAreActive {
1284         if(payoutsPaused == true) throw;
1285 		_;
1286     }    
1287 
1288     /*
1289      * checks only Oraclize address is calling
1290     */
1291     modifier onlyOraclize {
1292         if (msg.sender != oraclize_cbAddress()) throw;
1293         _;
1294     }
1295 
1296     /*
1297      * checks only owner address is calling
1298     */
1299     modifier onlyOwner {
1300          if (msg.sender != owner) throw;
1301          _;
1302     }
1303 
1304     /*
1305      * checks only treasury address is calling
1306     */
1307     modifier onlyTreasury {
1308          if (msg.sender != treasury) throw;
1309          _;
1310     }    
1311 
1312     /*
1313      * game vars
1314     */ 
1315     uint constant public maxProfitDivisor = 1000000;
1316     uint constant public houseEdgeDivisor = 1000;    
1317     uint constant public maxNumber = 99; 
1318     uint constant public minNumber = 2;
1319 	bool public gamePaused;
1320     uint32 public gasForOraclize;
1321     address public owner;
1322     bool public payoutsPaused; 
1323     address public treasury;
1324     uint public contractBalance;
1325     uint public houseEdge;     
1326     uint public maxProfit;   
1327     uint public maxProfitAsPercentOfHouse;                    
1328     uint public minBet;       
1329     int public totalBets;
1330     uint public maxPendingPayouts;
1331     uint public costToCallOraclizeInWei;
1332     uint public totalWeiWon;
1333 
1334     /*
1335      * player vars
1336     */
1337     mapping (bytes32 => address) playerAddress;
1338     mapping (bytes32 => address) playerTempAddress;
1339     mapping (bytes32 => bytes32) playerBetId;
1340     mapping (bytes32 => uint) playerBetValue;
1341     mapping (bytes32 => uint) playerTempBetValue;  
1342     mapping (bytes32 => uint) playerRandomResult;     
1343     mapping (bytes32 => uint) playerDieResult;
1344     mapping (bytes32 => uint) playerNumber;
1345     mapping (address => uint) playerPendingWithdrawals;      
1346     mapping (bytes32 => uint) playerProfit;
1347     mapping (bytes32 => uint) playerTempReward;    
1348         
1349 
1350     /*
1351      * events
1352     */
1353     /* log bets + output to web3 for precise 'payout on win' field in UI */
1354     event LogBet(bytes32 indexed BetID, address indexed PlayerAddress, uint indexed RewardValue, uint ProfitValue, uint BetValue, uint PlayerNumber);      
1355     /* output to web3 UI on bet result*/
1356     /* Status: 0=lose, 1=win, 2=win + failed send, 3=refund, 4=refund + failed send*/
1357 	event LogResult(uint indexed ResultSerialNumber, bytes32 indexed BetID, address indexed PlayerAddress, uint PlayerNumber, uint DiceResult, uint Value, int Status, bytes Proof);   
1358     /* log manual refunds */
1359     event LogRefund(bytes32 indexed BetID, address indexed PlayerAddress, uint indexed RefundValue);
1360     /* log owner transfers */
1361     event LogOwnerTransfer(address indexed SentToAddress, uint indexed AmountTransferred);               
1362 
1363 
1364     /*
1365      * init
1366     */
1367     function Etheroll() {
1368 
1369         owner = msg.sender;
1370         treasury = msg.sender;
1371         
1372         oraclize_setNetwork(networkID_auto);        
1373         /* use TLSNotary for oraclize call */
1374 		oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1375         /* init 990 = 99% (1% houseEdge)*/
1376         ownerSetHouseEdge(990);
1377         /* init 10,000 = 1%  */
1378         ownerSetMaxProfitAsPercentOfHouse(10000);
1379         /* init min bet (0.1 ether) */
1380         ownerSetMinBet(100000000000000000);        
1381         /* init gas for oraclize */        
1382         gasForOraclize = 250000;        
1383 
1384     }
1385 
1386     /*
1387      * public function
1388      * player submit bet
1389      * only if game is active & bet is valid can query oraclize and set player vars     
1390     */
1391     function playerRollDice(uint rollUnder) public 
1392         payable
1393         gameIsActive
1394         betIsValid(msg.value, rollUnder)
1395 	{        
1396         
1397         /* safely update contract balance to account for cost to call oraclize*/
1398         contractBalance -= 58245901639344;
1399 
1400         /*
1401         * assign partially encrypted query to oraclize
1402         * only the apiKey is encrypted 
1403         * integer query is in plain text
1404         */
1405         bytes32 rngId = oraclize_query("nested", "[URL] ['json(https://api.random.org/json-rpc/1/invoke).result.random[\"serialNumber\",\"data\"]', '\\n{\"jsonrpc\":\"2.0\",\"method\":\"generateSignedIntegers\",\"params\":{\"apiKey\":${[decrypt] BDsqRqF48Vv3jzZ/Kul9DRGhdQ6PJh6WIiDiwB6rTXKGxy3995Pl32KMk36S1Cp9LpRerFc8POQomGETJ4jr55MDhEstcG79YuyHYOOv07HA/c4HtG+7yQAa4uSd68XHnjkamoPWt1bwISsZ/Y3/hBatsO1FG40=},\"n\":1,\"min\":1,\"max\":100,\"replacement\":true,\"base\":10${[identity] \"}\"},\"id\":1${[identity] \"}\"}']", gasForOraclize);
1406         	        
1407         /* total number of bets */
1408         totalBets += 1;
1409         /* map bet id to this oraclize query */
1410 		playerBetId[rngId] = rngId;
1411         /* map player lucky number to this oraclize query */
1412 		playerNumber[rngId] = rollUnder;
1413         /* map value of wager to this oraclize query */
1414         playerBetValue[rngId] = msg.value;
1415         /* map player address to this oraclize query */
1416         playerAddress[rngId] = msg.sender;
1417         /* safely map player profit to this oraclize query */                     
1418         playerProfit[rngId] = ((((msg.value * (100-(safeSub(rollUnder,1)))) / (safeSub(rollUnder,1))+msg.value))*houseEdge/houseEdgeDivisor)-msg.value;        
1419         /* safely increase maxPendingPayouts liability - calc all pending payouts under assumption they win */
1420         maxPendingPayouts = safeAdd(maxPendingPayouts, playerProfit[rngId]);
1421         /* check contract can payout on win */
1422         if(maxPendingPayouts >= contractBalance) throw;
1423         /* provides accurate numbers for web3 and allows for manual refunds in case of no oraclize __callback */
1424         LogBet(playerBetId[rngId], playerAddress[rngId], safeAdd(playerBetValue[rngId], playerProfit[rngId]), playerProfit[rngId], playerBetValue[rngId], playerNumber[rngId]);          
1425 
1426     }   
1427              
1428 
1429     /*
1430     * semi-public function - only oraclize can call
1431     */
1432     /*TLSNotary for oraclize call */
1433 	function __callback(bytes32 myid, string result, bytes proof) public   
1434 		onlyOraclize
1435 		payoutsAreActive
1436 	{  
1437 
1438         /* player address mapped to query id does not exist */
1439         if (playerAddress[myid]==0x0) throw;
1440         
1441         /* keep oraclize honest by retrieving the serialNumber from random.org result */
1442         var sl_result = result.toSlice();
1443         sl_result.beyond("[".toSlice()).until("]".toSlice());
1444         uint serialNumberOfResult = parseInt(sl_result.split(', '.toSlice()).toString());          
1445 
1446 	    /* map result to player */
1447         playerRandomResult[myid] = parseInt(sl_result.beyond("[".toSlice()).until("]".toSlice()).toString());
1448         
1449         /* produce integer bounded to 1-100 inclusive
1450         *  via sha3 result from random.org and proof (IPFS address of TLSNotary proof)
1451         */
1452         playerDieResult[myid] = uint(sha3(playerRandomResult[myid], proof)) % 100 + 1;
1453         
1454         /* get the playerAddress for this query id */
1455         playerTempAddress[myid] = playerAddress[myid];
1456         /* delete playerAddress for this query id */
1457         delete playerAddress[myid];
1458 
1459         /* map the playerProfit for this query id */
1460         playerTempReward[myid] = playerProfit[myid];
1461         /* set  playerProfit for this query id to 0 */
1462         playerProfit[myid] = 0; 
1463 
1464         /* safely reduce maxPendingPayouts liability */
1465         maxPendingPayouts = safeSub(maxPendingPayouts, playerTempReward[myid]);         
1466 
1467         /* map the playerBetValue for this query id */
1468         playerTempBetValue[myid] = playerBetValue[myid];
1469         /* set  playerBetValue for this query id to 0 */
1470         playerBetValue[myid] = 0;                                             
1471 
1472         /*
1473         * refund
1474         * if result from oraclize is 0 refund only the original bet value
1475         * if refund fails save refund value to playerPendingWithdrawals
1476         */
1477         if(playerDieResult[myid]==0){                                
1478 
1479              LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempBetValue[myid], 3, proof);            
1480 
1481             /*
1482             * send refund - external call to an untrusted contract
1483             * if send fails map refund value to playerPendingWithdrawals[address]
1484             * for withdrawal later via playerWithdrawPendingTransactions
1485             */
1486             if(!playerTempAddress[myid].send(playerTempBetValue[myid])){
1487                 LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempBetValue[myid], 4, proof);              
1488                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
1489                 playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], playerTempBetValue[myid]);                        
1490             }
1491 
1492             return;
1493         }
1494 
1495         /*
1496         * pay winner
1497         * update contract balance to calculate new max bet
1498         * send reward
1499         * if send of reward fails save value to playerPendingWithdrawals        
1500         */
1501         if(playerDieResult[myid] < playerNumber[myid]){ 
1502 
1503             /* safely reduce contract balance by player profit */
1504             contractBalance = safeSub(contractBalance, playerTempReward[myid]); 
1505 
1506             /* update total wei won */
1507             totalWeiWon = safeAdd(totalWeiWon, playerTempReward[myid]);              
1508 
1509             /* safely calculate payout via profit plus original wager */
1510             playerTempReward[myid] = safeAdd(playerTempReward[myid], playerTempBetValue[myid]); 
1511 
1512             LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempReward[myid], 1, proof);                            
1513 
1514             /* update maximum profit */
1515             setMaxProfit();
1516             
1517             /*
1518             * send win - external call to an untrusted contract
1519             * if send fails map reward value to playerPendingWithdrawals[address]
1520             * for withdrawal later via playerWithdrawPendingTransactions
1521             */
1522             if(!playerTempAddress[myid].send(playerTempReward[myid])){
1523                 LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempReward[myid], 2, proof);                   
1524                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
1525                 playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], playerTempReward[myid]);                               
1526             }
1527 
1528             return;
1529 
1530         }
1531 
1532         /*
1533         * no win
1534         * send 1 wei to a losing bet
1535         * update contract balance to calculate new max bet
1536         */
1537         if(playerDieResult[myid] >= playerNumber[myid]){
1538 
1539             LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempBetValue[myid], 0, proof);                                
1540 
1541             /*  
1542             *  safe adjust contractBalance
1543             *  setMaxProfit
1544             *  send 1 wei to losing bet
1545             */
1546             contractBalance = safeAdd(contractBalance, (playerTempBetValue[myid]-1));                                                                         
1547 
1548             /* update maximum profit */
1549             setMaxProfit(); 
1550 
1551             /*
1552             * send 1 wei - external call to an untrusted contract                  
1553             */
1554             if(!playerTempAddress[myid].send(1)){
1555                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */                
1556                playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], 1);                                
1557             }                                   
1558 
1559             return;
1560 
1561         }
1562 
1563     }
1564     
1565     /*
1566     * public function
1567     * in case of a failed refund or win send
1568     */
1569     function playerWithdrawPendingTransactions() public 
1570         payoutsAreActive
1571         returns (bool)
1572      {
1573         uint withdrawAmount = playerPendingWithdrawals[msg.sender];
1574         playerPendingWithdrawals[msg.sender] = 0;
1575         /* external call to untrusted contract */
1576         if (msg.sender.call.value(withdrawAmount)()) {
1577             return true;
1578         } else {
1579             /* if send failed revert playerPendingWithdrawals[msg.sender] = 0; */
1580             /* player can try to withdraw again later */
1581             playerPendingWithdrawals[msg.sender] = withdrawAmount;
1582             return false;
1583         }
1584     }
1585 
1586     /* check for pending withdrawals  */
1587     function playerGetPendingTxByAddress(address addressToCheck) public constant returns (uint) {
1588         return playerPendingWithdrawals[addressToCheck];
1589     }
1590 
1591     /*
1592     * internal function
1593     * sets max profit
1594     */
1595     function setMaxProfit() internal {
1596         maxProfit = (contractBalance*maxProfitAsPercentOfHouse)/maxProfitDivisor;  
1597     }   
1598 
1599     /*
1600     * owner/treasury address only functions
1601     */
1602     function ()
1603         payable
1604         onlyTreasury
1605     {
1606         /* safely update contract balance */
1607         contractBalance = safeAdd(contractBalance, msg.value);        
1608         /* update the maximum profit */
1609         setMaxProfit();
1610     } 
1611 
1612     /* set gas for oraclize query */
1613     function ownerSetOraclizeSafeGas(uint32 newSafeGasToOraclize) public 
1614 		onlyOwner
1615 	{
1616     	gasForOraclize = newSafeGasToOraclize;
1617     }
1618 
1619     /* set house cost to call oraclize query */
1620     function ownerUpdateCostToCallOraclize(uint newCostToCallOraclizeInWei) public 
1621 		onlyOwner
1622     {        
1623        costToCallOraclizeInWei = newCostToCallOraclizeInWei;
1624     }     
1625 
1626     /* only owner address can set houseEdge */
1627     function ownerSetHouseEdge(uint newHouseEdge) public 
1628 		onlyOwner
1629     {
1630         houseEdge = newHouseEdge;
1631     }
1632 
1633     /* only owner address can set maxProfitAsPercentOfHouse */
1634     function ownerSetMaxProfitAsPercentOfHouse(uint newMaxProfitAsPercent) public 
1635 		onlyOwner
1636     {
1637         /* restrict each bet to a maximum profit of 1% contractBalance */
1638         if(newMaxProfitAsPercent > 10000) throw;
1639         maxProfitAsPercentOfHouse = newMaxProfitAsPercent;
1640         setMaxProfit();
1641     }
1642 
1643     /* only owner address can set minBet */
1644     function ownerSetMinBet(uint newMinimumBet) public 
1645 		onlyOwner
1646     {
1647         minBet = newMinimumBet;
1648     }       
1649 
1650     /* only owner address can transfer ether */
1651     function ownerTransferEther(address sendTo, uint amount) public 
1652 		onlyOwner
1653     {        
1654         /* safely update contract balance when sending out funds*/
1655         contractBalance = safeSub(contractBalance, amount);		
1656         /* update max profit */
1657         setMaxProfit();
1658         if(!sendTo.send(amount)) throw;
1659         LogOwnerTransfer(sendTo, amount); 
1660     }
1661 
1662     /* only owner address can do manual refund
1663     * used only if bet placed + oraclize failed to __callback
1664     * filter LogBet by address and/or playerBetId:
1665     * LogBet(playerBetId[rngId], playerAddress[rngId], safeAdd(playerBetValue[rngId], playerProfit[rngId]), playerProfit[rngId], playerBetValue[rngId], playerNumber[rngId]);
1666     * check the following logs do not exist for playerBetId and/or playerAddress[rngId] before refunding:
1667     * LogResult or LogRefund
1668     * if LogResult exists player should use the withdraw pattern playerWithdrawPendingTransactions 
1669     */
1670     function ownerRefundPlayer(bytes32 originalPlayerBetId, address sendTo, uint originalPlayerProfit, uint originalPlayerBetValue) public 
1671 		onlyOwner
1672     {        
1673         /* safely reduce pendingPayouts by playerProfit[rngId] */
1674         maxPendingPayouts = safeSub(maxPendingPayouts, originalPlayerProfit);
1675         /* send refund */
1676         if(!sendTo.send(originalPlayerBetValue)) throw;
1677         /* log refunds */
1678         LogRefund(originalPlayerBetId, sendTo, originalPlayerBetValue);        
1679     }    
1680 
1681     /* only owner address can set emergency pause #1 */
1682     function ownerPauseGame(bool newStatus) public 
1683 		onlyOwner
1684     {
1685 		gamePaused = newStatus;
1686     }
1687 
1688     /* only owner address can set emergency pause #2 */
1689     function ownerPausePayouts(bool newPayoutStatus) public 
1690 		onlyOwner
1691     {
1692 		payoutsPaused = newPayoutStatus;
1693     } 
1694 
1695     /* only owner address can set treasury address */
1696     function ownerSetTreasury(address newTreasury) public 
1697 		onlyOwner
1698 	{
1699         treasury = newTreasury;
1700     }         
1701 
1702     /* only owner address can set owner address */
1703     function ownerChangeOwner(address newOwner) public 
1704 		onlyOwner
1705 	{
1706         owner = newOwner;
1707     }
1708 
1709     /* only owner address can suicide - emergency */
1710     function ownerkill() public 
1711 		onlyOwner
1712 	{
1713 		suicide(owner);
1714 	}    
1715 
1716 
1717 }