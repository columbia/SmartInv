1 pragma solidity ^0.4.11;
2 
3 /// math.sol -- mixin for inline numerical wizardry
4 
5 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
6 
7 // Licensed under the Apache License, Version 2.0 (the "License").
8 // You may not use this file except in compliance with the License.
9 
10 // Unless required by applicable law or agreed to in writing, software
11 // distributed under the License is distributed on an "AS IS" BASIS,
12 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
13 
14 pragma solidity ^0.4.10;
15 
16 contract DSMath {
17     
18     /*
19     standard uint256 functions
20      */
21 
22     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
23         assert((z = x + y) >= x);
24     }
25 
26     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
27         assert((z = x - y) <= x);
28     }
29 
30     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
31         assert((z = x * y) >= x);
32     }
33 
34     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
35         z = x / y;
36     }
37 
38     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
39         return x <= y ? x : y;
40     }
41     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
42         return x >= y ? x : y;
43     }
44 
45     /*
46     uint128 functions (h is for half)
47      */
48 
49 
50     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
51         assert((z = x + y) >= x);
52     }
53 
54     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
55         assert((z = x - y) <= x);
56     }
57 
58     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
59         assert((z = x * y) >= x);
60     }
61 
62     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
63         z = x / y;
64     }
65 
66     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
67         return x <= y ? x : y;
68     }
69     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
70         return x >= y ? x : y;
71     }
72 
73 
74     /*
75     int256 functions
76      */
77 
78     function imin(int256 x, int256 y) constant internal returns (int256 z) {
79         return x <= y ? x : y;
80     }
81     function imax(int256 x, int256 y) constant internal returns (int256 z) {
82         return x >= y ? x : y;
83     }
84 
85     /*
86     WAD math
87      */
88 
89     uint128 constant WAD = 10 ** 18;
90 
91     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
92         return hadd(x, y);
93     }
94 
95     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
96         return hsub(x, y);
97     }
98 
99     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
100         z = cast((uint256(x) * y + WAD / 2) / WAD);
101     }
102 
103     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
104         z = cast((uint256(x) * WAD + y / 2) / y);
105     }
106 
107     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
108         return hmin(x, y);
109     }
110     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
111         return hmax(x, y);
112     }
113 
114     /*
115     RAY math
116      */
117 
118     uint128 constant RAY = 10 ** 27;
119 
120     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
121         return hadd(x, y);
122     }
123 
124     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
125         return hsub(x, y);
126     }
127 
128     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
129         z = cast((uint256(x) * y + RAY / 2) / RAY);
130     }
131 
132     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
133         z = cast((uint256(x) * RAY + y / 2) / y);
134     }
135 
136     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
137         // This famous algorithm is called "exponentiation by squaring"
138         // and calculates x^n with x as fixed-point and n as regular unsigned.
139         //
140         // It's O(log n), instead of O(n) for naive repeated multiplication.
141         //
142         // These facts are why it works:
143         //
144         //  If n is even, then x^n = (x^2)^(n/2).
145         //  If n is odd,  then x^n = x * x^(n-1),
146         //   and applying the equation for even x gives
147         //    x^n = x * (x^2)^((n-1) / 2).
148         //
149         //  Also, EVM division is flooring and
150         //    floor[(n-1) / 2] = floor[n / 2].
151 
152         z = n % 2 != 0 ? x : RAY;
153 
154         for (n /= 2; n != 0; n /= 2) {
155             x = rmul(x, x);
156 
157             if (n % 2 != 0) {
158                 z = rmul(z, x);
159             }
160         }
161     }
162 
163     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
164         return hmin(x, y);
165     }
166     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
167         return hmax(x, y);
168     }
169 
170     function cast(uint256 x) constant internal returns (uint128 z) {
171         assert((z = uint128(x)) == x);
172     }
173 
174 }
175 
176 // <ORACLIZE_API>
177 /*
178 Copyright (c) 2015-2016 Oraclize SRL
179 Copyright (c) 2016 Oraclize LTD
180 
181 
182 
183 Permission is hereby granted, free of charge, to any person obtaining a copy
184 of this software and associated documentation files (the "Software"), to deal
185 in the Software without restriction, including without limitation the rights
186 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
187 copies of the Software, and to permit persons to whom the Software is
188 furnished to do so, subject to the following conditions:
189 
190 
191 
192 The above copyright notice and this permission notice shall be included in
193 all copies or substantial portions of the Software.
194 
195 
196 
197 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
198 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
199 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
200 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
201 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
202 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
203 THE SOFTWARE.
204 */
205 
206 contract OraclizeI {
207     address public cbAddress;
208     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
209     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
210     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
211     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
212     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
213     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
214     function getPrice(string _datasource) returns (uint _dsprice);
215     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
216     function useCoupon(string _coupon);
217     function setProofType(byte _proofType);
218     function setConfig(bytes32 _config);
219     function setCustomGasPrice(uint _gasPrice);
220     function randomDS_getSessionPubKeyHash() returns(bytes32);
221 }
222 contract OraclizeAddrResolverI {
223     function getAddress() returns (address _addr);
224 }
225 contract usingOraclize {
226     uint constant day = 60*60*24;
227     uint constant week = 60*60*24*7;
228     uint constant month = 60*60*24*30;
229     byte constant proofType_NONE = 0x00;
230     byte constant proofType_TLSNotary = 0x10;
231     byte constant proofType_Android = 0x20;
232     byte constant proofType_Ledger = 0x30;
233     byte constant proofType_Native = 0xF0;
234     byte constant proofStorage_IPFS = 0x01;
235     uint8 constant networkID_auto = 0;
236     uint8 constant networkID_mainnet = 1;
237     uint8 constant networkID_testnet = 2;
238     uint8 constant networkID_morden = 2;
239     uint8 constant networkID_consensys = 161;
240 
241     OraclizeAddrResolverI OAR;
242 
243     OraclizeI oraclize;
244     modifier oraclizeAPI {
245         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
246         oraclize = OraclizeI(OAR.getAddress());
247         _;
248     }
249     modifier coupon(string code){
250         oraclize = OraclizeI(OAR.getAddress());
251         oraclize.useCoupon(code);
252         _;
253     }
254 
255     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
256         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
257             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
258             oraclize_setNetworkName("eth_mainnet");
259             return true;
260         }
261         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
262             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
263             oraclize_setNetworkName("eth_ropsten3");
264             return true;
265         }
266         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
267             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
268             oraclize_setNetworkName("eth_kovan");
269             return true;
270         }
271         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
272             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
273             oraclize_setNetworkName("eth_rinkeby");
274             return true;
275         }
276         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
277             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
278             return true;
279         }
280         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
281             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
282             return true;
283         }
284         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
285             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
286             return true;
287         }
288         return false;
289     }
290 
291     function __callback(bytes32 myid, string result) {
292         __callback(myid, result, new bytes(0));
293     }
294     function __callback(bytes32 myid, string result, bytes proof) {
295     }
296     
297     function oraclize_useCoupon(string code) oraclizeAPI internal {
298         oraclize.useCoupon(code);
299     }
300 
301     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
302         return oraclize.getPrice(datasource);
303     }
304 
305     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
306         return oraclize.getPrice(datasource, gaslimit);
307     }
308     
309     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
310         uint price = oraclize.getPrice(datasource);
311         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
312         return oraclize.query.value(price)(0, datasource, arg);
313     }
314     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
315         uint price = oraclize.getPrice(datasource);
316         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
317         return oraclize.query.value(price)(timestamp, datasource, arg);
318     }
319     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
320         uint price = oraclize.getPrice(datasource, gaslimit);
321         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
322         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
323     }
324     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
325         uint price = oraclize.getPrice(datasource, gaslimit);
326         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
327         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
328     }
329     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
330         uint price = oraclize.getPrice(datasource);
331         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
332         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
333     }
334     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
335         uint price = oraclize.getPrice(datasource);
336         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
337         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
338     }
339     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
340         uint price = oraclize.getPrice(datasource, gaslimit);
341         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
342         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
343     }
344     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
345         uint price = oraclize.getPrice(datasource, gaslimit);
346         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
347         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
348     }
349     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
350         uint price = oraclize.getPrice(datasource);
351         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
352         bytes memory args = stra2cbor(argN);
353         return oraclize.queryN.value(price)(0, datasource, args);
354     }
355     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
356         uint price = oraclize.getPrice(datasource);
357         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
358         bytes memory args = stra2cbor(argN);
359         return oraclize.queryN.value(price)(timestamp, datasource, args);
360     }
361     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
362         uint price = oraclize.getPrice(datasource, gaslimit);
363         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
364         bytes memory args = stra2cbor(argN);
365         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
366     }
367     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
368         uint price = oraclize.getPrice(datasource, gaslimit);
369         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
370         bytes memory args = stra2cbor(argN);
371         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
372     }
373     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
374         string[] memory dynargs = new string[](1);
375         dynargs[0] = args[0];
376         return oraclize_query(datasource, dynargs);
377     }
378     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
379         string[] memory dynargs = new string[](1);
380         dynargs[0] = args[0];
381         return oraclize_query(timestamp, datasource, dynargs);
382     }
383     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
384         string[] memory dynargs = new string[](1);
385         dynargs[0] = args[0];
386         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
387     }
388     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
389         string[] memory dynargs = new string[](1);
390         dynargs[0] = args[0];       
391         return oraclize_query(datasource, dynargs, gaslimit);
392     }
393     
394     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
395         string[] memory dynargs = new string[](2);
396         dynargs[0] = args[0];
397         dynargs[1] = args[1];
398         return oraclize_query(datasource, dynargs);
399     }
400     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
401         string[] memory dynargs = new string[](2);
402         dynargs[0] = args[0];
403         dynargs[1] = args[1];
404         return oraclize_query(timestamp, datasource, dynargs);
405     }
406     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
407         string[] memory dynargs = new string[](2);
408         dynargs[0] = args[0];
409         dynargs[1] = args[1];
410         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
411     }
412     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
413         string[] memory dynargs = new string[](2);
414         dynargs[0] = args[0];
415         dynargs[1] = args[1];
416         return oraclize_query(datasource, dynargs, gaslimit);
417     }
418     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
419         string[] memory dynargs = new string[](3);
420         dynargs[0] = args[0];
421         dynargs[1] = args[1];
422         dynargs[2] = args[2];
423         return oraclize_query(datasource, dynargs);
424     }
425     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
426         string[] memory dynargs = new string[](3);
427         dynargs[0] = args[0];
428         dynargs[1] = args[1];
429         dynargs[2] = args[2];
430         return oraclize_query(timestamp, datasource, dynargs);
431     }
432     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
433         string[] memory dynargs = new string[](3);
434         dynargs[0] = args[0];
435         dynargs[1] = args[1];
436         dynargs[2] = args[2];
437         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
438     }
439     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
440         string[] memory dynargs = new string[](3);
441         dynargs[0] = args[0];
442         dynargs[1] = args[1];
443         dynargs[2] = args[2];
444         return oraclize_query(datasource, dynargs, gaslimit);
445     }
446     
447     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
448         string[] memory dynargs = new string[](4);
449         dynargs[0] = args[0];
450         dynargs[1] = args[1];
451         dynargs[2] = args[2];
452         dynargs[3] = args[3];
453         return oraclize_query(datasource, dynargs);
454     }
455     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
456         string[] memory dynargs = new string[](4);
457         dynargs[0] = args[0];
458         dynargs[1] = args[1];
459         dynargs[2] = args[2];
460         dynargs[3] = args[3];
461         return oraclize_query(timestamp, datasource, dynargs);
462     }
463     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
464         string[] memory dynargs = new string[](4);
465         dynargs[0] = args[0];
466         dynargs[1] = args[1];
467         dynargs[2] = args[2];
468         dynargs[3] = args[3];
469         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
470     }
471     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
472         string[] memory dynargs = new string[](4);
473         dynargs[0] = args[0];
474         dynargs[1] = args[1];
475         dynargs[2] = args[2];
476         dynargs[3] = args[3];
477         return oraclize_query(datasource, dynargs, gaslimit);
478     }
479     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
480         string[] memory dynargs = new string[](5);
481         dynargs[0] = args[0];
482         dynargs[1] = args[1];
483         dynargs[2] = args[2];
484         dynargs[3] = args[3];
485         dynargs[4] = args[4];
486         return oraclize_query(datasource, dynargs);
487     }
488     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
489         string[] memory dynargs = new string[](5);
490         dynargs[0] = args[0];
491         dynargs[1] = args[1];
492         dynargs[2] = args[2];
493         dynargs[3] = args[3];
494         dynargs[4] = args[4];
495         return oraclize_query(timestamp, datasource, dynargs);
496     }
497     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
498         string[] memory dynargs = new string[](5);
499         dynargs[0] = args[0];
500         dynargs[1] = args[1];
501         dynargs[2] = args[2];
502         dynargs[3] = args[3];
503         dynargs[4] = args[4];
504         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
505     }
506     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
507         string[] memory dynargs = new string[](5);
508         dynargs[0] = args[0];
509         dynargs[1] = args[1];
510         dynargs[2] = args[2];
511         dynargs[3] = args[3];
512         dynargs[4] = args[4];
513         return oraclize_query(datasource, dynargs, gaslimit);
514     }
515     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
516         uint price = oraclize.getPrice(datasource);
517         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
518         bytes memory args = ba2cbor(argN);
519         return oraclize.queryN.value(price)(0, datasource, args);
520     }
521     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
522         uint price = oraclize.getPrice(datasource);
523         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
524         bytes memory args = ba2cbor(argN);
525         return oraclize.queryN.value(price)(timestamp, datasource, args);
526     }
527     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
528         uint price = oraclize.getPrice(datasource, gaslimit);
529         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
530         bytes memory args = ba2cbor(argN);
531         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
532     }
533     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
534         uint price = oraclize.getPrice(datasource, gaslimit);
535         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
536         bytes memory args = ba2cbor(argN);
537         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
538     }
539     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
540         bytes[] memory dynargs = new bytes[](1);
541         dynargs[0] = args[0];
542         return oraclize_query(datasource, dynargs);
543     }
544     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
545         bytes[] memory dynargs = new bytes[](1);
546         dynargs[0] = args[0];
547         return oraclize_query(timestamp, datasource, dynargs);
548     }
549     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
550         bytes[] memory dynargs = new bytes[](1);
551         dynargs[0] = args[0];
552         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
553     }
554     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
555         bytes[] memory dynargs = new bytes[](1);
556         dynargs[0] = args[0];       
557         return oraclize_query(datasource, dynargs, gaslimit);
558     }
559     
560     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
561         bytes[] memory dynargs = new bytes[](2);
562         dynargs[0] = args[0];
563         dynargs[1] = args[1];
564         return oraclize_query(datasource, dynargs);
565     }
566     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
567         bytes[] memory dynargs = new bytes[](2);
568         dynargs[0] = args[0];
569         dynargs[1] = args[1];
570         return oraclize_query(timestamp, datasource, dynargs);
571     }
572     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
573         bytes[] memory dynargs = new bytes[](2);
574         dynargs[0] = args[0];
575         dynargs[1] = args[1];
576         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
577     }
578     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
579         bytes[] memory dynargs = new bytes[](2);
580         dynargs[0] = args[0];
581         dynargs[1] = args[1];
582         return oraclize_query(datasource, dynargs, gaslimit);
583     }
584     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
585         bytes[] memory dynargs = new bytes[](3);
586         dynargs[0] = args[0];
587         dynargs[1] = args[1];
588         dynargs[2] = args[2];
589         return oraclize_query(datasource, dynargs);
590     }
591     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
592         bytes[] memory dynargs = new bytes[](3);
593         dynargs[0] = args[0];
594         dynargs[1] = args[1];
595         dynargs[2] = args[2];
596         return oraclize_query(timestamp, datasource, dynargs);
597     }
598     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
599         bytes[] memory dynargs = new bytes[](3);
600         dynargs[0] = args[0];
601         dynargs[1] = args[1];
602         dynargs[2] = args[2];
603         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
604     }
605     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
606         bytes[] memory dynargs = new bytes[](3);
607         dynargs[0] = args[0];
608         dynargs[1] = args[1];
609         dynargs[2] = args[2];
610         return oraclize_query(datasource, dynargs, gaslimit);
611     }
612     
613     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
614         bytes[] memory dynargs = new bytes[](4);
615         dynargs[0] = args[0];
616         dynargs[1] = args[1];
617         dynargs[2] = args[2];
618         dynargs[3] = args[3];
619         return oraclize_query(datasource, dynargs);
620     }
621     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
622         bytes[] memory dynargs = new bytes[](4);
623         dynargs[0] = args[0];
624         dynargs[1] = args[1];
625         dynargs[2] = args[2];
626         dynargs[3] = args[3];
627         return oraclize_query(timestamp, datasource, dynargs);
628     }
629     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
630         bytes[] memory dynargs = new bytes[](4);
631         dynargs[0] = args[0];
632         dynargs[1] = args[1];
633         dynargs[2] = args[2];
634         dynargs[3] = args[3];
635         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
636     }
637     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
638         bytes[] memory dynargs = new bytes[](4);
639         dynargs[0] = args[0];
640         dynargs[1] = args[1];
641         dynargs[2] = args[2];
642         dynargs[3] = args[3];
643         return oraclize_query(datasource, dynargs, gaslimit);
644     }
645     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
646         bytes[] memory dynargs = new bytes[](5);
647         dynargs[0] = args[0];
648         dynargs[1] = args[1];
649         dynargs[2] = args[2];
650         dynargs[3] = args[3];
651         dynargs[4] = args[4];
652         return oraclize_query(datasource, dynargs);
653     }
654     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
655         bytes[] memory dynargs = new bytes[](5);
656         dynargs[0] = args[0];
657         dynargs[1] = args[1];
658         dynargs[2] = args[2];
659         dynargs[3] = args[3];
660         dynargs[4] = args[4];
661         return oraclize_query(timestamp, datasource, dynargs);
662     }
663     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
664         bytes[] memory dynargs = new bytes[](5);
665         dynargs[0] = args[0];
666         dynargs[1] = args[1];
667         dynargs[2] = args[2];
668         dynargs[3] = args[3];
669         dynargs[4] = args[4];
670         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
671     }
672     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
673         bytes[] memory dynargs = new bytes[](5);
674         dynargs[0] = args[0];
675         dynargs[1] = args[1];
676         dynargs[2] = args[2];
677         dynargs[3] = args[3];
678         dynargs[4] = args[4];
679         return oraclize_query(datasource, dynargs, gaslimit);
680     }
681 
682     function oraclize_cbAddress() oraclizeAPI internal returns (address){
683         return oraclize.cbAddress();
684     }
685     function oraclize_setProof(byte proofP) oraclizeAPI internal {
686         return oraclize.setProofType(proofP);
687     }
688     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
689         return oraclize.setCustomGasPrice(gasPrice);
690     }
691     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
692         return oraclize.setConfig(config);
693     }
694     
695     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
696         return oraclize.randomDS_getSessionPubKeyHash();
697     }
698 
699     function getCodeSize(address _addr) constant internal returns(uint _size) {
700         assembly {
701             _size := extcodesize(_addr)
702         }
703     }
704 
705     function parseAddr(string _a) internal returns (address){
706         bytes memory tmp = bytes(_a);
707         uint160 iaddr = 0;
708         uint160 b1;
709         uint160 b2;
710         for (uint i=2; i<2+2*20; i+=2){
711             iaddr *= 256;
712             b1 = uint160(tmp[i]);
713             b2 = uint160(tmp[i+1]);
714             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
715             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
716             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
717             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
718             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
719             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
720             iaddr += (b1*16+b2);
721         }
722         return address(iaddr);
723     }
724 
725     function strCompare(string _a, string _b) internal returns (int) {
726         bytes memory a = bytes(_a);
727         bytes memory b = bytes(_b);
728         uint minLength = a.length;
729         if (b.length < minLength) minLength = b.length;
730         for (uint i = 0; i < minLength; i ++)
731             if (a[i] < b[i])
732                 return -1;
733             else if (a[i] > b[i])
734                 return 1;
735         if (a.length < b.length)
736             return -1;
737         else if (a.length > b.length)
738             return 1;
739         else
740             return 0;
741     }
742 
743     function indexOf(string _haystack, string _needle) internal returns (int) {
744         bytes memory h = bytes(_haystack);
745         bytes memory n = bytes(_needle);
746         if(h.length < 1 || n.length < 1 || (n.length > h.length))
747             return -1;
748         else if(h.length > (2**128 -1))
749             return -1;
750         else
751         {
752             uint subindex = 0;
753             for (uint i = 0; i < h.length; i ++)
754             {
755                 if (h[i] == n[0])
756                 {
757                     subindex = 1;
758                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
759                     {
760                         subindex++;
761                     }
762                     if(subindex == n.length)
763                         return int(i);
764                 }
765             }
766             return -1;
767         }
768     }
769 
770     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
771         bytes memory _ba = bytes(_a);
772         bytes memory _bb = bytes(_b);
773         bytes memory _bc = bytes(_c);
774         bytes memory _bd = bytes(_d);
775         bytes memory _be = bytes(_e);
776         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
777         bytes memory babcde = bytes(abcde);
778         uint k = 0;
779         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
780         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
781         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
782         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
783         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
784         return string(babcde);
785     }
786 
787     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
788         return strConcat(_a, _b, _c, _d, "");
789     }
790 
791     function strConcat(string _a, string _b, string _c) internal returns (string) {
792         return strConcat(_a, _b, _c, "", "");
793     }
794 
795     function strConcat(string _a, string _b) internal returns (string) {
796         return strConcat(_a, _b, "", "", "");
797     }
798 
799     // parseInt
800     function parseInt(string _a) internal returns (uint) {
801         return parseInt(_a, 0);
802     }
803 
804     // parseInt(parseFloat*10^_b)
805     function parseInt(string _a, uint _b) internal returns (uint) {
806         bytes memory bresult = bytes(_a);
807         uint mint = 0;
808         bool decimals = false;
809         for (uint i=0; i<bresult.length; i++){
810             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
811                 if (decimals){
812                    if (_b == 0) break;
813                     else _b--;
814                 }
815                 mint *= 10;
816                 mint += uint(bresult[i]) - 48;
817             } else if (bresult[i] == 46) decimals = true;
818         }
819         if (_b > 0) mint *= 10**_b;
820         return mint;
821     }
822 
823     function uint2str(uint i) internal returns (string){
824         if (i == 0) return "0";
825         uint j = i;
826         uint len;
827         while (j != 0){
828             len++;
829             j /= 10;
830         }
831         bytes memory bstr = new bytes(len);
832         uint k = len - 1;
833         while (i != 0){
834             bstr[k--] = byte(48 + i % 10);
835             i /= 10;
836         }
837         return string(bstr);
838     }
839     
840     function stra2cbor(string[] arr) internal returns (bytes) {
841             uint arrlen = arr.length;
842 
843             // get correct cbor output length
844             uint outputlen = 0;
845             bytes[] memory elemArray = new bytes[](arrlen);
846             for (uint i = 0; i < arrlen; i++) {
847                 elemArray[i] = (bytes(arr[i]));
848                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
849             }
850             uint ctr = 0;
851             uint cborlen = arrlen + 0x80;
852             outputlen += byte(cborlen).length;
853             bytes memory res = new bytes(outputlen);
854 
855             while (byte(cborlen).length > ctr) {
856                 res[ctr] = byte(cborlen)[ctr];
857                 ctr++;
858             }
859             for (i = 0; i < arrlen; i++) {
860                 res[ctr] = 0x5F;
861                 ctr++;
862                 for (uint x = 0; x < elemArray[i].length; x++) {
863                     // if there's a bug with larger strings, this may be the culprit
864                     if (x % 23 == 0) {
865                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
866                         elemcborlen += 0x40;
867                         uint lctr = ctr;
868                         while (byte(elemcborlen).length > ctr - lctr) {
869                             res[ctr] = byte(elemcborlen)[ctr - lctr];
870                             ctr++;
871                         }
872                     }
873                     res[ctr] = elemArray[i][x];
874                     ctr++;
875                 }
876                 res[ctr] = 0xFF;
877                 ctr++;
878             }
879             return res;
880         }
881 
882     function ba2cbor(bytes[] arr) internal returns (bytes) {
883             uint arrlen = arr.length;
884 
885             // get correct cbor output length
886             uint outputlen = 0;
887             bytes[] memory elemArray = new bytes[](arrlen);
888             for (uint i = 0; i < arrlen; i++) {
889                 elemArray[i] = (bytes(arr[i]));
890                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
891             }
892             uint ctr = 0;
893             uint cborlen = arrlen + 0x80;
894             outputlen += byte(cborlen).length;
895             bytes memory res = new bytes(outputlen);
896 
897             while (byte(cborlen).length > ctr) {
898                 res[ctr] = byte(cborlen)[ctr];
899                 ctr++;
900             }
901             for (i = 0; i < arrlen; i++) {
902                 res[ctr] = 0x5F;
903                 ctr++;
904                 for (uint x = 0; x < elemArray[i].length; x++) {
905                     // if there's a bug with larger strings, this may be the culprit
906                     if (x % 23 == 0) {
907                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
908                         elemcborlen += 0x40;
909                         uint lctr = ctr;
910                         while (byte(elemcborlen).length > ctr - lctr) {
911                             res[ctr] = byte(elemcborlen)[ctr - lctr];
912                             ctr++;
913                         }
914                     }
915                     res[ctr] = elemArray[i][x];
916                     ctr++;
917                 }
918                 res[ctr] = 0xFF;
919                 ctr++;
920             }
921             return res;
922         }
923         
924         
925     string oraclize_network_name;
926     function oraclize_setNetworkName(string _network_name) internal {
927         oraclize_network_name = _network_name;
928     }
929     
930     function oraclize_getNetworkName() internal returns (string) {
931         return oraclize_network_name;
932     }
933     
934     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
935         if ((_nbytes == 0)||(_nbytes > 32)) throw;
936         bytes memory nbytes = new bytes(1);
937         nbytes[0] = byte(_nbytes);
938         bytes memory unonce;
939         bytes memory sessionKeyHash;
940         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
941         assembly {
942             mstore(unonce, 0x20)
943             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
944             mstore(sessionKeyHash, 0x20)
945             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
946         }
947         bytes[3] memory args = [unonce, nbytes, sessionKeyHash]; 
948         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
949         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
950         return queryId;
951     }
952     
953     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
954         oraclize_randomDS_args[queryId] = commitment;
955     }
956     
957     mapping(bytes32=>bytes32) oraclize_randomDS_args;
958     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
959 
960     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
961         bool sigok;
962         address signer;
963         
964         bytes32 sigr;
965         bytes32 sigs;
966         
967         bytes memory sigr_ = new bytes(32);
968         uint offset = 4+(uint(dersig[3]) - 0x20);
969         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
970         bytes memory sigs_ = new bytes(32);
971         offset += 32 + 2;
972         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
973 
974         assembly {
975             sigr := mload(add(sigr_, 32))
976             sigs := mload(add(sigs_, 32))
977         }
978         
979         
980         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
981         if (address(sha3(pubkey)) == signer) return true;
982         else {
983             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
984             return (address(sha3(pubkey)) == signer);
985         }
986     }
987 
988     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
989         bool sigok;
990         
991         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
992         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
993         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
994         
995         bytes memory appkey1_pubkey = new bytes(64);
996         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
997         
998         bytes memory tosign2 = new bytes(1+65+32);
999         tosign2[0] = 1; //role
1000         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1001         bytes memory CODEHASH = hex"f5557abbf544c3db784d84e777d3ca2894372d5ae761c74aa9266231225f156c";
1002         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1003         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1004         
1005         if (sigok == false) return false;
1006         
1007         
1008         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1009         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1010         
1011         bytes memory tosign3 = new bytes(1+65);
1012         tosign3[0] = 0xFE;
1013         copyBytes(proof, 3, 65, tosign3, 1);
1014         
1015         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1016         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1017         
1018         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1019         
1020         return sigok;
1021     }
1022     
1023     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1024         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1025         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
1026         
1027         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1028         if (proofVerified == false) throw;
1029         
1030         _;
1031     }
1032     
1033     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
1034         bool match_ = true;
1035         
1036         for (var i=0; i<prefix.length; i++){
1037             if (content[i] != prefix[i]) match_ = false;
1038         }
1039         
1040         return match_;
1041     }
1042 
1043     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1044         bool checkok;
1045         
1046         
1047         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1048         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1049         bytes memory keyhash = new bytes(32);
1050         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1051         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
1052         if (checkok == false) return false;
1053         
1054         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1055         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1056         
1057         
1058         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1059         checkok = matchBytes32Prefix(sha256(sig1), result);
1060         if (checkok == false) return false;
1061         
1062         
1063         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1064         // This is to verify that the computed args match with the ones specified in the query.
1065         bytes memory commitmentSlice1 = new bytes(8+1+32);
1066         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1067         
1068         bytes memory sessionPubkey = new bytes(64);
1069         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1070         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1071         
1072         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1073         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1074             delete oraclize_randomDS_args[queryId];
1075         } else return false;
1076         
1077         
1078         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1079         bytes memory tosign1 = new bytes(32+8+1+32);
1080         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1081         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
1082         if (checkok == false) return false;
1083         
1084         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1085         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1086             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1087         }
1088         
1089         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1090     }
1091 
1092     
1093     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1094     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1095         uint minLength = length + toOffset;
1096 
1097         if (to.length < minLength) {
1098             // Buffer too small
1099             throw; // Should be a better way?
1100         }
1101 
1102         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1103         uint i = 32 + fromOffset;
1104         uint j = 32 + toOffset;
1105 
1106         while (i < (32 + fromOffset + length)) {
1107             assembly {
1108                 let tmp := mload(add(from, i))
1109                 mstore(add(to, j), tmp)
1110             }
1111             i += 32;
1112             j += 32;
1113         }
1114 
1115         return to;
1116     }
1117     
1118     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1119     // Duplicate Solidity's ecrecover, but catching the CALL return value
1120     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1121         // We do our own memory management here. Solidity uses memory offset
1122         // 0x40 to store the current end of memory. We write past it (as
1123         // writes are memory extensions), but don't update the offset so
1124         // Solidity will reuse it. The memory used here is only needed for
1125         // this context.
1126 
1127         // FIXME: inline assembly can't access return values
1128         bool ret;
1129         address addr;
1130 
1131         assembly {
1132             let size := mload(0x40)
1133             mstore(size, hash)
1134             mstore(add(size, 32), v)
1135             mstore(add(size, 64), r)
1136             mstore(add(size, 96), s)
1137 
1138             // NOTE: we can reuse the request memory because we deal with
1139             //       the return code
1140             ret := call(3000, 1, 0, size, 128, size, 32)
1141             addr := mload(size)
1142         }
1143   
1144         return (ret, addr);
1145     }
1146 
1147     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1148     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1149         bytes32 r;
1150         bytes32 s;
1151         uint8 v;
1152 
1153         if (sig.length != 65)
1154           return (false, 0);
1155 
1156         // The signature format is a compact form of:
1157         //   {bytes32 r}{bytes32 s}{uint8 v}
1158         // Compact means, uint8 is not padded to 32 bytes.
1159         assembly {
1160             r := mload(add(sig, 32))
1161             s := mload(add(sig, 64))
1162 
1163             // Here we are loading the last 32 bytes. We exploit the fact that
1164             // 'mload' will pad with zeroes if we overread.
1165             // There is no 'mload8' to do this, but that would be nicer.
1166             v := byte(0, mload(add(sig, 96)))
1167 
1168             // Alternative solution:
1169             // 'byte' is not working due to the Solidity parser, so lets
1170             // use the second best option, 'and'
1171             // v := and(mload(add(sig, 65)), 255)
1172         }
1173 
1174         // albeit non-transactional signatures are not specified by the YP, one would expect it
1175         // to match the YP range of [27, 28]
1176         //
1177         // geth uses [0, 1] and some clients have followed. This might change, see:
1178         //  https://github.com/ethereum/go-ethereum/issues/2053
1179         if (v < 27)
1180           v += 27;
1181 
1182         if (v != 27 && v != 28)
1183             return (false, 0);
1184 
1185         return safer_ecrecover(hash, v, r, s);
1186     }
1187         
1188 }
1189 // </ORACLIZE_API>
1190 
1191 contract LedgerProofVerifyI {
1192     function external_oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) public;
1193     function external_oraclize_randomDS_proofVerify(bytes proof, bytes32 queryId, bytes result, string context_name)  public returns (bool);
1194 }
1195 
1196 contract Owned {
1197     address public owner;
1198     
1199     modifier onlyOwner {
1200         assert(msg.sender == owner);
1201         _;
1202     }
1203     
1204     function Owned() {
1205         owner = msg.sender;
1206     }
1207 }
1208 
1209 contract oraclizeSettings is Owned {
1210 	uint constant ORACLIZE_PER_SPIN_GAS_LIMIT = 6100;
1211 	uint constant ORACLIZE_BASE_GAS_LIMIT = 200000;
1212 	uint safeGas = 9000;
1213 	
1214 	event newGasLimit(uint _gasLimit);
1215 
1216 	function setSafeGas(uint _gas) 
1217 		onlyOwner 
1218 	{
1219 	    assert(ORACLIZE_BASE_GAS_LIMIT + safeGas >= ORACLIZE_BASE_GAS_LIMIT);
1220 	    assert(safeGas <= 25000);
1221 		safeGas = _gas;
1222 		newGasLimit(_gas);
1223 	}	
1224 }
1225 
1226 contract HouseManaged is Owned {
1227     
1228     address public houseAddress;
1229     bool public isStopped;
1230 
1231     event LOG_ContractStopped();
1232     event LOG_ContractResumed();
1233     event LOG_OwnerAddressChanged(address oldAddr, address newOwnerAddress);
1234     event LOG_HouseAddressChanged(address oldAddr, address newHouseAddress);
1235     
1236     modifier onlyIfNotStopped {
1237         assert(!isStopped);
1238         _;
1239     }
1240 
1241     modifier onlyIfStopped {
1242         assert(isStopped);
1243         _;
1244     }
1245     
1246     function HouseManaged() {
1247         houseAddress = msg.sender;
1248     }
1249 
1250     function stop_or_resume_Contract(bool _isStopped)
1251         onlyOwner {
1252 
1253         isStopped = _isStopped;
1254     }
1255 
1256     function changeHouse_and_Owner_Addresses(address newHouse, address newOwner)
1257         onlyOwner {
1258 
1259         assert(newHouse != address(0x0));
1260         assert(newOwner != address(0x0));
1261         
1262         owner = newOwner;
1263         LOG_OwnerAddressChanged(owner, newOwner);
1264         
1265         houseAddress = newHouse;
1266         LOG_HouseAddressChanged(houseAddress, newHouse);
1267     }
1268 
1269 }
1270 
1271 contract usingInvestorsModule is HouseManaged, oraclizeSettings {
1272     
1273     uint constant MAX_INVESTORS = 5; //maximum number of investors
1274     uint constant divestFee = 50; //divest fee percentage (10000 = 100%)
1275 
1276      struct Investor {
1277         address investorAddress;
1278         uint amountInvested;
1279         bool votedForEmergencyWithdrawal;
1280     }
1281     
1282     //Starting at 1
1283     mapping(address => uint) public investorIDs;
1284     mapping(uint => Investor) public investors;
1285     uint public numInvestors = 0;
1286 
1287     uint public invested = 0;
1288     
1289     uint public investorsProfit = 0;
1290     uint public investorsLosses = 0;
1291     bool profitDistributed;
1292     
1293     event LOG_InvestorEntrance(address investor, uint amount);
1294     event LOG_InvestorCapitalUpdate(address investor, int amount);
1295     event LOG_InvestorExit(address investor, uint amount);
1296     event LOG_EmergencyAutoStop();
1297     
1298     event LOG_ZeroSend();
1299     event LOG_ValueIsTooBig();
1300     event LOG_FailedSend(address addr, uint value);
1301     event LOG_SuccessfulSend(address addr, uint value);
1302     
1303 
1304 
1305     modifier onlyMoreThanMinInvestment {
1306         assert(msg.value > getMinInvestment());
1307         _;
1308     }
1309 
1310     modifier onlyMoreThanZero {
1311         assert(msg.value != 0);
1312         _;
1313     }
1314 
1315     
1316     modifier onlyInvestors {
1317         assert(investorIDs[msg.sender] != 0);
1318         _;
1319     }
1320 
1321     modifier onlyNotInvestors {
1322         assert(investorIDs[msg.sender] == 0);
1323         _;
1324     }
1325     
1326     modifier investorsInvariant {
1327         _;
1328         assert(numInvestors <= MAX_INVESTORS);
1329     }
1330     
1331     modifier onlyIfProfitNotDistributed {
1332         if (!profitDistributed) {
1333             _;
1334         }
1335     }
1336     
1337     function getBankroll()
1338         constant
1339         returns(uint) {
1340 
1341         if ((invested < investorsProfit) ||
1342             (invested + investorsProfit < invested) ||
1343             (invested + investorsProfit < investorsLosses)) {
1344             return 0;
1345         }
1346         else {
1347             return invested + investorsProfit - investorsLosses;
1348         }
1349     }
1350 
1351     function getMinInvestment()
1352         constant
1353         returns(uint) {
1354 
1355         if (numInvestors == MAX_INVESTORS) {
1356             uint investorID = searchSmallestInvestor();
1357             return getBalance(investors[investorID].investorAddress);
1358         }
1359         else {
1360             return 0;
1361         }
1362     }
1363 
1364     function getLossesShare(address currentInvestor)
1365         constant
1366         returns (uint) {
1367 
1368         return investors[investorIDs[currentInvestor]].amountInvested * (investorsLosses) / invested;
1369     }
1370 
1371     function getProfitShare(address currentInvestor)
1372         constant
1373         returns (uint) {
1374 
1375         return investors[investorIDs[currentInvestor]].amountInvested * (investorsProfit) / invested;
1376     }
1377 
1378     function getBalance(address currentInvestor)
1379         constant
1380         returns (uint) {
1381 
1382         uint invested = investors[investorIDs[currentInvestor]].amountInvested;
1383         uint profit = getProfitShare(currentInvestor);
1384         uint losses = getLossesShare(currentInvestor);
1385 
1386         if ((invested + profit < profit) ||
1387             (invested + profit < invested) ||
1388             (invested + profit < losses))
1389             return 0;
1390         else
1391             return invested + profit - losses;
1392     }
1393 
1394     function searchSmallestInvestor()
1395         constant
1396         returns(uint) {
1397 
1398         uint investorID = 1;
1399         for (uint i = 1; i <= numInvestors; i++) {
1400             if (getBalance(investors[i].investorAddress) < getBalance(investors[investorID].investorAddress)) {
1401                 investorID = i;
1402             }
1403         }
1404 
1405         return investorID;
1406     }
1407 
1408     
1409     function addInvestorAtID(uint id)
1410         private {
1411 
1412         investorIDs[msg.sender] = id;
1413         investors[id].investorAddress = msg.sender;
1414         investors[id].amountInvested = msg.value;
1415         invested += msg.value;
1416 
1417         LOG_InvestorEntrance(msg.sender, msg.value);
1418     }
1419 
1420     function profitDistribution()
1421         private
1422         onlyIfProfitNotDistributed {
1423 
1424         uint copyInvested;
1425 
1426         for (uint i = 1; i <= numInvestors; i++) {
1427             address currentInvestor = investors[i].investorAddress;
1428             uint profitOfInvestor = getProfitShare(currentInvestor);
1429             uint lossesOfInvestor = getLossesShare(currentInvestor);
1430             //Check for overflow and underflow
1431             if ((investors[i].amountInvested + profitOfInvestor >= investors[i].amountInvested) &&
1432                 (investors[i].amountInvested + profitOfInvestor >= lossesOfInvestor))  {
1433                 investors[i].amountInvested += profitOfInvestor - lossesOfInvestor;
1434                 LOG_InvestorCapitalUpdate(currentInvestor, (int) (profitOfInvestor - lossesOfInvestor));
1435             }
1436             else {
1437                 isStopped = true;
1438                 LOG_EmergencyAutoStop();
1439             }
1440 
1441             if (copyInvested + investors[i].amountInvested >= copyInvested)
1442                 copyInvested += investors[i].amountInvested;
1443         }
1444 
1445         delete investorsProfit;
1446         delete investorsLosses;
1447         invested = copyInvested;
1448 
1449         profitDistributed = true;
1450     }
1451     
1452     function increaseInvestment()
1453         payable
1454         onlyIfNotStopped
1455         onlyMoreThanZero
1456         onlyInvestors  {
1457 
1458         profitDistribution();
1459         investors[investorIDs[msg.sender]].amountInvested += msg.value;
1460         invested += msg.value;
1461     }
1462 
1463     function newInvestor()
1464         payable
1465         onlyIfNotStopped
1466         onlyMoreThanZero
1467         onlyNotInvestors
1468         onlyMoreThanMinInvestment
1469         investorsInvariant {
1470 
1471         profitDistribution();
1472 
1473         if (numInvestors == MAX_INVESTORS) {
1474             uint smallestInvestorID = searchSmallestInvestor();
1475             divest(investors[smallestInvestorID].investorAddress);
1476         }
1477 
1478         numInvestors++;
1479         addInvestorAtID(numInvestors);
1480     }
1481 
1482     function divest()
1483         onlyInvestors {
1484 
1485         divest(msg.sender);
1486     }
1487 
1488 
1489     function divest(address currentInvestor)
1490         internal
1491         investorsInvariant {
1492 
1493         profitDistribution();
1494         uint currentID = investorIDs[currentInvestor];
1495         uint amountToReturn = getBalance(currentInvestor);
1496 
1497         if ((invested >= investors[currentID].amountInvested)) {
1498             invested -= investors[currentID].amountInvested;
1499             uint divestFeeAmount =  (amountToReturn*divestFee)/10000;
1500             amountToReturn -= divestFeeAmount;
1501 
1502             delete investors[currentID];
1503             delete investorIDs[currentInvestor];
1504 
1505             //Reorder investors
1506             if (currentID != numInvestors) {
1507                 // Get last investor
1508                 Investor lastInvestor = investors[numInvestors];
1509                 //Set last investor ID to investorID of divesting account
1510                 investorIDs[lastInvestor.investorAddress] = currentID;
1511                 //Copy investor at the new position in the mapping
1512                 investors[currentID] = lastInvestor;
1513                 //Delete old position in the mappping
1514                 delete investors[numInvestors];
1515             }
1516 
1517             numInvestors--;
1518             safeSend(currentInvestor, amountToReturn);
1519             safeSend(houseAddress, divestFeeAmount);
1520             LOG_InvestorExit(currentInvestor, amountToReturn);
1521         } else {
1522             isStopped = true;
1523             LOG_EmergencyAutoStop();
1524         }
1525     }
1526     
1527     function forceDivestOfAllInvestors()
1528         onlyOwner {
1529             
1530         uint copyNumInvestors = numInvestors;
1531         for (uint i = 1; i <= copyNumInvestors; i++) {
1532             divest(investors[1].investorAddress);
1533         }
1534     }
1535     
1536     function safeSend(address addr, uint value)
1537         internal {
1538 
1539         if (value == 0) {
1540             LOG_ZeroSend();
1541             return;
1542         }
1543 
1544         if (this.balance < value) {
1545             LOG_ValueIsTooBig();
1546             return;
1547         }
1548 
1549         if (!(addr.call.gas(safeGas).value(value)())) {
1550             LOG_FailedSend(addr, value);
1551             if (addr != houseAddress) {
1552                 //Forward to house address all change
1553                 if (!(houseAddress.call.gas(safeGas).value(value)())) LOG_FailedSend(houseAddress, value);
1554             }
1555         }
1556 
1557         LOG_SuccessfulSend(addr,value);
1558     }
1559 }
1560 
1561 contract EmergencyWithdrawalModule is usingInvestorsModule {
1562     uint constant EMERGENCY_WITHDRAWAL_RATIO = 80; //ratio percentage (100 = 100%)
1563     uint constant EMERGENCY_TIMEOUT = 3 days;
1564     
1565     struct WithdrawalProposal {
1566         address toAddress;
1567         uint atTime;
1568     }
1569     
1570     WithdrawalProposal public proposedWithdrawal;
1571     
1572     event LOG_EmergencyWithdrawalProposed();
1573     event LOG_EmergencyWithdrawalFailed(address withdrawalAddress);
1574     event LOG_EmergencyWithdrawalSucceeded(address withdrawalAddress, uint amountWithdrawn);
1575     event LOG_EmergencyWithdrawalVote(address investor, bool vote);
1576     
1577     modifier onlyAfterProposed {
1578         assert(proposedWithdrawal.toAddress != 0);
1579         _;
1580     }
1581     
1582     modifier onlyIfEmergencyTimeOutHasPassed {
1583         assert(proposedWithdrawal.atTime + EMERGENCY_TIMEOUT <= now);
1584         _;
1585     }
1586     
1587     function voteEmergencyWithdrawal(bool vote)
1588         onlyInvestors
1589         onlyAfterProposed
1590         onlyIfStopped {
1591 
1592         investors[investorIDs[msg.sender]].votedForEmergencyWithdrawal = vote;
1593         LOG_EmergencyWithdrawalVote(msg.sender, vote);
1594     }
1595 
1596     function proposeEmergencyWithdrawal(address withdrawalAddress)
1597         onlyIfStopped
1598         onlyOwner {
1599 
1600         //Resets previous votes
1601         for (uint i = 1; i <= numInvestors; i++) {
1602             delete investors[i].votedForEmergencyWithdrawal;
1603         }
1604 
1605         proposedWithdrawal = WithdrawalProposal(withdrawalAddress, now);
1606         LOG_EmergencyWithdrawalProposed();
1607     }
1608 
1609     function executeEmergencyWithdrawal()
1610         onlyOwner
1611         onlyAfterProposed
1612         onlyIfStopped
1613         onlyIfEmergencyTimeOutHasPassed {
1614 
1615         uint numOfVotesInFavour;
1616         uint amountToWithdraw = this.balance;
1617 
1618         for (uint i = 1; i <= numInvestors; i++) {
1619             if (investors[i].votedForEmergencyWithdrawal == true) {
1620                 numOfVotesInFavour++;
1621                 delete investors[i].votedForEmergencyWithdrawal;
1622             }
1623         }
1624 
1625         if (numOfVotesInFavour >= EMERGENCY_WITHDRAWAL_RATIO * numInvestors / 100) {
1626             if (!proposedWithdrawal.toAddress.send(amountToWithdraw)) {
1627                 LOG_EmergencyWithdrawalFailed(proposedWithdrawal.toAddress);
1628             }
1629             else {
1630                 LOG_EmergencyWithdrawalSucceeded(proposedWithdrawal.toAddress, amountToWithdraw);
1631             }
1632         }
1633         else {
1634             revert();
1635         }
1636     }
1637     
1638         /*
1639     The owner can use this function to force the exit of an investor from the
1640     contract during an emergency withdrawal in the following situations:
1641         - Unresponsive investor
1642         - Investor demanding to be paid in other to vote, the facto-blackmailing
1643         other investors
1644     */
1645     function forceDivestOfOneInvestor(address currentInvestor)
1646         onlyOwner
1647         onlyIfStopped {
1648 
1649         divest(currentInvestor);
1650         //Resets emergency withdrawal proposal. Investors must vote again
1651         delete proposedWithdrawal;
1652     }
1653 }
1654 
1655 contract Slot is usingOraclize, EmergencyWithdrawalModule, DSMath {
1656     
1657     uint constant INVESTORS_EDGE = 200; 
1658     uint constant HOUSE_EDGE = 50;
1659     uint constant CAPITAL_RISK = 250;
1660     uint constant MAX_SPINS = 16;
1661     
1662     uint minBet = 1 wei;
1663  
1664     struct SpinsContainer {
1665         address playerAddress;
1666         uint nSpins;
1667         uint amountWagered;
1668     }
1669     
1670     mapping (bytes32 => SpinsContainer) spins;
1671     
1672     /* Both arrays are ordered:
1673      - probabilities are ordered from smallest to highest
1674      - multipliers are ordered from highest to lowest
1675      The probabilities are expressed as integer numbers over a scale of 10000: i.e
1676      100 is equivalent to 1%, 5000 to 50% and so on.
1677     */
1678     uint[] public probabilities;
1679     uint[] public multipliers;
1680     
1681     uint public totalAmountWagered; 
1682     
1683     event LOG_newSpinsContainer(bytes32 myid, address playerAddress, uint amountWagered, uint nSpins);
1684     event LOG_SpinExecuted(bytes32 myid, address playerAddress, uint spinIndex, uint numberDrawn);
1685     event LOG_SpinsContainerInfo(bytes32 myid, address playerAddress, uint netPayout);
1686     LedgerProofVerifyI externalContract;
1687     
1688     function Slot(address _verifierAddr) {
1689         externalContract = LedgerProofVerifyI(_verifierAddr);
1690     }
1691     
1692     //SECTION I: MODIFIERS AND HELPER FUNCTIONS
1693     
1694     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1695         externalContract.external_oraclize_randomDS_setCommitment(queryId, commitment);
1696     }
1697     
1698     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1699         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1700         //if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
1701         assert(externalContract.external_oraclize_randomDS_proofVerify(_proof, _queryId, bytes(_result), oraclize_getNetworkName()));
1702         _;
1703     }
1704 
1705     modifier onlyOraclize {
1706         assert(msg.sender == oraclize_cbAddress());
1707         _;
1708     }
1709 
1710     modifier onlyIfSpinsExist(bytes32 myid) {
1711         assert(spins[myid].playerAddress != address(0x0));
1712         _;
1713     }
1714     
1715     function isValidSize(uint _amountWagered) 
1716         constant 
1717         returns(bool) {
1718             
1719         uint netPotentialPayout = (_amountWagered * (10000 - INVESTORS_EDGE) * multipliers[0])/ 10000; 
1720         uint maxAllowedPayout = (CAPITAL_RISK * getBankroll())/10000;
1721         
1722         return ((netPotentialPayout <= maxAllowedPayout) && (_amountWagered >= minBet));
1723     }
1724 
1725     modifier onlyIfEnoughFunds(bytes32 myid) {
1726         if (isValidSize(spins[myid].amountWagered)) {
1727              _;
1728         }
1729         else {
1730             safeSend(spins[myid].playerAddress, spins[myid].amountWagered);
1731             delete spins[myid];
1732             return;
1733         }
1734     }
1735     
1736 	modifier onlyLessThanMaxSpins (uint _nSpins) {
1737         assert(_nSpins <= MAX_SPINS);
1738         _;
1739     }
1740     
1741     /*
1742         For the game to be fair, the total gross payout over a large number of 
1743         individual slot spins should be the total amount wagered by the player. 
1744         
1745         The game owner, called house, and the investors will gain by applying 
1746         a small fee, called edge, to the amount won by the player in the case of
1747         a successful spin. 
1748         
1749         The total gross expected payout is equal to the sum of all payout. Each 
1750         i-th payout is calculated:
1751                     amountWagered * multipliers[i] * probabilities[i] 
1752         The resulting equation is:
1753                     sum of aW * m[i] * p[i] = aW
1754         After having simplified the equation:
1755                         sum of m[i] * p[i] = 1
1756         Since our probabilities are defined over 10000, the sum should be 10000.
1757         
1758         The contract owner can modify the multipliers and probabilities array, 
1759         but the  modifier enforces that the number choosen always result in a 
1760         fare game.
1761     */
1762     modifier onlyIfFair(uint[] _prob, uint[] _payouts) {
1763         if (_prob.length != _payouts.length) revert();
1764         uint sum = 0;
1765         for (uint i = 0; i <_prob.length; i++) {
1766             sum += _prob[i] * _payouts[i];     
1767         }
1768         assert(sum == 10000);
1769         _;
1770     }
1771 
1772     function()
1773         payable {
1774         buySpins(1);
1775     }
1776 
1777     function buySpins(uint _nSpins) 
1778         payable 
1779         onlyLessThanMaxSpins(_nSpins) 
1780 		onlyIfNotStopped {
1781             
1782         uint gas = _nSpins*ORACLIZE_PER_SPIN_GAS_LIMIT + ORACLIZE_BASE_GAS_LIMIT + safeGas;
1783         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("random", gas);
1784         
1785         // Disallow bets that even when maximally winning are a loss for player 
1786         // due to oraclizeFee
1787         if (oraclizeFee/multipliers[0] + oraclizeFee >= msg.value) revert();
1788         
1789         uint amountWagered = msg.value - oraclizeFee;
1790         uint maxNetPotentialPayout = (amountWagered * (10000 - INVESTORS_EDGE) * multipliers[0])/10000; 
1791         uint maxAllowedPayout = (CAPITAL_RISK * getBankroll())/10000;
1792         
1793         if ((maxNetPotentialPayout <= maxAllowedPayout) && (amountWagered >= minBet)) {
1794             bytes32 queryId = oraclize_newRandomDSQuery(0, 2*_nSpins, gas);
1795              spins[queryId] = 
1796                 SpinsContainer(msg.sender,
1797                                     _nSpins,
1798                                     amountWagered
1799                                 );
1800             
1801             LOG_newSpinsContainer(queryId, msg.sender, amountWagered, _nSpins);
1802             totalAmountWagered += amountWagered;
1803         } else {
1804             revert();
1805         }
1806     }
1807     
1808     function executeSpins(bytes32 myid, bytes randomBytes) 
1809         private 
1810         returns(uint)
1811     {
1812         uint amountWon = 0;
1813         uint numberDrawn = 0;
1814         uint rangeUpperEnd = 0;
1815         uint nSpins = spins[myid].nSpins;
1816         
1817         for (uint i = 0; i < 2*nSpins; i += 2) {
1818             // A number between 0 and 2**16, normalized over 0 - 10000
1819             numberDrawn = ((uint(randomBytes[i])*256 + uint(randomBytes[i+1]))*10000)/2**16;
1820             rangeUpperEnd = 0;
1821             LOG_SpinExecuted(myid, spins[myid].playerAddress, i/2, numberDrawn);
1822             for (uint j = 0; j < probabilities.length; j++) {
1823                 rangeUpperEnd += probabilities[j];
1824                 if (numberDrawn < rangeUpperEnd) {
1825                     amountWon += (spins[myid].amountWagered * multipliers[j]) / nSpins;
1826                     break;
1827                 }
1828             }
1829         }
1830         return amountWon;
1831     }
1832     
1833     function sendPayout(bytes32 myid, uint payout) private {
1834 
1835         if (payout >= spins[myid].amountWagered) {
1836             investorsLosses += sub(payout, spins[myid].amountWagered);
1837             payout = (payout*(10000 - INVESTORS_EDGE))/10000;
1838         }
1839         else {
1840             uint tempProfit = add(investorsProfit, sub(spins[myid].amountWagered, payout));
1841             investorsProfit += (sub(spins[myid].amountWagered, payout)*(10000 - HOUSE_EDGE))/10000;
1842             safeSend(houseAddress, sub(tempProfit, investorsProfit));
1843         }
1844         
1845         LOG_SpinsContainerInfo(myid, spins[myid].playerAddress, payout);
1846         safeSend(spins[myid].playerAddress, payout);
1847     }
1848     
1849      function __callback(bytes32 myid, string result, bytes _proof) 
1850         onlyOraclize
1851         onlyIfSpinsExist(myid)
1852         onlyIfEnoughFunds(myid)
1853         oraclize_randomDS_proofVerify(myid, result, _proof)
1854     {
1855 		
1856         uint payout = executeSpins(myid, bytes(result));
1857         
1858         sendPayout(myid, payout);
1859         
1860         delete profitDistributed;
1861         delete spins[myid];
1862     }
1863     
1864     // SETTERS - SETTINGS ACCESSIBLE BY OWNER
1865     
1866     // Check ordering as well, since ordering assumptions are made in _callback 
1867     // and elsewhere
1868     function setConfiguration(uint[] _probabilities, uint[] _multipliers) 
1869         onlyOwner 
1870         onlyIfFair(_probabilities, _multipliers) {
1871                 
1872         oraclize_setProof(proofType_Ledger); //This is here to reduce gas cost as this function has to be called anyway for initialization
1873         
1874         delete probabilities;
1875         delete multipliers;
1876         
1877         uint lastProbability = 0;
1878         uint lastMultiplier = 2**256 - 1;
1879         
1880         for (uint i = 0; i < _probabilities.length; i++) {
1881             probabilities.push(_probabilities[i]);
1882             if (lastProbability >= _probabilities[i]) revert();
1883             lastProbability = _probabilities[i];
1884         }
1885         
1886         for (i = 0; i < _multipliers.length; i++) {
1887             multipliers.push(_multipliers[i]);
1888             if (lastMultiplier <= _multipliers[i]) revert();
1889             lastMultiplier = _multipliers[i];
1890         }
1891     }
1892     
1893     function setMinBet(uint _minBet) onlyOwner {
1894         minBet = _minBet;
1895     }
1896     
1897     // GETTERS - CONSTANT METHODS
1898     
1899     function getSpinsContainer(bytes32 myid)
1900         constant
1901         returns(address, uint) {
1902         return (spins[myid].playerAddress, spins[myid].amountWagered); 
1903     }
1904 
1905     // Returns minimal amount to wager to return a profit in case of max win
1906     function getMinAmountToWager(uint _nSpins)
1907         onlyLessThanMaxSpins(_nSpins)
1908         constant
1909 		returns(uint) {
1910         uint gas = _nSpins*ORACLIZE_PER_SPIN_GAS_LIMIT + ORACLIZE_BASE_GAS_LIMIT + safeGas;
1911         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("random", gas);
1912         return minBet + oraclizeFee/multipliers[0] + oraclizeFee;
1913     }
1914    
1915     function getMaxAmountToWager(uint _nSpins)
1916         onlyLessThanMaxSpins(_nSpins)
1917         constant
1918         returns(uint) {
1919 
1920         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("random", _nSpins*ORACLIZE_PER_SPIN_GAS_LIMIT + ORACLIZE_BASE_GAS_LIMIT + safeGas);
1921         uint maxWage =  (CAPITAL_RISK * getBankroll())*10000/((10000 - INVESTORS_EDGE)*10000*multipliers[0]);
1922         return maxWage + oraclizeFee;
1923     }
1924     
1925 }